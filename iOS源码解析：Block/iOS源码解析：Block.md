# iOS源码解析：Block

## 1.探究`Block`底层结构

首先，新建一个命令行项目,写上最简单的`block`代码

```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        void (^block)(void) = ^{
            
            NSLog(@"Hello World!");
        };
        
        block();
        
        return 0;
    }
    return 0;
}

```
使用`clang`命令，将该代码所在文件`main.m`转换成底层的`c++`代码

具体操作：`cd`到`main.m`目录下，使用命令`clang -rewrite-objc main.m`,这时候会在该目录下生成`main.cpp`文件

打开这个文件，直接拉到最底部，找到`main`函数，将一些扰乱分析的代码去掉（去掉类似`(void (*)()`的类型转换代码），简化下代码如下：

```
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 
        void (*block)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));

        ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
        // 简化下代码，方便理解
        // 把强制类型转换的代码去掉
        
        // block声明
        void (*block)(void) = &__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA);
        
        // block调用块内容
        block->FuncPtr(block);
    }
    return 0;
}
```

可以看到`void (*block)(void) = &__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA);`是声明`block`，那么他是如何声明的呢？

是调用了`__main_block_impl_0 `函数，这个函数应该就是返回了一个`block`对象，那么这就是`block`的本质了，我们继续在`main.cpp`中搜下这个函数，看看这个函数返回值是什么类型

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

```

我们搜索后发现，`__main_block_impl_0 `其实是这个结构体，刚用到的`__main_block_impl_0 `是结构体中的函数(作用：初始化结构体的函数)

> c++的结构体语法

那么，到这里我们可以知道，`block`的本质就是一个结构体`__main_block_impl_0 `

那么接下来我们知道他是个什么东西了，应该也比较好奇，这个东西长什么样吧。

我们先大概的瞄一眼，`__main_block_impl_0 `这个结构体的组成：

- `struct __block_impl impl`
- `struct __main_block_desc_0* Desc`

它包含了两个结构体，我们再去搜下`main.cpp`，继续揪下去，看看这两个结构体是什么东西

```
struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};

```

到这里看到这两个结构体，一开始我也看不出是干嘛用的，但是现在我们已经大概的知道了`block`的本质是`__main_block_impl_0 `这个结构体，然后这个结构体的组成是由两个小结构体组成的，然后我们就卡住了，这两个小结构是干嘛用的，`block`实现方法的回调是怎么做到的.....还有一系列的问题，先不急，先暂存这块，让我们再回到一开始的地方。

`block`的声明和调用

```
void (*block)(void) = &__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA);

block->FuncPtr(block);

```

我们看到`__main_block_impl_0`函数传了两个参数`__main_block_func_0 `和`&__main_block_desc_0_DATA`,我们一个一个来，还是老方法，继续在`main.cpp`中搜下`__main_block_func_0 `

```
static void __main_block_func_0(struct __main_block_impl_0 *__cself)
{
NSLog((NSString *)&__NSConstantStringImpl__var_folders_cy_nyx4t0n94m31zjvjp52g6hyw0000gn_T_main_6fefb1_mi_0);
}
```

发现`__main_block_func_0 `是一个函数，我们看里面的实现有`NSLog`，刚才我们的`Block`实现是最简单的实现,也就是`NSLog`而已，所以这里大概可以猜到，这个函数就是将`block`的实现封装了进来

看如下的代码，传进去的第一个参数fp，现在我们知道这个是一个指向`block`实现的函数指针，在这个代码中，他将这个函数指针赋给了`__block_impl `结构体的变量`FuncPtr`;

那么到这里也就大概明白了，`__block_impl `结构体主要是用来存放函数指针的

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};

```

继续看第二个参数`__main_block_desc_0_DATA`

```
static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};

```

这个结构体中0赋值给了`reserved `，`sizeof(struct __main_block_impl_0)`赋值给了`Block_size `；

从这里可以看出这个结构体是存放`block`的信息的，比如大小(`Block_size `)

> `reserved `目前看不出是什么意思


到这里，我们就知道了一些结构体，以及`block`是怎么初始化的，大概的总结下

`block`的本质是`__main_block_impl_0 `结构体，这个结构体有两个成员变量，分别为`__block_impl `和`__main_block_desc_0 `结构体，这两个结构体分别的任务是存函数指针和`block`的信息

接下来继续看第二个代码`block->FuncPtr(block);`

这个是`block`调用的代码，那么从这个代码，我们很容易看出，`block`的回调，本质上就是`block`结构体，去调自己成员变量的指针(这个指针指向了`block`的实现)，简单点说，就是`block`实现回调，其实就是用函数指针，去调一个函数，具体的实现方式，流程，上面分析的就是这个过程了

首先看这句代码，我们有一个迷惑的，就是为什么这个结构体指针，可以直接调用成员变量的成员变量

正常应该这样block->impl->FuncPtr(block)

原因是我们简化的代码，不简化代码是酱紫的

```
((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
```

这里把`block`强制转换成`__block_impl `指针了，可以这样是因为`__block_impl `是这个结构体的第一个成员变量，而`block`指针指向的地址，其实也是第一个成员变量的，所以这里就直接强转就可以了。

> 但是平时开发业务代码，建议不要这么秀，该写的代码还是写上好

到这里，基本完结了，block是什么东西，怎么去实现回调，以及细节，基本都讲完，但是这里再提几个问题：


- `FuncPtr(block)`这个`__main_block_func_0 `函数，是需要传`__main_block_impl_0 `参数的，其实就是把`block`传给他，为啥要这样说合计，这种最简单的`block`没用到这个参数

- 如果这个`block`捕获了局部变量，static变量，全局变量，在实现上会有什么不同呢？

- 都说`block`是`oc`对象，那是对象就有类型，他是什么类型呢

- `block`是在堆，栈，程序的数据区域？

- `block`为啥会造成循环引用？

- `block`为啥要用`copy`？

看完这堆，是不是瑟瑟发抖了，>_<

> 深吸一口气，继续码下去

## 探究`block`捕获变量

### `block`捕获局部变量

```
int a = 10;
        
void (^block)(void) = ^{
            
      NSLog(@"%d", a);
};
        
a = 20;

block();

```

这个会输出什么呢？  10 or 20

局部变量a的值已经变成20了，再变成20之后，再调用block，为啥还是输出了10呢？

老办法，`clang`这个代码

```
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 
        int a = 10;

        void (*block)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, a));

        a = 20;

        ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
    }
    
    // 简化代码
    int a = 10;

    void (*block)(void) = &__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA, a);

    a = 20;

    block->FuncPtr(block);
    
    return 0;
}
```

我们发现，`__main_block_func_0 `函数跟刚才不一样了，比刚才多了一个参数`a`，再继续看下`__main_block_impl_0 `是什么情况了

```

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int a;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _a, int flags=0) : a(_a) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```

与刚才不同的是，这个结构体多了一个成员变量a，并且在初始化方法中，通过参数`int _a`给他赋值

> : a(_a)  c++语法  搜下”构造初始化列表“

这时候先提一个问题：这时候的a是多少？

答案是 10

这个就很简单了，因为是值传递，这时候`a=10`然后就走block的声明代码了

```

int a = 10;
        
void (^block)(void) = ^{
            
      NSLog(@"%d", a);
};
```

还是按着分析最简单`block`的步骤一样，看完`block`结构体，再看下实现`block`的函数`__main_block_func_0`

```

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  int a = __cself->a; // bound by copy

NSLog((NSString *)&__NSConstantStringImpl__var_folders_cy_nyx4t0n94m31zjvjp52g6hyw0000gn_T_main_0bcac1_mi_0, a);
}

```

这个函数里面，多了一个局部变量`a`，这个`a`的值是从参数`__cself`中取出来的，那么这时候也就可以回答刚才的一个问题。

**为啥这个函数设计要传一个block结构体的参数，原因就是为了通过这个结构体，拿到捕获的变量**

大概总结一下，捕获变量，就是在`block`的结构体中对应的生成一个成员变量来记录，然后实现的函数，可以通过参数`__cself`取到捕获的值

自然现在也知道为啥后面a改为20，触发`block`没有打印20了吧，因为`block`捕获局部变量的时候，是值传递，所以后面a的改变，不会影响捕获到的值

### `block`捕获静态变量

> 其实原理差不多，我码快一点了

```
static int a = 10;
        
void (^block)(void) = ^{
            
 NSLog(@"%d", a);
};
        
a = 20;
        
block();

```

这时候输出的结果是20，继续探究下是为啥


```
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 
        static int a = 10;

        void (*block)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, &a));

        a = 20;

        ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
    }
    return 0;
}

```

我们看下`__main_block_impl_0 `函数，传参是传了`&a`，其实就是将静态变量a的地址传进去，也就是地址传递，那么这种，在后面改变a为20，这时候的变量的值也会变，因为，这时候`block`是捕获了地址而不是值


### `block`捕获全局变量

```

int height = 10;
static int weight = 20;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        void (^block)(void) = ^{
            
            NSLog(@"%d %d", height, weight);
        };
        
        height = 30;
        weight = 40;
        
        block();
        
        return 0;
    }
}

```

打印结果：30  40

也就是说，全局变量改变是会影响到block捕获的值的

```
int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 
       void (*block)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));

        height = 30;
        weight = 40;

        ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);

        return 0;
    }
    return 0;
}

```

这时候的`__main_block_impl_0 `并没有将`height `和`weight `传参进去，再看下`block`的结构体怎么样

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```

这个结构体也没有生成`height `和`weight `的成员变量，是不是有点奇怪那他执行`block`实现的时候是怎么拿到`height `和`weight `的了吧，没事，继续看下实现的函数

```

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {


NSLog((NSString *)&__NSConstantStringImpl__var_folders_cy_nyx4t0n94m31zjvjp52g6hyw0000gn_T_main_92b4d2_mi_0, height, weight);
}

```
很明显了，对应这种全局变量，根本就不需要传值，因为直接取就可以了，那么这也解答了，对`height `和`weight `修改值后，block输出也有对应修改，因为这种不需要值传递，也不需要地址传递，直接去取就可以了，所以这时候`height `和`weight `是多少就可以取到多少

### 总结一下：

变量类型 | 是否捕获到block内部 | 访问方式 |
:-: | :-: | :-: | :-: | 
局部变量 | 是 | 值传递 | 
静态变量 | 是| 地址传递 | 
全局变量 | 否| 直接访问 | 

### 为啥对应不同变量，`block`处理方式不同

以下是引用别人的，我可以理解，但是没法写demo去验证

> 这是由变量的生命周期决定的。对于自动变量，当作用域结束时，会被系统自动回收，而block很可能是在超出自动变量作用域的时候去执行，如果之前没有捕获自动变量，那么后面执行的时候，自动变量已经被回收了，得不到正确的值。对于static局部变量，它的生命周期不会因为作用域结束而结束，所以block只需要捕获这个变量的地址，在执行的时候通过这个地址去获取变量的值，这样可以获得变量的最新的值。而对于全局变量，在任何位置都可以直接读取变量的值。

# `block`捕获`self`变量

```
- (void)test
{
    void (^block)(void) = ^{

        NSLog(@"%@",self);
    };

    block();
}
```

```
static void _I_Test_test(Test * self, SEL _cmd) {
    void (*block)(void) = ((void (*)())&__Test__test_block_impl_0((void *)__Test__test_block_func_0, &__Test__test_block_desc_0_DATA, self, 570425344));

    ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
}

```

`test`方法是传了两个参数`Test * self, SEL _cmd`，oc方法都是传这两个参数的，这两个叫做oc方法的隐性参数，所以`block`捕获`self`，那这里是什么传递，其实就是捕获了self这个指针

## `block`类型

接下来，研究下`block`的父类是啥,先将文件改为`MRC`，因为`ARC`下会自动帮我们`copy`到堆上，影响我们去分析

```

int c = 10;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        int a = 10;
        void (^block)(void) = ^{
            
            NSLog(@"Hello World!--%d", a);
        };
        
        block();
        
        
        NSLog(@"捕获局部的block%@\n %@\n %@\n %@", [block class], [[block class] superclass], [[[block class] superclass] superclass], [[[[block class] superclass] superclass] superclass]);
        
        void (^block1)(void) = ^{
            NSLog(@"aaa");
        };
        
        NSLog(@"啥都没有捕获的block:%@",[block1 class]);
        
        static int b = 10;
        void (^block2)(void) = ^{
            NSLog(@"aaa:%d",b);
        };
        
        NSLog(@"捕获静态变量的block:%@",[block2 class]);
        
        
        void (^block3)(void) = ^{
            NSLog(@"捕获全局变量的block:%d",c);
        };
        
        NSLog(@"捕获全局变量的block:%@",[block3 class]);
        
        
        NSLog(@"对__NSGlobalBlock__的block进行copy:%@",[[block3 copy] class]);
        
        NSLog(@"对block__NSStackBlock__的block进行copy:%@",[[block copy] class]);
        
        return 0;
        
    }
    return 0;
}

// 输出如下：

捕获局部的block__NSStackBlock__
 __NSStackBlock
 NSBlock
 NSObject
啥都没有捕获的block:__NSGlobalBlock__
捕获静态变量的block:__NSGlobalBlock__
捕获全局变量的block:__NSGlobalBlock__
对__NSGlobalBlock__的block进行copy:__NSGlobalBlock__
对block__NSStackBlock__的block进行copy:__NSMallocBlock__

```

因此可以看出，`block`还是源于`NSObject`，所以`block`也是一个`oc`对象

`MRC`下

捕获局部变量`block`类型为`__NSStackBlock__`，是存储在栈上的

没有捕获变量，捕获静态变量，全局变量，`block`类型为`__NSGlobalBlock__ `,是存储在程序的数据区

如果对`__NSGlobalBlock__ `类型的`block`进行`copy`操作，还是`__NSGlobalBlock__ `类型，但是对`block__NSStackBlock__ `类型的`block`进行`copy`就会变成`__NSMallocBlock__ `类型，是存储在堆上

`ARC`下的输出结果

```
捕获局部的block__NSMallocBlock__
 __NSMallocBlock
 NSBlock
 NSObject
啥都没有捕获的block:__NSGlobalBlock__
捕获静态变量的block:__NSGlobalBlock__
捕获全局变量的block:__NSGlobalBlock__
对__NSGlobalBlock__的block进行copy:__NSGlobalBlock__
对block__NSStackBlock__的block进行copy:__NSMallocBlock__
```

从输出结果可以看出：在`ARC`下，会自动将`__NSStackBlock__`的`block`进行`copy`让其变成堆上的`block`

**通过这个知识点，我们可以知道`MRC`下的`block`使用，如果是栈上`block`其实是一种很危险的存在的，为啥说他很危险呢，因为栈中的变量是出了作用域就会被释放的，但是`block`往往是用于回调的，所以可能存在出了作用域了，但是回调这个栈的`block`的时候，就会崩溃了，因为这个`block`已经释放了，那么这时候使用的这个指针其实是一个野指针了，这也就是为什么，`ARC`下会自动将栈上的`block`自动的`copy`下**

实验代码:

将项目改为`MRC`

```
__weak id ptr = nil;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int a = 10;
    void(^block)(void) = ^{
        NSLog(@"aaa--:%d",a);
    };
    
    ptr = [block copy];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    Block block = ptr;
    
    block();
}

```

如果这个`block`不用`copy`的话，那么回调的时候肯定崩溃，因为不`copy`的话，他是一个栈上的`block`，这时候回调已经野指针了，所以需要`copy`

**如果你的项目中遇到崩溃日志是蹦在block中，又是野指针的，又是MRC文件的话，那么十有八九就是这种情况了**

### 为啥`block`属性要用`copy`

`MRC`下之所以用`copy`，其实就是为了防止上面那种情况，如果你确定你的`block`是全局`block`那么用`retain`也行，但是做业务的时候，建议还是用`copy`稳妥

`ARC`下其实用`strong`和`copy`都一样了，因为`ARC`会自动`copy`，但是一般我们还是用`copy`，为啥，因为如果哪天这个文件改`MRC`了呢；第二,规范，统一，毕竟大家基本都是用`copy`

**block捕获__block的变量会怎么样呢？**

其实我们想下原理，__block


























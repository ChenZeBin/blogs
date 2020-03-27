
> 在KVC的实现中，依赖setter和getter的方法实现，所以方法命名应该符合苹果要求的规范，否则会导致KVC失败。

# setValue的过程

先看一个很有趣的问题

```

@interface ViewController ()

@property (nonatomic, strong) NSString *Str;
@property (nonatomic, strong) NSString *str;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 情况1
    self.Str = @"大写";
    self.str = @"小写";
    
    NSLog(@"str:%@----Str:%@",_str,_Str);
    
    // 输出  str:(null)----Str:小写
    
    // 情况2
//    self.Str = @"大写";
    self.str = @"小写";

    NSLog(@"str:%@----Str:%@",_str,_Str);
    
    // 输出  str:(null)----Str:小写
    
    
    // 情况3
    self.Str = @"大写";
//    self.str = @"小写";
    
    NSLog(@"str:%@----Str:%@",_str,_Str);
    
    // 输出   str:(null)----Str:大写
}

输出：(null)----123
```

也就是说，当有同名大小写属性时，遵守驼峰标识的属性会失效，也就是小写开头的属性

为什么小写开头的属性会失效呢？？？

我们从`setter`方法找起

我们会发现`oc`的`setter`方法是遵守驼峰标识的，比如`setStr:(NSString *)Str`

所以我的猜想：既然是`setStr`。。。。。那么有`_Str`的实例变量就优先给他赋值，没有就给`_str`赋值

我们尝试下

```
[self setValue:@"大写" forKey:@"Str"];
[self setValue:@"小写" forKey:@"str"];
```

结果还是一样

回归主题，我们调用`[self setValue:@"大写" forKey:@"Str"];`这个的时候，会先调用这个属性的set方法.

那么问题也来了，如果这时候的key是没有的属性或者nil，那么就会导致调用setKey的时候，找不到方法导致崩溃

所以，我们可以封装类似酱紫的安全方法

```
- (void)safeSetValue:(NSString *)value forKey:(NSString *)key
{
    if (![key isKindOfClass:[NSString class]])
    {
        return;
    }
    
    @try {
        [self setValue:value forKey:key];
    }@catch(NSException *exception){}@finally {}
}

```

没有找到`setKey:`方法的时候

KVC机制会检查
`+ (BOOL)accessInstanceVariablesDirectly`方法有没有返回YES，默认该方法会返回YES，如果你重写了该方法让其返回NO的话，那么在这一步KVC会执行`setValue：forUNdefinedKey:`方法

一般我们不会闲得蛋疼去重写`+ (BOOL)accessInstanceVariablesDirectly`方法，

所以这时候既然`setKey:`方法找不到了，就只能硬干了，直接去找对应的成员变量赋值，

所以说，就算是只读属性(只读属性没有set方法)，这时候用kvc也可以赋值，因为找不到`set`方法，直接对成员变量赋值

那如果找不到成员变量呢？？？

如果都没有找到，那么就只能调用`valueforUndefinedKey`和`setValue：forUNdefinedKey:`（没有定义这个key）抛异常

# 应用

1.

提一个问题：**``+ (BOOL)accessInstanceVariablesDirectly``**

什么时候重写这个方法，返回NO

但我们重写这个方法，返回NO的时候，外部对这个类进行kvc的时候，就没那么容易了，因为当找不到set方法，就直接失败了嘛

所以你想要这个类，足够封闭，安全的时候，可以重写这个方法，尤其是设置SDK的时候使用

2.

字典转模型

3.
服务端返回字段，有可能是id，或者其他oc的系统保留字段

那么就可以重写这方法，**在这块地方去统一处理**

```

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
```


# valueForKey：搜索过程

有点多，复杂

[这个文章讲得不错](http://www.cocoachina.com/articles/22441)

# Tips

如果valueForKeyPath:方法的调用者是数组，那么就是去访问数组元素的属性值

应用：模型转字典






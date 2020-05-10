## 目录

- 从主线程`runloop`啥时候开启
- `runloop`对象是怎么存储的
- `runloop`怎么跑起来的，又是怎么退出的
- `Runloop do-while`做了什么
- 监听`Runloop`的状态
- 常驻线程以及怎么销毁常驻线程
- `runloop`和`performSelector`
- 网络请求主线程回调，实现同步
- runloop优化tableview滚动坑点
- runloop卡顿监测
- `runloop`和`autoreleasepool`
- 界面更新

----

## 从主线程`runloop`啥时候开启

从`app`的`main`函数中的`UIApplicationMain`走进去，就一直在里面循环了，`NSLog(@"会走吗");`是不会被调用的

> 这里我就有一个疑惑：那为啥这个main还要return int类型呢？既然都死循环，return不了

```
int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    int i = UIApplicationMain(argc, argv, nil, appDelegateClassName);
    
    NSLog(@"会走吗");
    return i;
}

```

进入`UIApplicationMain`后，就会接着调用`application:didFinishLaunchingWithOptions:`方法，在这个方法里就开启`runloop`，通过监听`runloop`状态，在***即将进入runloop***回调打上断点，看堆栈即可得知


----

## `runloop`对象是怎么存储的

让`runloop`跑起来，得先获取`runloop`对象，我们从`CFRunloop.c`的源码中，找到`CFRunLoopGetCurrent`

```
CFRunLoopRef CFRunLoopGetMain(void) {
    CHECK_FOR_FORK();
    static CFRunLoopRef __main = NULL; // no retain needed
    if (!__main) __main = _CFRunLoopGet0(pthread_main_thread_np()); // no CAS needed
    return __main;
}

CFRunLoopRef CFRunLoopGetCurrent(void) {
    CHECK_FOR_FORK();
    CFRunLoopRef rl = (CFRunLoopRef)_CFGetTSD(__CFTSDKeyRunLoop);
    if (rl) return rl;
    return _CFRunLoopGet0(pthread_self());
}
```

从这两个方法，获取`Runloop`的入参是线程对象，可以判定，一一对应的关系，具体，我们再看下`_CFRunLoopGet0`的实现

```
CF_EXPORT CFRunLoopRef _CFRunLoopGet0(pthread_t t) {
    // 如果参数为空，那么就默认是主线程
    if (pthread_equal(t, kNilPthreadT)) {
        t = pthread_main_thread_np();
    }
    
    __CFLock(&loopsLock);
    
    // static CFMutableDictionaryRef __CFRunLoops = NULL;
    // 存放Runloop对象的字典
    // 先判断这个Runloop字典存在不，不存在就创建一个，并加主线程Runloop加进入
    if (!__CFRunLoops) {
        __CFUnlock(&loopsLock);
        
        CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorSystemDefault, 0, NULL, &kCFTypeDictionaryValueCallBacks);
        CFRunLoopRef mainLoop = __CFRunLoopCreate(pthread_main_thread_np());
        CFDictionarySetValue(dict, pthreadPointer(pthread_main_thread_np()), mainLoop);
        
        if (!OSAtomicCompareAndSwapPtrBarrier(NULL, dict, (void * volatile *)&__CFRunLoops)) {
            CFRelease(dict);
        }
        
        CFRelease(mainLoop);
        
        __CFLock(&loopsLock);
    }
    
    // 根据线程去这个字段取Runloop
    CFRunLoopRef loop = (CFRunLoopRef)CFDictionaryGetValue(__CFRunLoops, pthreadPointer(t));
    
    __CFUnlock(&loopsLock);
    
    // 如果不存在，就创建一个Runloop，并加到字典中
    if (!loop) {
        CFRunLoopRef newLoop = __CFRunLoopCreate(t);
        __CFLock(&loopsLock);
        loop = (CFRunLoopRef)CFDictionaryGetValue(__CFRunLoops, pthreadPointer(t));
        if (!loop) {
            CFDictionarySetValue(__CFRunLoops, pthreadPointer(t), newLoop);
            loop = newLoop;
        }
        // don't release run loops inside the loopsLock, because CFRunLoopDeallocate may end up taking it
        __CFUnlock(&loopsLock);
        CFRelease(newLoop);
    }
    if (pthread_equal(t, pthread_self())) {
        _CFSetTSD(__CFTSDKeyRunLoop, (void *)loop, NULL);
        if (0 == _CFGetTSD(__CFTSDKeyRunLoopCntr)) {
            _CFSetTSD(__CFTSDKeyRunLoopCntr, (void *)(PTHREAD_DESTRUCTOR_ITERATIONS-1), (void (*)(void *))__CFFinalizeRunLoop);
        }
    }
    return loop;
}

```

大概的代码逻辑就是

```
实现思路
1.先判断这个全局字典存不存在，不存在，创建一个，并将主线程的runloop加进去
2.直接去字典里取这个loop
3.如果loop不存在，就创建一个loop加入到全局字典中
// 伪代码
if(!__CFRunLoops) {
      1.创建全局字典
      2.创建主线程loop，并加入到全局字典中
}
根据线程pthread_t为key，去字典取对应的loop
if(!loop) {
      1.创建loop
      2.加入到字典中
}
return loop
```

所以：

- `runloop`对象和线程是一一对应的关系
- `runloop`对象是储存在一个全局字典中的，这个全局字段的`key`是线程对象，`value`是`runloop`对象

----

## `runloop`怎么跑起来的，又是怎么退出的

先说下`runloop`跑一圈是做了什么事情

首先`runloop`有六个状态变化

```

typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
    kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
    kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
    kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
    kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
    kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
};

```

![](http://ww1.sinaimg.cn/large/006fqBCpgy1gehy6nl80tj30zi0q6k78.jpg)

所以，当启动`runloop`的时候，就是监听输入源（端口port、source0、source1）、定时器、如果有事件，处理事件，没有就休眠

但是实际上并不是这样的，而是一直在重复的进入`runloop`

我们先从开启`runloop`的函数入手,从`CFRunLoopRun `函数，我们看到了`runloop`确实是一个`do-while`操作，那么里面的`CFRunLoopRunSpecific`每走一次，就算`runloop`迭代一次，那么这个`runloop`迭代一次后，会退出`runloop`,退出`runloop`后，因为`CFRunLoopRun `函数有`do-while`操作，所以又会重新进入`runloop`

```

void CFRunLoopRun(void) {	/* DOES CALLOUT */
    int32_t result;
    do {
        result = CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
        CHECK_FOR_FORK();
    } while (kCFRunLoopRunStopped != result && kCFRunLoopRunFinished != result);
}

```

`CFRunLoopRunSpecific`中做了一些前置判断，比如判断当前`Mode`为空，直接`return`，这个也可以说明一点***启动runloop之前，runloop中一定要有输入源或者定时器***

```
SInt32 CFRunLoopRunSpecific(CFRunLoopRef rl, CFStringRef modeName, CFTimeInterval seconds, Boolean returnAfterSourceHandled) {     /* DOES CALLOUT */

    ...
    
    //  前置判断，比如判断当前`Mode`为空，直接`return`
    if (NULL == currentMode || __CFRunLoopModeIsEmpty(rl, currentMode, rl->_currentMode)) {
        Boolean did = false;
        if (currentMode) __CFRunLoopModeUnlock(currentMode);
        __CFRunLoopUnlock(rl);
        return did ? kCFRunLoopRunHandledSource : kCFRunLoopRunFinished;
    }
    
    
   ...
   
    // 回调即将进入runloop
    if (currentMode->_observerMask & kCFRunLoopEntry ) __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopEntry);
    
    // 进入runloop
    result = __CFRunLoopRun(rl, currentMode, seconds, returnAfterSourceHandled, previousMode);
    
    // 即将退出runloop
    if (currentMode->_observerMask & kCFRunLoopExit ) __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);
    
    ...
    
    return result;
}
```
接下来再看下`__CFRunLoopRun `函数

```
// 简化代码，详细直接搜源码
static int32_t __CFRunLoopRun(CFRunLoopRef rl, CFRunLoopModeRef rlm, CFTimeInterval seconds, Boolean stopAfterHandle, CFRunLoopModeRef previousMode) {
	do {
		// 监听source、timer
		if (rlm->_observerMask & kCFRunLoopBeforeTimers) __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeTimers);
        if (rlm->_observerMask & kCFRunLoopBeforeSources) __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeSources);
        
       // 处理source0
       Boolean sourceHandledThisLoop = __CFRunLoopDoSources0(rl, rlm, stopAfterHandle);
       
       // 即将进入休眠
       if (!poll && (rlm->_observerMask & kCFRunLoopBeforeWaiting)) __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeWaiting);

		...
		
		 // 退出runloop的条件
		 if (sourceHandledThisLoop && stopAfterHandle) {
		 	  // 处理完source后sourceHandledThisLoop会为YES
		 	  // stopAfterHandle，如果是CFRunloop调用的话，是为NO
		 	  // 可以回头看下CFRunLoopRun函数
		 	  // 
            retVal = kCFRunLoopRunHandledSource;
        } else if (timeout_context->termTSR < mach_absolute_time()) {
            // 自身超时时间到了
            retVal = kCFRunLoopRunTimedOut;
        } else if (__CFRunLoopIsStopped(rl)) {
            // 被外部调用CFRunloop停止
            __CFRunLoopUnsetStopped(rl);
            retVal = kCFRunLoopRunStopped;
        } else if (rlm->_stopped) {
            // 被 _CFRunLoopStopMode 停止
            rlm->_stopped = false;
            retVal = kCFRunLoopRunStopped;
        } else if (__CFRunLoopModeIsEmpty(rl, rlm, previousMode)) { // 检查上一个 mode 有没有执行完所有事件源
            retVal = kCFRunLoopRunFinished;
        }
       
	} while(0 = retVal);
}

```

退出`runloop`有四个条件

- 入参`stopAfterHandle`为YES的时候，那么处理完`source`就会退出`runloop`
- 自身超时时间到了
- 被外部调用`CFRunloop`停止
- 被 `_CFRunLoopStopMode` 停止

`CFRunLoopRun `指定`stopAfterHandle `为`NO`,说明使用`run`方法开启`runloop`，处理完`source`后不会退出`runloop`

如果是使用`CFRunLoopRunInMode`则可以指定是否需要处理完`source`后就退出`runloop`

----

## `Runloop do-while`做了什么

`do-while`的过程中，做了以下操作

- 监听source（source1是基于port的线程通信(触摸/锁屏/摇晃等)，source0是不基于port的，包括：UIEvent、performSelector），监听到就处理
- 监听timer的事件，监听到就处理
- 没有source和timer的时候，就休眠，休眠不是不监听，还是保持监听的，只是当有事件的时候，才唤醒，继续处理

> 当我们触发了事件（触摸/锁屏/摇晃等）后，由IOKit.framework生成一个 IOHIDEvent事件，而IOKit是苹果的硬件驱动框架，由它进行底层接口的抽象封装与系统进行交互传递硬件感应的事件，并专门处理用户交互设备，由IOHIDServices和IOHIDDisplays两部分组成，其中IOHIDServices是专门处理用户交互的，它会将事件封装成IOHIDEvents对象，接着用mach port转发给需要的App进程，随后 Source1就会接收IOHIDEvent，之后再回调__IOHIDEventSystemClientQueueCallback()，__IOHIDEventSystemClientQueueCallback()内触发Source0，Source0 再触发 _UIApplicationHandleEventQueue()。所以触摸事件看到是在 Source0 内的。

***总结：触摸事件先通过 mach port 发送，封装为 source1，之后又转换为 source0***

1.一个`runloop`对应一个线程，多个`mode`，一个`mode`下对应多个`source`、`observer`、`timer`


```
struct __CFRunLoop {
    pthread_t _pthread; // 线程对象
    CFMutableSetRef _commonModes; // 
    CFMutableSetRef _commonModeItems;
    CFRunLoopModeRef _currentMode;
    CFMutableSetRef _modes;
    ...
    // 简化
};

struct __CFRunLoopMode {
    CFMutableSetRef _sources0;
    CFMutableSetRef _sources1;
    CFMutableArrayRef _observers;
    CFMutableArrayRef _timers;
    ...
    // 简化
};

```

2.常见有五种`mode`

- kCFRunLoopDefaultMode: App的默认 Mode，通常主线程是在这个 Mode 下运行的。
- UITrackingRunLoopMode: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响。
- UIInitializationRunLoopMode: 在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用。
- GSEventReceiveRunLoopMode: 接受系统事件的内部 Mode，通常用不到。
- kCFRunLoopCommonModes: 这是一个占位的 Mode，没有实际作用。

除了以上5个mode，还有其他mode，但是很少遇见[这里](http://iphonedevwiki.net/index.php/CFRunLoop)



4.子线程不自动开启`runloop`，手动开启`runloop`前，必须得有输入源和定时器（输入源就是通过监听端口，可以获取不同的事件），通过`CFRunloop`源码中的`CFRunLoopRunSpecific`函数，其中判断了当`mode`为`null`或者`modeItem`为空，直接`return`


### `runloop`和线程一一对应的关系


## 监听Runloop的状态

`runloop`有六大状态

```
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
    kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
    kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
    kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
    kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
    kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
};
```


可以通过这就代码监听这六个状态

```
CF_EXPORT CFRunLoopObserverRef CFRunLoopObserverCreate(CFAllocatorRef allocator, CFOptionFlags activities, Boolean repeats, CFIndex order, CFRunLoopObserverCallBack callout, CFRunLoopObserverContext *context);
```

其中的参数分别为

CFRunLoopObserverCreate参数

1.不懂  

2.监听runloop变化状态 

3.是否重复监听 

4.不懂，传0 

5.回调的函数指针(需要自己写一个函数)

6.CFRunLoopObserverContext对象

定义函数指针

```
static void runLoopOserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
   //void *info正是我们要用来与OC传值的,这边可以转成OC对象,前面我们传进来的时候是self
    RunloopObserver *target = (__bridge RunloopObserver *)(info);//void *info即是我们前面传递的self(ViewController)
    
    if (target.callback) {
        target.callback(observer, activity);
    }
}
```

定义`CFRunLoopObserverContext`对象,其实这个参数是用于通信的

```
// 从CFRunLoopObserverRef点进去找
    
    typedef struct {
        CFIndex    version; // 传0，不知道是什么
        void *    info; // 数据传递用的，void *，指就是可以接受所有指针
        const void *(*retain)(const void *info); // 引用
        void    (*release)(const void *info); // 回收
        CFStringRef    (*copyDescription)(const void *info); // 描述，没用到
    } CFRunLoopObserverContext;
```

创建监听

```
//创建一个监听
static CFRunLoopObserverRef observer;
    
// CFRunLoopObserverCreate参数。1.不懂  2.监听runloop变化状态  3.是否重复监听  4.不懂，传0 5.函数指针  6.CFRunLoopObserverContext对象
observer = CFRunLoopObserverCreate(NULL, kCFRunLoopAllActivities, YES, 0, &runLoopOserverCallBack, &context);
    
//注册监听
CFRunLoopAddObserver(runLoopRef, observer, kCFRunLoopCommonModes);
    
//销毁
CFRelease(observer);
    
```




## 常驻线程以及怎么销毁常驻线程

先说下`performSelector`和子线程的,`perform...AfterDelay`和`perform..onThread`都需要在开启`runloop`的线程执行

因为其实现原理，都是往`runloop`添加一个不重复的定时器

```
- (void)test1
{
    [self.myThread setName:@"StopRunloopThread"];
    self.myRunloop = [NSRunLoop currentRunLoop];
    
    // performSelector:afterDelay:的原理是往runloop添加不重复执行的定时器
    [self performSelector:@selector(performSelAferDelayClick) withObject:nil afterDelay:1];
    
    [self.myRunloop run];
    
    NSLog(@"我会走吗");
}
```

如果将开启`runloop`的代码，写到`perform`前，那么会开启不成功，因为开启`runloop`需要有输入源或者定时器的情况才可以开启

获取runloop会调用`CFRunLoopRunSpecific`函数（具体搜下`CFRunloop.c`）

从这个函数中找到以下代码，当currentMode为空的时候，（也就没有输入源或者定时器），直接`return kCFRunLoopRunFinished`,开启失败

```
if (NULL == currentMode || __CFRunLoopModeIsEmpty(rl, currentMode, rl->_currentMode)) {
	Boolean did = false;
	if (currentMode) __CFRunLoopModeUnlock(currentMode);
	__CFRunLoopUnlock(rl);
	return did ? kCFRunLoopRunHandledSource : kCFRunLoopRunFinished;
}
```

----

### 以下代码实现了一个常驻线程

原理就是往当前线程的`runloop`中添加一个端口，让其监听这个端口（理解为监听某个端口的输入源，比如系统内核端口，监听一些系统事件），因为可以一直监听这个端口，那么`runloop`就不会退出

> 其实就是保持runloop不退出，就达到常驻线程的效果了，那么要让runloop不退出，就得有输入源或者重复的定时器让其监听

```
- (void)test2
{
    [self.myThread setName:@"StopRunloopThread"];
    self.myRunloop = [NSRunLoop currentRunLoop];
    self.myPort = [NSMachPort port];
    
    [self.myRunloop addPort:self.myPort forMode:NSDefaultRunLoopMode];
    
    [self.myRunloop run];
    
    // 因为run之后，这个线程就一直在做do-while操作
    // 相当上面的代码被do-while包围了，那么以下代码不会走
    NSLog(@"我会走吗");
}
```

### 当开启一个线程，就会对应创建一个`runloop`对象吗？

不是的,调用获取当前`runloop`的方法，内部实现：如果当前`runloop`不存在就创建一个，存在就返回当前`runloop`

所以走这句代码`self.myRunloop = [NSRunLoop currentRunLoop];`就生成当前线程对应的`runloop`

----
### 怎么销毁常驻线程？

***1.要销毁常驻线程，首先得先把runloop退出？***

> 当没有输入源或者定时器可以监听的时候，退出`runloop`



如果我们调用`[NSThread exit];`,这时候线程是销毁了，但是线程中的代码还是不会执行,比如`NSLog(@"我会走吗");`,

说明这时候的`runloop`并没有退出，那么这样会导致一些问题，例如以下代码

```
- (void)test2
{
    [self.myThread setName:@"TestThread"];
    self.myRunloop = [NSRunLoop currentRunLoop];
    self.myPort = [NSMachPort port];
    
    // 添加监听NSMachPort的端口（这个端口可以理解为输入源，因为可以一直监听这个，所以这时候的runloop不会退出，会一直在做do-while）
    [self.myRunloop addPort:self.myPort forMode:NSDefaultRunLoopMode];
    
    [self.myRunloop run];
    
    // [self.myRunloop run]; 会导致以下代码没法走，因为runloop就是一个do-while的循环，do-while监听源，处理源
    [self.testPtr release];
}
```

因为`runloop`没有退出，`[self.testPtr release];`不会执行，那么就会导致`testPtr`对象没法释放

***2.怎么退出runloop呢***

如果常驻线程是通过监听端口实现的，那么就调用`[self.myRunloop removePort:self.myPort forMode:NSDefaultRunLoopMode];`,移除端口，就可以销毁了

> 其实这时候还不一定能成功销毁，因为可能系统加入了一些其他源的监听

如果是通过添加重复定时器，实现常驻线程（这种方式不可取，因为比添加监听端口耗性能，需要一次又一次的唤醒runloop）

```
- (void)test11
{
    [self.myThread setName:@"TestThread"];
    self.myRunloop = [NSRunLoop currentRunLoop];
    self.myPort = [NSMachPort port];
    
    // 首先，需要有一点，当runloop监视输入源或者定时器的时候，才不会退出
    // 开启runloop之前，需要有输入源或者定时器
    // 定时器（如果是添加定时器，不重复，那么监听一次就退出了）
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer执行");
    }];
    
    [self.myRunloop addTimer:timer forMode:NSDefaultRunLoopMode];
    
    
    
    [self.myRunloop run];
    
    // [self.myRunloop run]; 会导致以下代码没法走，因为runloop就是一个do-while的循环，do-while监听源，处理源
    NSLog(@"我会走吗");
    
}
```

如果`NSTimer`的`repeats`是`NO`,那么执行一次`timer`的事件后，就会退出`runloop`

以上，如果通过移除端口，结束timer，反正以移除已知的输入源或者定时器来退出`runloop`都是不太靠谱的，因为系统内部有可能会在当前线程的runloop中添加一些输入源，也就是还有未知的输入源，我们没有移除


***3.使用CFRunLoopStop退出Runloop***

```
- (void)test3
{
    [self.myThread setName:@"TestThread"];
    self.myRunloop = [NSRunLoop currentRunLoop];
    self.myPort = [NSMachPort port];
    
    // 添加监听NSMachPort的端口（这个端口可以理解为输入源，因为可以一直监听这个，所以这时候的runloop不会退出，会一直在做do-while）
    [self.myRunloop addPort:self.myPort forMode:NSDefaultRunLoopMode];
    [self performSelector:@selector(runloopStop) withObject:nil afterDelay:1];

    [self.myRunloop run];
    
    // [self.myRunloop run]; 会导致以下代码没法走，因为runloop就是一个do-while的循环，do-while监听源，处理源
    NSLog(@"我会走吗");
}

- (void)runloopStop
{
    NSLog(@"执行stop");
    CFRunLoopStop(self.myRunloop.getCFRunLoop);
}
```

输出：

```
2020-05-03 20:10:12.614130+0800 Runloop[60465:2827474] 即将进入Loop,
2020-05-03 20:10:12.614465+0800 Runloop[60465:2827474] 即将处理 Timer,
2020-05-03 20:10:12.615214+0800 Runloop[60465:2827474] 即将处理 Source,
2020-05-03 20:10:12.615634+0800 Runloop[60465:2827474] 即将进入休眠,
2020-05-03 20:10:13.615638+0800 Runloop[60465:2827474] 刚从休眠中唤醒,
2020-05-03 20:10:13.616005+0800 Runloop[60465:2827474] 执行stop
2020-05-03 20:10:13.616194+0800 Runloop[60465:2827474] 即将退出Loop,
2020-05-03 20:10:13.616360+0800 Runloop[60465:2827474] 即将进入Loop,
2020-05-03 20:10:13.616511+0800 Runloop[60465:2827474] 即将处理 Timer,
2020-05-03 20:10:13.616648+0800 Runloop[60465:2827474] 即将处理 Source,
2020-05-03 20:10:13.616765+0800 Runloop[60465:2827474] 即将进入休眠,

```

确实是退出了`runloop`，但是又马上进入了

原因是：

开启线程有三种方式

```
- (void)run;  
- (void)runUntilDate:(NSDate *)limitDate；
- (void)runMode:(NSString *)mode beforeDate:(NSDate *)limitDate;

```

`run`和`runUntilDate:`都会重复的调`runMode:beforeDate:`

具体的解释看[NSRunLoop的退出方式](https://juejin.im/entry/595f832c6fb9a06bc23a9d70)

所以刚才`stop`之后，确实是退出`runloop`了，但是因为我们是用`run`启动的，所以会重复的调用`runMode:beforeDate:`又启动了


***3.用`runMode:beforeDate:`启动`runloop`，再用`CFRunLoopStop`退出runloop试试***

将上一段代码`[self.myRunloop run];`替换成`[self.myRunloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];`

*****成功退出`runloop`并且线程`run`后的代码也走了，这时候通过打个暂停断点，看堆栈，发现我们的线程不在了，说明已经被销毁了（runloop退出后，线程没有任务，自然就销毁了）*****

```
2020-05-03 20:21:30.330067+0800 Runloop[60593:2834891] 即将进入Loop,
2020-05-03 20:21:30.330303+0800 Runloop[60593:2834891] 即将处理 Timer,
2020-05-03 20:21:30.330639+0800 Runloop[60593:2834891] 即将处理 Source,
2020-05-03 20:21:30.330906+0800 Runloop[60593:2834891] 即将进入休眠,
2020-05-03 20:21:31.330956+0800 Runloop[60593:2834891] 刚从休眠中唤醒,
2020-05-03 20:21:31.331329+0800 Runloop[60593:2834891] 执行stop
2020-05-03 20:21:31.331591+0800 Runloop[60593:2834891] 即将退出Loop,
2020-05-03 20:21:31.331783+0800 Runloop[60593:2834891] 我会走吗

```

虽然使用`self.myRunloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]`可以成功退出`runloop`，但是还是有问题，当`runloop`处理完`source`后，就退出`runloop`了，而且这时候，也不会想调用`run`方法那样，重新进入`runloop`

所以这种方式还是不行

最后一个最佳方式，既能手动退出`runloop`,有不会处理完`source`就退出`runloop`,不再进来

```
BOOL shouldKeepRunning = YES; // global
NSRunLoop *theRL = [NSRunLoop currentRunLoop];
while (shouldKeepRunning) {
	// runMode是有返回值的，当启动runloop后，是不会返回的，所以不会一直在调这个方法，runloop退出了，才会再调
	[theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]
}
```

当想退出`runloop`的时候，将`shouldKeepRunning `置为`NO`就可以了

----

## `runloop`和`performSelector`

`performSelector:withObject:afterDelay:`原理，往`runloop`添加一个不重复的定时器

所以子线程调用这个方法，是需要开启`runloop`才有效的


顺便看看`performSelector:onThread:withObject:waitUntilDone:`
```
// myThread是常驻线程
self.myThread = [[PermanentThread alloc] initWithTarget:self selector:@selector(myThreadStart) object:nil];

[self.myThread start];
    
NSLog(@"1");
[self performSelector:@selector(performWait) onThread:self.myThread withObject:nil waitUntilDone:NO];
NSLog(@"2");

- (void)performWait
{
    NSLog(@"3");
}

```

如果`waitUntilDone`为NO，那么就是不等待sel执行完，才往下走

输出为1、2、3

如果为YES，那么就是会卡住当前线程，等待sel执行完才走

输出为1、3、2

----

## 网络请求主线程回调，实现同步

需求描述：

给你一个接口，这个接口是网络请求，回调是主线程回来的，现在要求调用这个接口后，需要等待回调回来后，后面的代码才可以接着往下走

```
- (void)netRequestComplete:(void(^)(void))complete
{
    // 模拟网络请求，主线程回调
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete();
            }
        });
    });
}

```

使用信号量，会导致死锁

```
dispatch_semaphore_t sema = dispatch_semaphore_create(0);
[self netRequestComplete:^{
    NSLog(@"3");
    // 因为主线程被卡住，这里不会走了，所以死锁
    dispatch_semaphore_signal(sema);
}];
    
// 卡住主线程
dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)));
NSLog(@"2");   
```

***正确方式使用CFRunloopRun***

```
[self netRequestComplete:^{
    NSLog(@"3");
    // stop，退出runloop，主线程runloop退出后，又会自动加入，就像前面讲的，开启runloop是使用run的方法
    CFRunLoopStop([NSRunLoop currentRunLoop].getCFRunLoop);
}];
    
// CFRunLoopRun()相当加了do-while,这时候下面的代码执行不了
CFRunLoopRun();
NSLog(@"2");
    
```

----
## runloop优化tableview滚动坑点

> 这个点是从这个文章得知的[UITableView性能优化-中级篇](https://www.jianshu.com/p/04457377b48d)


做了一个实验

首先，用`perform`确实可以滑动tableview滚动的时候，不加载图片，达到优化的效果

但是通过这个实验发现，当我停止滚动的时候，前面滑过的indexPath，都会触发`logIndexRow:`方法

***如果这时候是加载图片，那么是多余的了，因为cell都划出界面了，没有必要加载***

由这个现象，可以大概的判断，`performSelector:inModes`,如果是在`default`mode下调用，虽然现在是在滚动，不会触发方法，但是`perform`就往runloop的`defaultMode`添加输入源，但滚动结束的时候，切换回defaultMode，这些输入源都会被触发

```
// 这个selector，可以是loadImg的方法
[self performSelector:@selector(logIndexRow:)
               withObject:indexPath
               afterDelay:0
                  inModes:@[NSDefaultRunLoopMode]];
```

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    }
    
    // 滑动的时候，不会调用logIndexRow:，因为这时候mode是滑动，但是perform也是属于输入源，这些事件会被积累在NSDefaultRunLoopMode下，当切换到NSDefaultRunLoopMode下后，就会执行这些输入源事件
    [self performSelector:@selector(logIndexRow:)
               withObject:indexPath
               afterDelay:0
                  inModes:@[NSDefaultRunLoopMode]];
    
    cell.textLabel.text = @"123";
    cell.textLabel.textColor = [UIColor redColor];
    
    return cell;
}
```

----

## runloop卡顿监测

引用[源码`__CFRunLoopRun`分析](http://hawk0620.github.io/blog/2018/04/14/runloop-study-note/)中的说法

> 从 kCFRunLoopBeforeSources 为起点到 kCFRunLoopBeforeWaiting 休眠前，这其中处理了大量的工作————执行 block，处理 source0，更新界面…做完这些之后 RunLoop 就休眠了，直到 RunLoop 被 timer、source、libdispatch 唤醒，唤醒后会发送休眠结束的 kCFRunLoopAfterWaiting 通知。我们知道屏幕的刷新率是 60fps，即 1/60s ≈ 16ms，假如一次 RunLoop 超过了这个时间，UI 线程有可能出现了卡顿，BeforeSources 到 AfterWaiting 可以粗略认为是一次 RunLoop 的起止。至于其他状态，譬如 BeforeWaiting，它在更新完界面之后有可能休眠了，此时 APP 已是不活跃的状态，不太可能造成卡顿；而 kCFRunLoopExit，它在 RunLoop 退出之后触发，主线程的 RunLoop 除了换 mode 又不太可能主动退出，这也不能用作卡顿检测。

监听***即将处理source***，到***结束睡眠***，如果这个过程超过一帧的时间，就可能出现丢帧的情况（丢帧就会导致卡顿）

那么为什么这个过程如果一帧的时间，就可能卡顿呢？

首先我们要理解屏幕显示原理，大概就是CPU计算文本、布局、绘制、图片解码，之后就提交位图到GPU，GPU就进行渲染，渲染完成后，根据V-sync信号，更新缓冲区，同时，视频控制器的指针，也会根据V-sync信号去缓冲区读取一帧的缓存，显示到屏幕上

也就是说从cpu绘制->GPU渲染，要在16ms内完成，才能保证在指定时间内，给视频控制器读取，否则，视频控制器就会读到上一帧的画面，这就导致卡顿了

所以在即将处理source，到结束睡眠这段时间内，如果CPU一直在处理一件任务，如果超过了16ms，那么可能就来不及在16ms内完成一帧画面的渲染


## `runloop`和`autoreleasepool`

> App启动后，苹果在主线程 RunLoop 里注册了两个 Observer，其回调都是 _wrapRunLoopWithAutoreleasePoolHandler()。
第一个 Observer 监视的事件是 Entry(即将进入Loop)，其回调内会调用 _objc_autoreleasePoolPush() 创建自动释放池。其 order 是-2147483647，优先级最高，保证创建释放池发生在其他所有回调之前。
第二个 Observer 监视了两个事件： BeforeWaiting(准备进入休眠) 时调用_objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 释放旧的池并创建新池；Exit(即将退出Loop) 时调用 _objc_autoreleasePoolPop() 来释放自动释放池。这个 Observer 的 order 是 2147483647，优先级最低，保证其释放池子发生在其他所有回调之后。


设置`_wrapRunLoopWithAutoreleasePoolHandler`符号断点，可以从汇编代码，看到autoreleasepush、pop

## 界面更新

不知道怎么证明。。。。


----

参考文章

[NSRunLoop的退出方式](https://juejin.im/entry/595f832c6fb9a06bc23a9d70)

[戴铭写的Runloop](https://github.com/ming1016/study/wiki/CFRunLoop)

[NSURLConnection的执行过程](https://www.jianshu.com/p/536184bfd163)

[很多runloop的问题和例子](https://juejin.im/post/5af590c5f265da0b7964f1c2)

[深入理解RunLoop(YYModel作者)](https://blog.ibireme.com/2015/05/18/runloop/)

[源码`__CFRunLoopRun`分析](http://hawk0620.github.io/blog/2018/04/14/runloop-study-note/)
//
//  RunloopObserver.m
//  Runloop
//
//  Created by chenzebin on 2020/5/2.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "RunloopObserver.h"

static void runLoopOserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
   //void *info正是我们要用来与OC传值的,这边可以转成OC对象,前面我们传进来的时候是self
    RunloopObserver *target = (__bridge RunloopObserver *)(info);//void *info即是我们前面传递的self(ViewController)
    
    if (target.callback) {
        target.callback(observer, activity);
    }
}

@implementation RunloopObserver

+ (instancetype)observerWithCallback:(void(^)(CFRunLoopObserverRef observer, CFRunLoopActivity activity))callback
{
    RunloopObserver *observe = [[RunloopObserver alloc] init];
    
    observe.callback = callback;
    
    return observe;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self addRunLoopObserver];
    }
    
    return self;
}

- (void)addRunLoopObserver
{
    //获取当前的CFRunLoopRef
    CFRunLoopRef runLoopRef = CFRunLoopGetCurrent();
    
    /*
    // 从CFRunLoopObserverRef点进去找
    
    typedef struct {
        CFIndex    version; // 传0，不知道是什么
        void *    info; // 数据传递用的，void *，指就是可以接受所有指针
        const void *(*retain)(const void *info); // 引用
        void    (*release)(const void *info); // 回收
        CFStringRef    (*copyDescription)(const void *info); // 描述，没用到
    } CFRunLoopObserverContext;
    */
    
    //创建上下文,用于控制器数据的获取
    CFRunLoopObserverContext context =  {
        0,
        (__bridge void *)(self),//self传递过去
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    //创建一个监听
    static CFRunLoopObserverRef observer;
    
    // CFRunLoopObserverCreate参数。1.不懂  2.监听runloop变化状态  3.是否重复监听  4.不懂，传0 5.函数指针  6.CFRunLoopObserverContext对象
    observer = CFRunLoopObserverCreate(NULL, kCFRunLoopAllActivities, YES, 0, &runLoopOserverCallBack, &context);
    
    //注册监听
    CFRunLoopAddObserver(runLoopRef, observer, kCFRunLoopCommonModes);
    
    //销毁
    CFRelease(observer);
}


@end

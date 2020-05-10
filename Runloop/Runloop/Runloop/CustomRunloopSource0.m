//
//  CustomRunloopSource0.m
//  Runloop
//
//  Created by chenzebin on 2020/5/5.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "CustomRunloopSource0.h"

void RunloopSourceScheduleRoutine(void *info, CFRunLoopRef rl, CFRunLoopMode mode) {
    NSLog(@"Schedule routine: source is added to runloop");
}

void RunloopSourceCancelRoutine(void *info, CFRunLoopRef rl, CFRunLoopMode mode) {
    NSLog(@"Cancel Routine: source removed from runloop");
}

void RunloopSourcePerformRoutine(void *info) {
    NSLog(@"Perform Routine: source has fired");
}

@interface CustomRunloopSource0()
{
    CFRunLoopSourceRef source;
    CFRunLoopRef runloop;
}

@end

@implementation CustomRunloopSource0

- (instancetype)init
{
    if (self = [super init]) {
        self.permanentThread = [[PermanentThread alloc] initWithTarget:self selector:@selector(permanentThreadStart) object:nil];
        [self.permanentThread start];
    }
    
    return self;
}

- (void)permanentThreadStart
{
    [self.permanentThread observerRunloopActivity];
    [self addCustomSource0];
    [self.permanentThread startLiveForever];
}

- (void)addCustomSource0
{
//    typedef struct {
//        CFIndex    version;
//        void *    info;
//        const void *(*retain)(const void *info);
//        void    (*release)(const void *info);
//        CFStringRef    (*copyDescription)(const void *info);
//        Boolean    (*equal)(const void *info1, const void *info2);
//        CFHashCode    (*hash)(const void *info);
//        // 当source0加到runloop的时候回调
//        void    (*schedule)(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
//        // 退出runloop的回调
//        void    (*cancel)(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
//        // 当source0被调用的时候，回调
//        void    (*perform)(void *info);
//    } CFRunLoopSourceContext;

    CFRunLoopSourceContext context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL, RunloopSourceScheduleRoutine, RunloopSourceCancelRoutine, RunloopSourcePerformRoutine };

    source = CFRunLoopSourceCreate(CFAllocatorGetDefault(), 0, &context);
    runloop = CFRunLoopGetCurrent();
    
    CFRunLoopAddSource(runloop, source, kCFRunLoopDefaultMode);
}

- (void)fireSource0
{
    // 标记为待处理的输入源，这个函数只对source0有效，对source1无效
    CFRunLoopSourceSignal(source);
    // 唤醒runloop，runloop醒来后，就会去取待处理输入源，来处理
    CFRunLoopWakeUp(runloop);

}

- (void)dealloc
{
    
}

@end

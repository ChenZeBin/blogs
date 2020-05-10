//
//  StopRunloop.m
//  Runloop
//
//  Created by chenzebin on 2020/5/3.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ExitRunloop.h"

@implementation ExitRunloop

- (instancetype)init
{
    if (self = [super init]) {
        self.myThread = [[NSThread alloc] initWithTarget:self selector:@selector(myThreadStart) object:nil];
        [self.myThread start];
    }
    
    return self;
}

- (void)myThreadStart
{
    self.runloopObserver = [RunloopObserver observerWithCallback:^(CFRunLoopObserverRef  _Nonnull observer, CFRunLoopActivity activity) {
        NSLog(@"%@",CFRunLoopActivity2String(activity));
    }];
    
//    [self test1];
//    [self test2];
//    [self test3];
    [self test4];
}

- (void)test1
{
    [self.myThread setName:@"StopRunloopThread"];
    self.myRunloop = [NSRunLoop currentRunLoop];
    
    // performSelector:afterDelay:的原理是往runloop添加不重复执行的定时器
    [self performSelector:@selector(performSelAferDelayClick) withObject:nil afterDelay:1];
    
    [self.myRunloop run];
    
    NSLog(@"我会走吗");
}

- (void)test2
{
    [self.myThread setName:@"TestThread"];
    self.myRunloop = [NSRunLoop currentRunLoop];
    self.myPort = [NSMachPort port];
    
    // 添加监听NSMachPort的端口（这个端口可以理解为输入源，因为可以一直监听这个，所以这时候的runloop不会退出，会一直在做do-while）
    [self.myRunloop addPort:self.myPort forMode:NSDefaultRunLoopMode];
    
    [self.myRunloop run];
    
    // [self.myRunloop run]; 会导致以下代码没法走，因为runloop就是一个do-while的循环，do-while监听源，处理源
    NSLog(@"我会走吗");
}

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

- (void)test4
{
    [self.myThread setName:@"TestThread"];
    self.myRunloop = [NSRunLoop currentRunLoop];
    self.myPort = [NSMachPort port];
    
    // 添加监听NSMachPort的端口（这个端口可以理解为输入源，因为可以一直监听这个，所以这时候的runloop不会退出，会一直在做do-while）
    [self.myRunloop addPort:self.myPort forMode:NSDefaultRunLoopMode];
//    [self performSelector:@selector(runloopStop) withObject:nil afterDelay:1];

    [self.myRunloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    // [self.myRunloop run]; 会导致以下代码没法走，因为runloop就是一个do-while的循环，do-while监听源，处理源
    NSLog(@"我会走吗");
}

- (void)runloopStop
{
    NSLog(@"执行stop");
    CFRunLoopStop(self.myRunloop.getCFRunLoop);
}

- (void)test11
{
    [self.myThread setName:@"TestThread"];
    self.myRunloop = [NSRunLoop currentRunLoop];
    self.myPort = [NSMachPort port];
    
    // 首先，需要有一点，当runloop监视输入源或者定时器的时候，才不会退出
    // 开启runloop之前，需要有输入源或者定时器
    // 定时器（如果是添加定时器，不重复，那么监听一次就退出了）
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer执行");
    }];
    
    [self.myRunloop addTimer:timer forMode:NSDefaultRunLoopMode];
    
    
    
    [self.myRunloop run];
    
    // [self.myRunloop run]; 会导致以下代码没法走，因为runloop就是一个do-while的循环，do-while监听源，处理源
    NSLog(@"我会走吗");
}

- (void)performSelAferDelayClick
{
    NSLog(@"performSelAferDelayClick执行");
}


@end

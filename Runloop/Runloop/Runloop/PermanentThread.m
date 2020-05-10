//
//  PermanentThread.m
//  Runloop
//
//  Created by chenzebin on 2020/5/3.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "PermanentThread.h"
#import "RunloopObserver.h"

@interface PermanentThread()

@property (nonatomic, strong) RunloopObserver *runloopObserver;

@end

@implementation PermanentThread
@synthesize myRunloop = _myRunloop;
@synthesize myPort = _myPort;

- (void)startLiveForever
{
    _myRunloop = [NSRunLoop currentRunLoop];
    _myPort = [NSMachPort port];
    
    // 如果使用NSRunLoopCommonModes，就不行，有兴趣可以试试看，AF开启常驻线程也是用NSDefaultRunLoopMode
    [self.myRunloop addPort:self.myPort forMode:NSDefaultRunLoopMode];
    [self.myRunloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    [self.myRunloop run];
}

- (void)dying
{
    CFRunLoopStop(self.myRunloop.getCFRunLoop);
}

- (void)addTask:(void(^)(void))task
{
}

- (void)observerRunloopActivity
{
    self.runloopObserver = [RunloopObserver observerWithCallback:^(CFRunLoopObserverRef  _Nonnull observer, CFRunLoopActivity activity) {
        NSLog(@"permanentThreadRunloop:%@",CFRunLoopActivity2String(activity));
    }];
}

@end

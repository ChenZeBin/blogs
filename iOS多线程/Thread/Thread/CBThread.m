//
//  CBThread.m
//  Thread
//
//  Created by chenzebin on 2020/5/10.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "CBThread.h"

@interface CBThread()

@property (nonatomic, copy) void(^taskBlock)(void);

@end

@implementation CBThread
@synthesize isLiveFurture = _isLiveFurture;

- (instancetype)initWithLiveForture:(BOOL)isLiveForture
{
    if (self = [super init]) {
        _isLiveFurture = isLiveForture;
    }
    
    return self;
}

- (void)main
{
    if (self.isCancelled)
    {
        return;
    }
        
    if (self.isLiveFurture) {
        [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)addTask:(void(^)(void))task
{
    if (self.isExecuting) {
        self.taskBlock = task;
        [self performSelector:@selector(taskClick) onThread:self withObject:nil waitUntilDone:NO];
    }
}

- (void)taskClick
{
    if (self.taskBlock) {
        self.taskBlock();
    }
}

@end

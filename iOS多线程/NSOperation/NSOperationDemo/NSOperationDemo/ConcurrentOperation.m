//
//  ConcurrentOperation.m
//  NSOperationDemo
//
//  Created by chenzebin on 2020/4/6.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ConcurrentOperation.h"

/// 并发自定义子类
@implementation ConcurrentOperation


- (void)start
{
    // 加入到队列后，就会调用start
    NSLog(@"任务线程：%@",[NSThread currentThread]);
    // 任务是否准备就绪,如果没有依赖关系，加入队列就是准备就绪了；如果有依赖关系，依赖的对象执行完了，才准备就绪
    NSLog(@"ready:%@",self.ready ? @"YES" : @"NO");
    // [queue cancelAllOperations]和[op1 cancel]都会导致为NO
    NSLog(@"cancelled:%@",self.cancelled ? @"YES" : @"NO");
    // 子类自己处理，记得赋值的时候要主动触发下kvo
    NSLog(@"executing:%@",self.executing ? @"YES" : @"NO");
    // 子类自己处理，记得赋值的时候要主动触发下kvo
    NSLog(@"finished:%@",self.finished ? @"YES" : @"NO");
    // 子类自己处理
    NSLog(@"concurrent:%@",self.concurrent ? @"YES" : @"NO");
    @synchronized (self) {
        if (self.isCancelled) {
            NSLog(@"任务已经取消");
            return;
        }
        NSLog(@"任务执行,thread:%@",[NSThread currentThread]);
    }
}

@end

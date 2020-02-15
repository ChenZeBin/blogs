//
//  ViewController.m
//  GCDRequest
//
//  Created by chenzebin on 2020/2/15.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self group1Use];
//    [self group2Use];
//    [self group3Use];
    [self group4Use];
}

- (void)group1Use
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务一完成");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务二完成");
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"都完成了");
    });
}

- (void)group2Use
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            NSLog(@"任务一完成");
        });
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            NSLog(@"任务二完成");
        });
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"都完成了");
    });
}

- (void)group3Use
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"任务一完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"任务二完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"都完成了");
    });
}

- (void)group4Use
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    // 注意，故意将这个任务一的延迟时间调成4s，比任务二多2s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"任务一完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"任务二完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"都完成了");
    });
}


@end

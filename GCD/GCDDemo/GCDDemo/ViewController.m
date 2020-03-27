//
//  ViewController.m
//  GCDDemo
//
//  Created by chenzebin on 2020/2/29.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

// 并行队列  异步+同步
- (void)test1
{
    dispatch_queue_t queue = dispatch_queue_create("1111", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"1");
    // 异步开辟一个子线程
    dispatch_async(queue, ^{
        NSLog(@"2");
        // 同步，卡住当前线程，知道3输出，所以3->4
        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

// 并行队列 异步+异步
- (void)test2
{
    dispatch_queue_t queue = dispatch_queue_create("1111", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"1");
    // 异步开辟一个子线程
    dispatch_async(queue, ^{
        NSLog(@"2");
        // 再开辟一个子线程，所以先4再3
        dispatch_async(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}


// 串行队列 异步+异步
- (void)test3
{
    dispatch_queue_t queue = dispatch_queue_create("1111", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"1");
    // 开辟一个子线程
    dispatch_async(queue, ^{
        NSLog(@"2");
        // 再开辟一个子线程，首先这里要明白，2，3，4算是串行队列中的一个任务，因为3是新开了一个子线程，又不会卡住，所以输出2，4这个任务就算完成了，然后新开的这个子线程再执行3
        dispatch_async(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

// 串行队列  异步+同步
- (void)test4
{
    dispatch_queue_t queue = dispatch_queue_create("1111", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"1");
    // 开辟一个子线程
    dispatch_async(queue, ^{
        NSLog(@"2");
        // 2，3，4是同一个任务，sync不会开辟线程，所以他又将3加入到串行队列中，这时候队列第一个任务是2，3，4，第二个任务是3，因为他得把2，3，4执行完才会轮到第二个任务，问题是他要执行完，输出这个3，这个3是在第二个任务里面的，所以死锁了
        dispatch_sync(queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}


@end

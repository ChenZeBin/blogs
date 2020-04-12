//
//  ViewController.m
//  NSOperationDemo
//
//  Created by chenzebin on 2020/4/6.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"
#import "ConcurrentOperation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     介绍：
     NSOperation是封装GCD的，NSOperation是一个抽象基类，系统的子类有NSInvocationOperation和NSBlockOperation，我们也可以继承NSOperation自定义
     在NSOperation实例在多线程上执行是安全的，不需要添加额外的锁
     
     1.NSInvocationOperation 使用
     2.NSBlockOperation 使用
     3.添加到队列
     3.添加依赖
     4.API的了解
     5.KVO
     */
    
    // 1.在哪个线程创建任务，任务就在哪个线程执行
//    [self test1];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self test1];
//    });
    
    // 2.将任务添加到主队列,cancelAllOperations取消不了主队列的任务
//    [self test2];
    
    // 3.将任务添加到自定义队列，cancelAllOperations可以取消自定义队列的任务，并且这个方法只能取消还未开始的任务
//    [self test3];
    
    // 4.添加依赖
//    [self test4];
    
    // 5.blockOperation
//    [self test5];
    
    // 6.自定义队列
//    [self test6];
}

#pragma mark - NSInvocationOperation 使用
- (void)test1
{
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    // 如果是直接有operation启动任务，那么是哪个线程启动，就在哪个线程执行任务
    [op start];
    
    // 返回task1的返回值，如果没有返回值，就报异常并且crash
    NSLog(@"-----%@",op.result);
}

- (NSString *)task1
{
    NSLog(@"thread:%@",[NSThread currentThread]);
    return @"";
}

#pragma mark - NSBlockOperation 使用
- (void)test5
{
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        // 这个block不一定是，在哪个线程创建就在哪个线程调用的，比如当addExecutionBlock很多个任务的时候，就不一定了
        [self task5];
    }];
    
    // addExecutionBlock的任务，和创建任务blockOperationWithBlock，是并发执行的，开启的线程数由系统根据任务数决定
    [blockOp addExecutionBlock:^{
        NSLog(@"追加任务1,thread:%@",[NSThread currentThread]);
    }];
    
    [blockOp addExecutionBlock:^{
        NSLog(@"追加任务2,thread:%@",[NSThread currentThread]);
    }];
    
    [blockOp addExecutionBlock:^{
        NSLog(@"追加任务3,thread:%@",[NSThread currentThread]);
    }];
    
//    for (NSInteger i = 0; i < 10000; i++) {
//        [blockOp addExecutionBlock:^{
//            NSLog(@"追加任务3,thread:%@",[NSThread currentThread]);
//        }];
//    }
    
    // 获取队列中的block
    NSLog(@"----:%@",[blockOp executionBlocks]);
    
    [blockOp start];
    
    // operation的任务还是串行的，但是addExecutionBlock追加的，还是并行
    [[NSOperationQueue mainQueue] addOperation:blockOp];
}

- (void)task5
{
    NSLog(@"创建任务。thread:%@",[NSThread currentThread]);
}

#pragma mark - 添加到队列
- (void)test2
{
    // 主队列
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
//    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2:) object:@"1"];
//    [mainQueue addOperation:op1];
//
//    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2:) object:@"2"];
//    [mainQueue addOperation:op2];
//
//    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2:) object:@"3"];
//    [mainQueue addOperation:op3];
    
    for (NSInteger i = 0; i < 1000; i++) {
        NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2:) object:[@(i) stringValue]];
           [mainQueue addOperation:op3];
    }
    
    // cancelAllOperations取消不了主队列的任务
    [mainQueue cancelAllOperations];

}

- (void)task2:(NSString *)str
{
    NSLog(@"task2:%@",str);
}

- (void)test3
{
    // 自定义队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 这个属性的设置需在队列中添加任务之前。任务添加到队列后，如果该任务没有依赖关系的话，任务添加到队列后，会直接开始执行，
    // 如果maxConcurrentOperationCount为1，那么任务就是串行执行(所有任务都在一个线程中执行)，如果大于1那么就是并行，但是执行的线程数量是由系统决定的，不是由这个决定的
    queue.maxConcurrentOperationCount = 1;

    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task3:) object:@"1"];
    [queue addOperation:op1];
    
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task3:) object:@"2"];
    [queue addOperation:op2];

    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task3:) object:@"3"];
    [queue addOperation:op3];
    
    // cancelAllOperations是可以取消自定义队列的任务的
//    [queue cancelAllOperations];
}

- (void)task3:(NSString *)str
{
    NSLog(@"task3:%@，thread:%@",str,[NSThread currentThread]);
}

#pragma mark - 添加依赖
- (void)test4
{
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task4:) object:@"1"];
    
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task4:) object:@"2"];
    
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task4:) object:@"3"];
    
    // op1依赖op2（要等op2执行完了才到op1），添加依赖必须在加入到队列之前，因为加入队列就开始执行了
//    [op1 addDependency:op2];
//    [op2 addDependency:op1]; // 如果两个任务相互依赖，会导致都执行不了

    [mainQueue addOperation:op1];
    [mainQueue addOperation:op2];
    [mainQueue addOperation:op3];
}

- (void)task4:(NSString *)str
{
    NSLog(@"task4:%@，thread:%@",str,[NSThread currentThread]);
}

#pragma mark - 自定义并行队列

- (void)test6
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    ConcurrentOperation *op1 = [[ConcurrentOperation alloc] init];
    ConcurrentOperation *op2 = [[ConcurrentOperation alloc] init];
    ConcurrentOperation *op3 = [[ConcurrentOperation alloc] init];
    
    [queue addOperation:op1];
    [op1 cancel];
    [queue addOperation:op2];
    [queue addOperation:op3];
//    [queue cancelAllOperations];
//    [op start];
    
//    [[NSOperationQueue mainQueue] addOperation:op];
}

@end

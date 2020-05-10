//
//  ViewController.m
//  Thread
//
//  Created by chenzebin on 2020/5/10.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"
#import "CBThread.h"

@interface ViewController ()

@property (nonatomic, strong) NSThread *thread;
@property (nonatomic, strong) CBThread *cbThread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testCBThread];
    
    // 验证下创建线程是不是复用线程池的对象
//    for (NSInteger i = 0; i < 1000000; i++) {
//        NSThread *thread = [[NSThread alloc] init];
//        [thread start];
//        NSLog(@"%@",thread);
//    }
    
    
//    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(startThread) object:nil];
//    // 使线程进入就绪状态
//    [self.thread start];
//
//    NSLog(@"executing:%@",self.thread.executing ? @"YES" : @"NO");
//    NSLog(@"finish:%@",self.thread.finished ? @"YES" : @"NO");
//    NSLog(@"cancel:%@",self.thread.cancelled ? @"YES" : @"NO");
}

- (void)startThread
{
    // 线程休眠，休眠后，也就是不接收任务处理
//    + (void)sleepUntilDate:(NSDate *)date;
//    + (void)sleepForTimeInterval:(NSTimeInterval)ti;
    
    // 设置线程优先级 setThreadPriority废弃，不建议使用To be deprecated; use qualityOfService below
    [self.thread setQualityOfService:NSQualityOfServiceUserInitiated];
    
    NSLog(@"callStackSymbols : %@", [NSThread callStackSymbols]);
    NSLog(@"callStackReturnAddresses : %@", [NSThread callStackReturnAddresses]);
    
    // stackSize的单位是字节，所以除以1024，就是多少k
    NSLog(@"stackSize:%ld",self.thread.stackSize / 1024);
    
    NSLog(@"executing:%@",self.thread.executing ? @"YES" : @"NO");
    NSLog(@"finish:%@",self.thread.finished ? @"YES" : @"NO");
    NSLog(@"cancel:%@",self.thread.cancelled ? @"YES" : @"NO");

    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    
    /** main是线程入口
    *  - (void)main的使用：
    *  1. 一般创建线程会子类化NSThread，重写main方法，把关于线程执行的方法都写在里面，这样可以在任何需要这个线程方法的地方直接使用。
    *  2. 把线程执行的方法写在main里，是因为线程的操作应该属于线程的本身，而不是每次使用都通过initWithTarget:selector:object:方法，且再一次实现某个方法。
    *  3. 当重写了main方法后，同时使用initWithTarget:selector:object:方法初始化，调用某个方法执行任务，系统默认只执行main方法里面的任务。
    *  4. 如果直接使用NSThread创建线程，线程内执行的方法都是在当前的类文件里面的。
    */
//    - (void)main NS_AVAILABLE(10_5, 2_0);
}

- (void)threadTask
{
    NSLog(@"执行了");
    // 线程退出了，但是runloop还在的哦
    [self.thread cancel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
//    [self performSelector:@selector(threadTask) onThread:self.thread withObject:nil waitUntilDone:YES];
//    [self.thread cancel];
//    [self performSelector:@selector(threadTask) onThread:self.thread withObject:nil waitUntilDone:NO];
    
    [self.cbThread addTask:^{
        NSLog(@"%@--执行了",[NSThread currentThread]);
    }];
    
}

- (void)testCBThread
{
    self.cbThread = [[CBThread alloc] initWithLiveForture:YES];
//    self.cbThread = [[CBThread alloc] init];

    
    [self.cbThread start];
}



@end

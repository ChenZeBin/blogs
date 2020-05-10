//
//  ViewController.m
//  Runloop
//
//  Created by chenzebin on 2020/5/2.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"
#import "RunloopObserver.h"
#import <CoreFoundation/CoreFoundation.h> // CFRunloopRun()用到
#import "ExitRunloop.h"
#import "PermanentThread.h"
#import "CustomRunloopSource0.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ExitRunloop *stopRunloop;
@property (nonatomic, strong) RunloopObserver *runloopObserver;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CustomRunloopSource0 *customSource0;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.stopRunloop = [[StopRunloop alloc] init];
//
//    [self CFRunloopRunUsing];
//
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
 
//    [self setupCustomSource0];
}


#pragma mark - 网络请求主线程回调，实现同步
- (void)CFRunloopRunUsing
{
    NSLog(@"1:isMainThread:%@",[NSThread isMainThread] ? @"YES" : @"NO");
    
    [self netRequestComplete:^{
        NSLog(@"2:isMainThread:%@",[NSThread isMainThread] ? @"YES" : @"NO");
        CFRunLoopStop([NSRunLoop currentRunLoop].getCFRunLoop);
    }];
    
    CFRunLoopRun();
    NSLog(@"3:isMainThread:%@",[NSThread isMainThread] ? @"YES" : @"NO");

}

- (void)netRequestComplete:(void(^)(void))complete
{
    // 模拟网络请求，主线程回调
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete();
            }
        });
    });
}

#pragma mark - runloop优化tableview滚动坑点
#pragma mark  tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    }
    
    // 滑动的时候，不会调用logIndexRow:，因为这时候mode是滑动，但是perform也是属于输入源，这些事件会被积累在NSDefaultRunLoopMode下，当切换到NSDefaultRunLoopMode下后，就会执行这些输入源事件
    [self performSelector:@selector(logIndexRow:)
               withObject:indexPath
               afterDelay:0
                  inModes:@[NSDefaultRunLoopMode]];
    
    cell.textLabel.text = @"123";
    cell.textLabel.textColor = [UIColor redColor];
    
    return cell;
}

- (void)logIndexRow:(NSIndexPath *)indexPath
{
    NSLog(@"滑动index：%@",indexPath);
}

#pragma mark - 自定义source0
- (void)setupCustomSource0
{
    self.customSource0 = [[CustomRunloopSource0 alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.customSource0 fireSource0];

}


@end

//
//  AViewController.m
//  NSProxy
//
//  Created by chenzebin on 2020/3/21.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "AViewController.h"
#import "TimerProxy.h"
#import "TimerObject.h"

@interface AViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end


@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startTimer];
    
    self.view.backgroundColor = [UIColor redColor];

}

- (void)startTimer
{
    self.timer = [NSTimer timerWithTimeInterval:1 target:[TimerObject proxyWithObjc:self] selector:@selector(someBussiness) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)someBussiness
{
    NSLog(@"someBussiness");
}

- (void)dealloc
{
    NSLog(@"Controller dealloc");
    
    if (self.timer) {
        [self.timer invalidate];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

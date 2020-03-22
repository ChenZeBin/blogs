//
//  AViewController.m
//  BNotificationCenter
//
//  Created by chenzebin on 2020/3/22.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "AViewController.h"
#import "BNotificationCenter.h"

@interface AViewController ()

@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    
    [self test1];    
}

- (void)test1
{
    [[BNotificationCenter defaultCenter] addObserver:self selector:@selector(click1:) name:@"123" object:nil];
}

- (void)test2
{
    [[BNotificationCenter defaultCenter] addObserver:self selector:@selector(click1:) name:@"123" object:nil];
    [[BNotificationCenter defaultCenter] addObserver:self selector:@selector(click2) name:@"123" object:nil];
}

- (void)dealloc
{
    NSLog(@"释放了");
}


- (void)click1:(BNotification *)noti
{
    NSLog(@"click1");
}

- (void)click2
{
    NSLog(@"click2");
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[BNotificationCenter defaultCenter] postNotificationName:@"123" object:nil userInfo:nil];
}

@end

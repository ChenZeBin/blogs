//
//  ViewController.m
//  HookScrollerDelegate
//
//  Created by chenzebin on 2020/3/21.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"
#import "ScrollerViewDelegate.h"

@class ObserveDelegate;

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ObserveDelegate *delegate;
@property (nonatomic, strong) ScrollerViewDelegate *scrollerViewDelegate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = [[ObserveDelegate alloc] init];
    self.scrollerViewDelegate = [ScrollerViewDelegate proxyWithAllDelegate:@[self,self.delegate]];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 50, 50, 100)];
    self.scrollView.delegate = self.scrollerViewDelegate;
    self.scrollView.contentSize = CGSizeMake(50, 500);
    self.scrollView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.scrollView];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"滚动");
}

@end



@implementation ObserveDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"监听滚动");
}


@end

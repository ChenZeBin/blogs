//
//  ViewController.m
//  NSProxy
//
//  Created by chenzebin on 2020/3/21.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"
#import "TimerProxy.h"
#import "AViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    ((void(*)(id,SEL,NSInteger,NSInteger))objc_msgSend)(self,@selector(aaa:b:),1,2);

}

- (NSString*) addSubviewTemp:(UIView *)view with:(id)obj
{
    return @"";
}


- (void)aaa:(NSInteger)a b:(NSInteger)b
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    AViewController *avc = [[AViewController alloc] init];
    [self presentViewController:avc animated:YES completion:nil];
}

@end

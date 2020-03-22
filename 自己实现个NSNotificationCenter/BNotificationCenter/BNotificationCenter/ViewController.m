//
//  ViewController.m
//  BNotificationCenter
//
//  Created by chenzebin on 2020/3/22.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"
#import "AViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    AViewController *avc = [AViewController new];
    
    [self presentViewController:avc animated:YES completion:nil];
}


@end

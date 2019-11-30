//
//  ViewController.m
//  BlockDemo1
//
//  Created by Corbin on 2019/11/30.
//  Copyright © 2019 ChenZeBin. All rights reserved.
//

#import "ViewController.h"

typedef void(^Block)(void);

@interface ViewController ()

@end

__weak id ptr = nil;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int a = 10;
    void(^block)(void) = ^{
        NSLog(@"aaa--:%d",a);
    };
    
    ptr = [block copy];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    Block block = ptr;
    
    block();
}


@end

//
//  ViewController.m
//  FPS
//
//  Created by chenzebin on 2020/5/2.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"
#import "WeakProxy.h"

@interface ViewController ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:[[WeakProxy alloc] initWithTarget:self] selector:@selector(displayLinkClick)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkClick
{
    NSLog(@"123");
}


@end

//
//  AViewController.m
//  ForwardDemo
//
//  Created by chenzebin on 2020/3/25.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "AViewController.h"
#import "ViewController.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    BOOL test = [super resolveClassMethod:sel];
    
    return test;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    BOOL test = [super resolveInstanceMethod:sel];
  
    return test;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    id test = [super forwardingTargetForSelector:aSelector];
    
//    if (aSelector == @selector(sss)) {
//        return [ViewController new];
//    }
    
    return test;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *test = [super methodSignatureForSelector:aSelector];
    
    return test;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [super forwardInvocation:anInvocation];
}

@end

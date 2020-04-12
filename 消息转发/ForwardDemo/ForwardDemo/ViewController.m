//
//  ViewController.m
//  ForwardDemo
//
//  Created by chenzebin on 2020/3/25.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "AViewController.h"

void sss(id objc, SEL _cmd) {
    NSLog(@"新方法");
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(sss)];
}

/*
 
 
 */

+ (BOOL)resolveClassMethod:(SEL)sel
{
    BOOL test = [super resolveClassMethod:sel];
    
    return test;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    BOOL test = [super resolveInstanceMethod:sel];
//    if (sel == @selector(sss)) {
//        // 如果返回YES，那么会再调sss方法   如果返回NO，那么就走forwardingTargetForSelector方法
//        class_addMethod([self class], sel, (IMP)sss, "v@:");
//        return YES;
//    }
    return test;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    id test = [super forwardingTargetForSelector:aSelector];
    
    if (aSelector == @selector(sss)) {
        // 就会让a去调用sss方法，如果没有，也是一样的流程，走消息转发
        // 注意！如果A的forwardingTargetForSelector返回ViewController，那么就会死循环
//        return [AViewController new];
        
        // 如果return nil，那么就会走methodSignatureForSelector
    }
    
    return test;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *test = [super methodSignatureForSelector:aSelector];
    
    // return nil 那么就会调doesNotRecognizeSelector，然后崩溃
    
    // 如果有方法签名，那么就会调forwardInvocation，由方法签名生成invocation
    return test;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [super forwardInvocation:anInvocation];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    [super doesNotRecognizeSelector:aSelector];
}


@end

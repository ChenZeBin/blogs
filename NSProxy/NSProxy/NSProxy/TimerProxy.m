//
//  TimerProxy.m
//  NSProxy
//
//  Created by chenzebin on 2020/3/21.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "TimerProxy.h"

@interface TimerProxy()

@property (nonatomic, weak) id objc;

@end

@implementation TimerProxy

+ (instancetype)proxyWithObjc:(id)objc
{
    return [[self alloc] initWithObjc:objc];
}

- (instancetype)initWithObjc:(id)objc
{
    _objc = objc;
    
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_objc methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL sel = invocation.selector;
    
    if ([_objc respondsToSelector:sel]) {
        [invocation setTarget:_objc];
        [invocation invoke];
    }
}

@end

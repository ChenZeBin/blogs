//
//  TimerObject.m
//  NSProxy
//
//  Created by chenzebin on 2020/3/21.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "TimerObject.h"

@interface TimerObject()

@property (nonatomic, weak) id objc;

@end

@implementation TimerObject

+ (instancetype)proxyWithObjc:(id)objc
{
    return [[self alloc] initWithObjc:objc];
}

- (instancetype)initWithObjc:(id)objc
{
    if (self = [super init]) {
        _objc = objc;
    }
    
    return self;
}

/// 1.看看可不可以解析这个方法
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return [super resolveInstanceMethod:sel];
}

/// 2.看看有没有人来接受这个selector
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.objc;
}

/// 4.通过方法签名生成anInvocation
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [super forwardInvocation:anInvocation];
}

/// 3.有返回方法签名就走forwardInvocation，没有就崩溃了
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    
    return sig;
}

@end

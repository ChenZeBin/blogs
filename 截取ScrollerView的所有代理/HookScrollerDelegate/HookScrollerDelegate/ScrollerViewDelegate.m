//
//  ScrollerViewDelegate.m
//  HookScrollerDelegate
//
//  Created by chenzebin on 2020/3/21.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ScrollerViewDelegate.h"

@interface ScrollerViewDelegate()

@property (nonatomic, strong) NSArray *allDelegate;

@end

@implementation ScrollerViewDelegate

+ (instancetype)proxyWithAllDelegate:(NSArray *)allDelegate
{
    return [[ScrollerViewDelegate alloc] initWithAllDelegate:allDelegate];
}

- (instancetype)initWithAllDelegate:(NSArray *)allDelegate
{
    _allDelegate = allDelegate;
    
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    __block NSMethodSignature *sign = nil;
    
    [self.allDelegate enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        sign = [obj methodSignatureForSelector:sel];

        if (!sign) {
            *stop = YES;
        }
    }];

    return sign;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if (self.listenAllBlock)
    {
        self.listenAllBlock(invocation);
    }
    
    [self.allDelegate enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:obj];
        }
    }];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    
    for (NSInteger i = 0; i < self.allDelegate.count; i++) {
        if ([self.allDelegate[i] respondsToSelector:aSelector]) {
            return YES;
        }
    }
    
    return NO;
}


@end

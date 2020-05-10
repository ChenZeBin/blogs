//
//  WeakProxy.m
//  FPS
//
//  Created by chenzebin on 2020/5/2.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "WeakProxy.h"

@interface WeakProxy()

@property (nonatomic, weak) id target;

@end

@implementation WeakProxy

- (instancetype)initWithTarget:(id)target
{
    self.target = target;
    
    return self;
}

- (instancetype)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;
}

@end

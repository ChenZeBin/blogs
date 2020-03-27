//
//  ScrollerViewDelegate.h
//  HookScrollerDelegate
//
//  Created by chenzebin on 2020/3/21.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollerViewDelegate : NSProxy

+ (instancetype)proxyWithAllDelegate:(NSArray *)allDelegate;

@property (nonatomic, copy) void(^listenAllBlock)(NSInvocation *inv);

@end

NS_ASSUME_NONNULL_END

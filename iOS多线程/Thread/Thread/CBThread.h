//
//  CBThread.h
//  Thread
//
//  Created by chenzebin on 2020/5/10.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBThread : NSThread

- (instancetype)initWithLiveForture:(BOOL)isLiveForture;
- (void)addTask:(void(^)(void))task;

@property (nonatomic, assign, readonly) BOOL isLiveFurture;

@end

NS_ASSUME_NONNULL_END

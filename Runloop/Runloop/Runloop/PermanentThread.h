//
//  PermanentThread.h
//  Runloop
//
//  Created by chenzebin on 2020/5/3.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PermanentThread : NSThread

- (void)startLiveForever;
- (void)dying;
- (void)observerRunloopActivity;

@property (nonatomic, strong, readonly) NSRunLoop *myRunloop;
@property (nonatomic, strong, readonly) NSPort *myPort;

@end

NS_ASSUME_NONNULL_END

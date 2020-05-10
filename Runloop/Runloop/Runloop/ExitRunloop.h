//
//  StopRunloop.h
//  Runloop
//
//  Created by chenzebin on 2020/5/3.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunloopObserver.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExitRunloop : NSObject

@property (nonatomic, strong) NSRunLoop *myRunloop;
@property (nonatomic, strong) NSThread *myThread;
@property (nonatomic, strong) NSPort *myPort;

@property (nonatomic, strong) RunloopObserver *runloopObserver;

@end

NS_ASSUME_NONNULL_END

//
//  BEventThread.h
//  BEventLoop
//
//  Created by ChenZeBin on 2020/3/27.
//  Copyright © 2020 ChenZeBin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BEventThread : NSObject

@property (nonatomic, strong) NSThread *thread;

@end

NS_ASSUME_NONNULL_END

//
//  CustomRunloopSource0.h
//  Runloop
//
//  Created by chenzebin on 2020/5/5.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExitRunloop.h"
#import "PermanentThread.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomRunloopSource0 : NSObject

@property (nonatomic, strong) PermanentThread *permanentThread;

- (void)fireSource0;

@end

NS_ASSUME_NONNULL_END

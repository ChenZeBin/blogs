//
//  RunloopObserver.h
//  Runloop
//
//  Created by chenzebin on 2020/5/2.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *CFRunLoopActivity2String(CFRunLoopActivity activity)
{
    NSMutableString *res = [[NSMutableString alloc] init];
    
    switch (activity) {
        case kCFRunLoopEntry:
            [res appendString:@"即将进入Loop,"];
            break;
            
         case kCFRunLoopBeforeTimers:
            [res appendString:@"即将处理 Timer,"];
            break;
        case kCFRunLoopBeforeSources:
            [res appendString:@"即将处理 Source,"];
            break;
        case kCFRunLoopBeforeWaiting:
            [res appendString:@"即将进入休眠,"];
            break;
        case kCFRunLoopAfterWaiting:
            [res appendString:@"刚从休眠中唤醒,"];
            break;
        case kCFRunLoopExit:
            [res appendString:@"即将退出Loop,"];
            break;
        case kCFRunLoopAllActivities:
            [res appendString:@"allActivities"];
            break;
    }
    
    return res;
}

@interface RunloopObserver : NSObject

+ (instancetype)observerWithCallback:(void(^)(CFRunLoopObserverRef observer, CFRunLoopActivity activity))callback;

@property (nonatomic, copy) void(^callback)(CFRunLoopObserverRef observer, CFRunLoopActivity activity);

@end

NS_ASSUME_NONNULL_END

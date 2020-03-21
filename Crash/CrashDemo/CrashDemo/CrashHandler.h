//
//  CrashHandler.h
//  CrashDemo
//
//  Created by chenzebin on 2020/3/21.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static int crashHandler_crash(id self,SEL selector) {
    return 0;
}

@interface CrashHandler : NSObject

@end

NS_ASSUME_NONNULL_END

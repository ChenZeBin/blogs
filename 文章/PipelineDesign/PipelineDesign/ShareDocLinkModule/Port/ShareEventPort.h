//
//  IMPort.h
//  PipelineDesign
//
//  Created by ChenZeBin on 2021/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PortDelegate;

@interface ShareEventPort : NSObject<PortDelegate>

- (void)receiveShareEvent:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

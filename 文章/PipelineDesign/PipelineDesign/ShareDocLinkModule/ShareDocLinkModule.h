//
//  ShareDocLinkPipeline.h
//  PipelineDesign
//
//  Created by ChenZeBin on 2021/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareDocLinkModule : NSObject

- (void)receiveShareEvent:(NSDictionary *)dic generateLinkBlock:(void(^)(NSString *link))generateLinkBlock;

@end

NS_ASSUME_NONNULL_END

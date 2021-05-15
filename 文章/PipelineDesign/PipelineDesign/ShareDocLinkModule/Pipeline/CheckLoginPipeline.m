//
//  CheckLoginPipeline.m
//  PipelineDesign
//
//  Created by bytedance on 2021/5/15.
//

#import "CheckLoginPipeline.h"
#import "Packet.h"

@implementation CheckLoginPipeline

- (void)receivePacket:(id<Packet>)packet throwPacketBlock:(void(^)(id packet))block
{
    [self didLogic:^(BOOL isLoginSuccess) {
        if (isLoginSuccess) {
            PassNextPipeline(packet);
        } else {
            BlockInPipelibe(packet);
        }
    }];
}

- (void)didLogic:(void(^)(BOOL isLoginSuccess))block
{
    if ([self isLogin]) {
        !block ? : block(YES);
    } else {
        [self performLogicWithBlock:block];
    }
}

- (BOOL)isLogin
{
    return YES;
}

- (void)performLogicWithBlock:(void(^)(BOOL isLoginSuccess))block
{
    !block ? : block(YES);
}

@end

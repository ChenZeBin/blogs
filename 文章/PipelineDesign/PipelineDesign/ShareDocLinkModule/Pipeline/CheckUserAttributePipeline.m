//
//  CheckUserAttributePipeline.m
//  PipelineDesign
//
//  Created by bytedance on 2021/5/15.
//

#import "CheckUserAttributePipeline.h"
#import "Packet.h"

@implementation CheckUserAttributePipeline

- (void)receivePacket:(id<Packet>)packet throwPacketBlock:(void(^)(id packet))block
{
    if ([self checkUserCanGenerateLinkWithUserId:packet.userId]) {
        PassNextPipeline(packet);
    } else {
        BlockInPipelibe(packet);
    }
}

- (BOOL)checkUserCanGenerateLinkWithUserId:(NSString *)userId
{
    return YES;
}

@end

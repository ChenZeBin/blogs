//
//  CheckDocAttributePipeline.m
//  PipelineDesign
//
//  Created by bytedance on 2021/5/15.
//

#import "CheckDocAttributePipeline.h"
#import "Packet.h"

@implementation CheckDocAttributePipeline

- (void)receivePacket:(id<Packet>)packet throwPacketBlock:(void(^)(id packet))block
{
    if ([self checkDocCanGenerateLinkWithDocId:packet.docId]) {
        PassNextPipeline(packet);
    } else {
        BlockInPipelibe(packet);
    }
}

- (BOOL)checkDocCanGenerateLinkWithDocId:(NSString *)docId
{
    return YES;
}

@end

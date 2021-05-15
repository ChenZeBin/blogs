//
//  RequestDocLinkPipeline.m
//  PipelineDesign
//
//  Created by ChenZeBin on 2021/5/15.
//

#import "RequestDocLinkPipeline.h"
#import "Packet.h"
#import "RACEXTScope.h"

@implementation RequestDocLinkPipeline

- (void)receivePacket:(id<Packet>)packet throwPacketBlock:(void(^)(id packet))block
{
    @weakify(self);
    [self requestDocLinkWithDocId:packet.docId userId:packet.userId block:^(NSString *link) {
        @strongify(self);
        if ([self checkLinkValidWithLinkString:link]) {
            packet.linkString = link;
            PassNextPipeline(packet);
        } else {
            BlockInPipelibe(packet);
        }
    }];
}

- (void)requestDocLinkWithDocId:(NSString *)docId userId:(NSString *)userId block:(void(^)(NSString *link))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        !block ? : block(@"www.link.com");
    });
}

- (BOOL)checkLinkValidWithLinkString:(NSString *)linkString
{
    return YES;
}

@end

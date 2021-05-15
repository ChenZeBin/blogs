//
//  IMPort.m
//  PipelineDesign
//
//  Created by ChenZeBin on 2021/5/15.
//

#import "ShareEventPort.h"
#import "PipelinePlumber.h"
#import "Packet.h"

@implementation ShareEventPort
@synthesize throwPacketBlock;

- (void)receiveShareEvent:(NSDictionary *)dic
{
    Packet *packet = [Packet new];
    packet.metaData = dic;
    packet.docId = dic[@"docId"];
    packet.userId = dic[@"userId"];
    packet.entrance = dic[@"entrance"];
    
    NSInteger portNum = 100;
    
    self.throwPacketBlock(packet, portNum);
}

@end

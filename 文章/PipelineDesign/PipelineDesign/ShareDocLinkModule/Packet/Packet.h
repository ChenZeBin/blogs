//
//  Packet.h
//  PipelineDesign
//
//  Created by bytedance on 2021/5/15.
//
#import "PipelinePlumber.h"

#define PassNextPipeline(packet) !block ? : block(packet)
#define BlockInPipelibe(packet)

@protocol Packet <BasePacketProtocol>

@property (nonatomic, strong) NSDictionary *metaData;
@property (nonatomic, copy) NSString *docId;
@property (nonatomic, copy) NSString *entrance;
@property (nonatomic, copy) NSString *userId;

/// 这个信息在RequestDocLinkPipeline赋值
@property (nonatomic, copy) NSString *linkString;

@end

@interface Packet : NSObject<Packet>

@end

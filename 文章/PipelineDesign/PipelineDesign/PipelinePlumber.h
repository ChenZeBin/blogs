//
//  PipelineManager.h
//  Kit-Pods-Aweme
//
//  Created by ChenZeBin on 2021/1/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 数据协议
@protocol BasePacketProtocol <NSObject>

/// 端口号
@property (nonatomic, assign) NSInteger portNum;

@end

/// 端口协议
@protocol PortDelegate <NSObject>

@property (nonatomic, copy) void(^throwPacketBlock)(id packet, NSInteger portNum);

@end

@protocol PipelineDelegate <NSObject>

- (void)receivePacket:(id)packet throwPacketBlock:(void(^)(id packet))block;

@end

@class PipelinePlumber;

/// pipeline的水管工
@interface PipelinePlumber : NSObject

/// 添加端口
- (PipelinePlumber *(^)(id<PortDelegate>port))addPort;

/// 添加pipeline
- (PipelinePlumber *(^)(id<PipelineDelegate> pipeline))addPipeline;

/// 抛出经过一系列pipeline的数据
@property (nonatomic, strong) void(^throwPacketBlock)(id packet);

@end

/// 将pipeline拼接起来
FOUNDATION_EXPORT void serialPipeSpliceFunc(NSArray<id<PipelineDelegate>> *pipeArr, id firstPacket);

NS_ASSUME_NONNULL_END

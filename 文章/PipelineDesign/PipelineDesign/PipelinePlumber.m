//
//  PipelineManager.m
//  Kit-Pods-Aweme
//
//  Created by ChenZeBin on 2021/1/12.
//

#import "PipelinePlumber.h"
#import <objc/runtime.h>
#import "RACEXTScope.h"

void serialPipeSpliceFunc(NSArray<id<PipelineDelegate>> *pipeArr, id firstPacket)
{
    __block id tmpPacket = firstPacket;
    [pipeArr enumerateObjectsUsingBlock:^(id<PipelineDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj receivePacket:tmpPacket throwPacketBlock:^(id  _Nonnull packet) {
            tmpPacket = packet;
        }];
    }];
}


@interface NSObject(PipelinePlumber)

@property (nonatomic, strong) id<PipelineDelegate> plumber_nextPipeline;

@end

@implementation NSObject(PipelinePlumber)

- (void)setPlumber_nextPipeline:(id<PipelineDelegate>)plumber_nextPipeline
{
    if (plumber_nextPipeline && [plumber_nextPipeline conformsToProtocol:@protocol(PipelineDelegate)]) {
        objc_setAssociatedObject(self, @selector(plumber_nextPipeline), plumber_nextPipeline, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id<PipelineDelegate>)plumber_nextPipeline
{
    return objc_getAssociatedObject(self, @selector(plumber_nextPipeline));
}

@end


@interface PipelinePlumber()

@property (nonatomic, strong) NSMutableArray<id<PortDelegate>> *portArr;
@property (nonatomic, strong) NSMutableArray<id<PipelineDelegate>> *pipelineArr;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) id<PipelineDelegate> pCurPipeline;

@end

@implementation PipelinePlumber

- (PipelinePlumber *(^)(id<PortDelegate> port))addPort
{
    __weak typeof(self) wSelf = self;
    return ^(id<PortDelegate> port) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (port) {
            [sSelf.lock lock];
            [sSelf.portArr addObject:port];
            [sSelf.lock unlock];
        }
        return self;
    };
}

- (PipelinePlumber *(^)(id<PipelineDelegate> pipeline))addPipeline
{
    @weakify(self);
    return ^(id<PipelineDelegate> pipeline) {
        @strongify(self);
        if (pipeline) {
            [self.lock lock];
            [self.pipelineArr addObject:pipeline];
            
            if (self.pCurPipeline) {
                NSObject *dummy = (NSObject *)self.pCurPipeline;
                dummy.plumber_nextPipeline = pipeline;
            }
            self.pCurPipeline = pipeline;
            
            [self.lock unlock];
        }
        return self;
    };
}

- (void)handlePacket:(id)packet
{
    [self recurPipeline:self.pipelineArr.firstObject packet:packet];
}

- (void)recurPipeline:(id<PipelineDelegate>)pipeline packet:(id)packet
{
    if (!pipeline)
    {
        return;
    }
    
    @weakify(self);
    [pipeline receivePacket:packet throwPacketBlock:^(id  _Nonnull throwPacket) {
        @strongify(self);
        
        NSObject *dunmy = (NSObject *)pipeline;
        if (dunmy.plumber_nextPipeline) {
            [self recurPipeline:dunmy.plumber_nextPipeline packet:throwPacket];
        } else {
            !self.throwPacketBlock?:self.throwPacketBlock(throwPacket);
        }
    }];
}

- (void)setThrowPacketBlock:(void (^)(id _Nonnull))throwPacketBlock
{
    _throwPacketBlock = throwPacketBlock;
    
    @weakify(self);
    [self.portArr enumerateObjectsUsingBlock:^(id<PortDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        obj.throwPacketBlock = ^(id<BasePacketProtocol> packet, NSInteger portNum) {
            @strongify(self);
            packet.portNum = portNum;
            [self handlePacket:packet];
        };
    }];
}

#pragma mark - getter
- (NSMutableArray<id<PortDelegate>> *)portArr
{
    if (!_portArr) {
        _portArr = [NSMutableArray array];
    }
    
    return _portArr;
}

- (NSMutableArray<id<PipelineDelegate>> *)pipelineArr
{
    if (!_pipelineArr) {
        _pipelineArr = [NSMutableArray array];
    }
    
    return _pipelineArr;
}

- (NSLock *)lock
{
    if (!_lock) {
        _lock = [[NSLock alloc] init];
    }
    
    return _lock;
}

@end

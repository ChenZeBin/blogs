//
//  ShareDocLinkPipeline.m
//  PipelineDesign
//
//  Created by ChenZeBin on 2021/5/15.
//

#import "ShareDocLinkModule.h"
#import "PipelinePlumber.h"
#import "ShareEventPort.h"
#import "CheckLoginPipeline.h"
#import "CheckDocAttributePipeline.h"
#import "CheckUserAttributePipeline.h"
#import "RequestDocLinkPipeline.h"
#import "RACEXTScope.h"
#import "Packet.h"

@interface ShareDocLinkModule()

@property (nonatomic, strong) PipelinePlumber *plumber;
@property (nonatomic, strong) ShareEventPort *shareEventPort;
@property (nonatomic, copy) void(^generateLinkBlock)(NSString *link);

@end

@implementation ShareDocLinkModule

- (instancetype)init
{
    if (self = [super init]) {
        _plumber = [PipelinePlumber new];
        _shareEventPort = [ShareEventPort new];
        [self setupPipeline];
    }
    
    return self;
}

- (void)receiveShareEvent:(NSDictionary *)dic generateLinkBlock:(void(^)(NSString *link))generateLinkBlock
{
    [self.shareEventPort receiveShareEvent:dic];
    self.generateLinkBlock = generateLinkBlock;
}

- (void)setupPipeline
{
    // pipeline
    CheckLoginPipeline *checkLoginPipeline = [CheckLoginPipeline new];
    CheckDocAttributePipeline *checkDocAttributePipeline = [CheckDocAttributePipeline new];
    CheckUserAttributePipeline *checkUserAttributePipeline = [CheckUserAttributePipeline new];
    RequestDocLinkPipeline *requestDocLinkPipeline = [RequestDocLinkPipeline new];
    
    @weakify(self);
    self.plumber
    .addPort(self.shareEventPort)
    .addPipeline(checkLoginPipeline)
    .addPipeline(checkDocAttributePipeline)
    .addPipeline(checkUserAttributePipeline)
    .addPipeline(requestDocLinkPipeline)
    .throwPacketBlock = ^(id<Packet>  _Nonnull packet) {
        @strongify(self);
        self.generateLinkBlock(packet.linkString);
    };

}



@end

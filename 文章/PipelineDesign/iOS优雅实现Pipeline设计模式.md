# iOS优雅实现Pipeline设计模式
# 前言
该文介绍Pipeline设计模式，使用场景，以及如何使用OC语言，用链式语法优雅的将Pipeline串联起来。

# Pipeline设计
![](https://github.com/ChenZeBin/MyPicture/blob/master/Pipeline%E8%AE%BE%E8%AE%A1.png?raw=true)
思想来源于责任链模式，如上图所示，有三个概念：

- Port是产生数据对象；
- Pipeline是处理数据对象的管道；
- Packet是数据包，或者管道的上下文；

链路比较长的业务场景，大都可以套入这个模式；例如，

开播：
![](https://github.com/ChenZeBin/MyPicture/blob/master/%E5%BC%80%E6%92%AD%E9%93%BE%E8%B7%AF.png?raw=true)

1. 用户点击开播按钮产生一个点击事件，那么这个事件可以作为一个Port，用于产生点击事件
2. Port产生数据后，会流向Pipeline，假如开播需要先检查该用户是否具备开播资格，那么检查具备开播资格的业务代码可以作为一个Pipeline
3. 请求开播接口，以及接口返回后，需要判断是开播还是恢复直播等业务逻辑，可以作为一个Pipeline
4. 判断当前开播的场景，初始化对应的组件，布局等


# 需求描述
分享模块，比如用户要分享一个文档链接，那么当用户点击分享的时候，得走过以下的链路节点：

1. 检查是否已经登录
2. 检查该文档是否可以生成链接
3. 检查该用户是否有权限将一份文档生成链接
4. 请求文档生成链接的接口，生成链接

# 优雅实现Pipeline设计模式
按照以上的需求描述，我们会创建以下几个类：

1. ShareEventPort 产生用户点击分享事件的端口
2. Packet 用于在Pipeline中传递的数据包，包含的信息有文档ID，事件来源，UserId，元数据，链接的信息
3. CheckLoginPipeline 检查登录Pipeline
4. CheckDocAttributePipeline 检查文档属性(检查文档是否可以生成链接)
5. CheckUserAttributePipeline 检查用户的属性(检查用户是否有权限将一份文档生成链接)
6. RequestDocLinkPipeline 请求文档生成链接的接口，生成链接

最后，使用PipelinePlumber(水管工)将Port和Pipeline串联起来，在最末端的throwPacketBlock接收数据。

```
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

```

# 链式串联Pipeline工具介绍[PipelinePlumber]
![](https://github.com/ChenZeBin/MyPicture/blob/master/Pipeline%E8%AE%BE%E8%AE%A1.png?raw=true)
在整套设计模式中，有三个非常重要的概念，分别是Port、Pipeline、Packet；我将他们抽象成三个协议。

## 抽象Packet特征
### 介绍
```
/// 数据协议
@protocol BasePacketProtocol <NSObject>

/// 端口号
@property (nonatomic, assign) NSInteger portNum;

@end
```

Packet(数据包)肯定是由Port产生的，对于所有端口而言，具备的共同特征是“端口号”；所以Packet的数据协议中，只有一个`portNum `属性，表示端口号。

用处：如上图一样，会有多个不同的Port，在Pipeline中可能需要判断Packet是哪个端口产生的数据，这时就需要用到端口号了。

### 使用

```
@protocol Packet <BasePacketProtocol>

@property (nonatomic, strong) NSDictionary *metaData;
@property (nonatomic, copy) NSString *docId;
@property (nonatomic, copy) NSString *entrance;
@property (nonatomic, copy) NSString *userId;

/// 这个信息在RequestDocLinkPipeline赋值
@property (nonatomic, copy) NSString *linkString;

@end
```
当自己自定义一个Packet时，可以仿照上方代码，声明一个Packet协议继承BasePacketProtocol协议。这样`Packet `即可表示`Pipeline`中的数据包(上下文)。


## 抽象Port特征
```
/// 端口协议
@protocol PortDelegate <NSObject>

@property (nonatomic, copy) void(^throwPacketBlock)(id packet, NSInteger portNum);

@end
```
```
- (void)receiveShareEvent:(NSDictionary *)dic
{
    Packet *packet = [Packet new];
    packet.metaData = dic;
    packet.docId = dic[@"docId"];
    packet.userId = dic[@"userId"];
    packet.entrance = dic[@"entrance"];
    
    // 使用示例代码
    self.throwPacketBlock(packet, 100);
}

```
对于端口，这里只抽象出了抛数据的接口`throwPacketBlock `，当端口产生数据时，调用`throwPacketBlock `，填入两个参数，分别是`Packet`和端口号，即可往`Pipeline`传递数据了。

## 抽象Pipeline特征
```
@protocol PipelineDelegate <NSObject>

- (void)receivePacket:(id)packet throwPacketBlock:(void(^)(id packet))block;

@end
```
```
// 使用示例代码

#define PassNextPipeline(packet) !block ? : block(packet)
#define BlockInPipelibe(packet)

- (void)receivePacket:(id<Packet>)packet throwPacketBlock:(void(^)(id packet))block
{
    // packet是接收到由Port或者上个Pipeline传过来的数据包
    // 调用block，将数据流向下一个Pipeline
    if ([self checkDocCanGenerateLinkWithDocId:packet.docId]) {
        PassNextPipeline(packet);
    } else {
        BlockInPipelibe(packet);
    }
}

```

对于`Pipeline`来说，特性显而易见，就是输入和输出。

## 核心角色：PipelinePlumber 
PipelinePlumber是一个水管工，负责将Port和Pipeline串联起来，让数据可以流通。
### 接口
```
/// pipeline的水管工
@interface PipelinePlumber : NSObject

/// 添加端口
- (PipelinePlumber *(^)(id<PortDelegate>port))addPort;

/// 添加pipeline
- (PipelinePlumber *(^)(id<PipelineDelegate> pipeline))addPipeline;

/// 抛出经过一系列pipeline的数据
@property (nonatomic, strong) void(^throwPacketBlock)(id packet);

@end
```
### 实现
```
@property (nonatomic, strong) NSMutableArray<id<PortDelegate>> *portArr;
@property (nonatomic, strong) NSMutableArray<id<PipelineDelegate>> *pipelineArr;
```
`addPort`和`addPipeline `都是往数组添加对象。

#### 为啥在Port中调用`self.throwPacketBlock(packet, 100);`就可往`Pipeline`传输数据？

```
    @weakify(self);
    [self.portArr enumerateObjectsUsingBlock:^(id<PortDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        obj.throwPacketBlock = ^(id<BasePacketProtocol> packet, NSInteger portNum) {
            @strongify(self);
            packet.portNum = portNum;
            [self handlePacket:packet];
        };
    }];
```
监听了每个Port对象的`throwPacketBlock`，所以当在Port类中，调用`self.throwPacketBlock(packet, 100);`时，`PipelinePlumber `内就可监听到，并且处理`Packet`流向`Pipeline`。

#### `- (void)receivePacket:(id<Packet>)packet throwPacketBlock:(void(^)(id packet))block`实现中，调用block就可以将packet传向下一个Pipeline是如何实现的？
```
@interface NSObject(PipelinePlumber)

@property (nonatomic, strong) id<PipelineDelegate> plumber_nextPipeline;

@end
```

Pipeline对象会有一个plumber_nextPipeline属性，用于指向下一个Pipeline；在数据结构上，Pipeline是用单链表串联起来的，所以可以通过plumber_nextPipeline指针，从APipe->BPipe。

```
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
```
当Port类中调用`self.throwPacketBlock(packet, 100);`，会触发`handlePacket `方法，然后调用`recurPipeline `方法进行递归，实现packet从Port->APipe->BPipe->throwPacketBlock.

# Demo地址
https://github.com/ChenZeBin/blogs/tree/master/%E6%96%87%E7%AB%A0/PipelineDesign





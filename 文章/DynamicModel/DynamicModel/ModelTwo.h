//
//  ModelTwo.h
//  DynamicModel
//
//  Created by bytedance on 2021/6/7.
//

#import "IESLiveDynamicModelDefine.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, IDLForumApiForumStatus) {
    IDLForumApiForumStatusDELETE = 0,
    IDLForumApiForumStatusPUBLISH = 1,
    IDLForumApiForumStatusREVIEWING = 2,
    IDLForumApiForumStatusDEIT = 3,
};

@interface ModelTwo : IESLiveDynamicModel

@property(nonatomic,strong)NSString *str;
@property(nonatomic,strong)NSMutableArray *mutableAry;
@property(nonatomic,copy)NSArray *ary;
@property(nonatomic,strong)NSMutableDictionary *mutableDic;
@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic,assign)NSInteger integerType;
@property(nonatomic,assign)int64_t number;
@property(nonatomic,assign)double doubleType;
@property(nonatomic,assign)BOOL isTrue;
@property(nonatomic,assign)IDLForumApiForumStatus enumType;
@property(nonatomic,assign)SInt64 typesSInt64;
@property(nonatomic,assign)SInt32 TypesSInt32;
@property(nonatomic,assign)Float32 typesFloat32;
@property(nonatomic,assign)Float64 typesFloat64;

@end

NS_ASSUME_NONNULL_END

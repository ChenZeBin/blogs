//
//  FourModel.h
//  DynamicModel
//
//  Created by bytedance on 2021/6/17.
//

#import <Foundation/Foundation.h>
#import "IESLiveDynamicModelDefine.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, IESVSGiftAnimationItemType) {
    IESVSGiftAnimationItemTypeUnknow,
    IESVSGiftAnimationItemTypeNormal,
    IESVSGiftAnimationItemTypeCombo,
    IESVSGiftAnimationItemTypeVideoTray,
    IESVSGiftAnimationItemTypeVideoOnly
};

typedef NS_ENUM(NSUInteger, MyTestEnum) {
    MyTestEnum111,
};

typedef enum : NSUInteger {
    enum11,
} enum1;

typedef NS_ENUM(NSInteger, enum2) {
    enum22,
};

typedef enum : uint8_t {
    PersonTallMask  =  1 << 0,
    PersonRichMask  =  1 << 1,
    PersonHandsomeMask =  1 << 2,
    PersonHeavyMask =  1 << 3,
    PersonHouseMask =  1 << 4,
} PersonMask;

typedef NS_OPTIONS(NSUInteger, OPTIONSEnum) {
    OPTIONSEnum1 = 1 << 0,
};

struct structObjc {
    int a;
    int b;
};

typedef struct structObjc structObjc;

union UnionVar {
    long int l;
    int i;
};

@interface FourModel : IESLiveDynamicModel

@property (nonatomic, assign) NSString *myString;
@property (nonatomic, assign) unsigned int uIntVal;
// 测试脚本
@property (atomic) id test1;
@property (class) id test2;
@property (getter=test3) id test3;
@property (setter=setTest4:) id test4;
@property (readonly) id test5;


/// oc
// string
@property (nonatomic, strong) NSString *strongStr;
@property (nonatomic, copy) NSString *mcopyStr;
@property (nonatomic, strong) NSMutableString *mutStr;
// array
@property (nonatomic, strong) NSArray *strongAry;
@property (nonatomic, copy) NSArray *mCopyAry;
@property (nonatomic, strong) NSMutableArray *mutAry;
// set
@property (nonatomic, strong) NSSet *set;
@property (nonatomic, strong) NSMutableSet *mutSet;
// map
@property (nonatomic, strong) NSMapTable *mapTable;
// block
@property (nonatomic, copy) void(^myBlock1)(void);
@property (nonatomic, copy) int(^myBlock2)(NSString *str);
// id
@property (nonatomic, strong) id idObjc;
//@property (nonatomic, strong) NSObject *objc;
@property (nonatomic, strong) NSObject *Objc;

// 指针
@property (nonatomic, assign) int (*functionPointerDefault)(char *);
@property (nonatomic, assign) int *intPtr;

@property (nonatomic, assign) void *voidPtr;

// 基础数据类型
@property (nonatomic, assign) unsigned char ucharVal;
@property (nonatomic, assign) uint8_t realUCharVal; // typedef unsigned char           uint8_t;
@property (nonatomic, assign) char charVal;
@property (nonatomic, assign) enum1 enumVal1;
@property (nonatomic, assign) enum2 enumVal2;
@property (nonatomic, assign) PersonMask mask;
@property (nonatomic, assign) OPTIONSEnum optionEnumVal;
@property (nonatomic, assign) MyTestEnum testEnum;
@property(nonatomic) CGRect            frame;
//@property (nonatomic) CGPoint point;

@property (nonatomic, assign) union UnionVar unionVarVal;
@property (nonatomic, assign) BOOL resultBool;
@property (nonatomic, assign) float floatVal;
@property (nonatomic, assign) double doubleVal;
@property (nonatomic, assign) short shortVal;
@property (nonatomic, assign) ushort ushortVal;

@property (nonatomic, assign) int intVal;
@property (nonatomic, assign) int intVaL;

@property (nonatomic, assign) long longVal;
@property (nonatomic, assign) long long llongVal;
@property (nonatomic, assign) u_long ulongVal;

@property (nonatomic, assign) NSUInteger uIntegerVal;
@property (nonatomic, assign) UInt32 uint32Val;
@property (nonatomic, assign) char * charRef;

@property (nonatomic, assign) Class mclass;
@property (nonatomic, assign) int64_t int64t;
@property (nonatomic, assign) int32_t int32t;
@property (nonatomic, assign) uint32_t uint32t;
@property (nonatomic, assign) CFAbsoluteTime absoluteTime;
@property (nonatomic, copy) dispatch_block_t dispatchBlock;

@property (nonatomic, strong, readonly) NSString *readonlyStr;
@property(nonatomic, assign) BOOL isVerified; ///< 是否已绑定手机号
//@property (nonatomic, strong, readonly) NSString *readonlyStr111;
@property(nonatomic, assign) BOOL canUse;
@property (nonatomic, assign) CFTimeInterval timeInterval;
@property (nonatomic, assign) UIRectCorner rectCorner;
//@property (nonatomic, strong, class) NSObject *objc;

- (void)test111:(NSString *)string
        test222:(int)inta;

@end


@interface FiveModel : IESLiveDynamicModel

/// oc
// string
@property (nonatomic, strong, readonly) NSString *strongStr;
@property (nonatomic, copy) NSString *mcopyStr;
@property (nonatomic, strong) NSMutableString *mutStr;
// array
@property (nonatomic, strong) NSArray *strongAry;
@property (nonatomic, copy) NSArray *mCopyAry;
@property (nonatomic, strong) NSMutableArray *mutAry;
// set
@property (nonatomic, strong) NSSet *set;
@property (nonatomic, strong) NSMutableSet *mutSet;
// map
@property (nonatomic, strong) NSMapTable *mapTable;
// block
@property (nonatomic, copy) void(^myBlock1)(void);
@property (nonatomic, copy) int(^myBlock2)(NSString *str);
// id
@property (nonatomic, strong) id idObjc;
@property (nonatomic, strong) NSObject *objc;

@end


NS_ASSUME_NONNULL_END

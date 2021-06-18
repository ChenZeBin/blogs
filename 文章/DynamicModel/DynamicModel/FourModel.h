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
@property (nonatomic, strong) NSObject *objc;

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
//@property(nonatomic) CGRect            frame;
//@property (nonatomic) CGPoint point;

@property (nonatomic, assign) union UnionVar unionVarVal;
@property (nonatomic, assign) BOOL resultBool;
@property (nonatomic, assign) float floatVal;
@property (nonatomic, assign) double doubleVal;
@property (nonatomic, assign) short shortVal;
@property (nonatomic, assign) int intVal;
@property (nonatomic, assign) long longVal;
@property (nonatomic, assign) long long llongVal;

@property (nonatomic, assign) NSUInteger uIntegerVal;
@property (nonatomic, assign) UInt32 uint32Val;
@property (nonatomic, assign) char * charRef;

@property (nonatomic, assign) Class mclass;

@end

NS_ASSUME_NONNULL_END

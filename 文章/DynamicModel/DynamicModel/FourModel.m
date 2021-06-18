//
//  FourModel.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/17.
//

#import "FourModel.h"

int max(char *c)
{
    NSLog(@"max func");
    return 1;
}
static void * content = ((void *)0);


@implementation FourModel
@dynamic strongStr,mcopyStr,mutStr,strongAry,mCopyAry,mutAry,set,mutSet,mapTable,idObjc,objc,intPtr,voidPtr,ucharVal,realUCharVal,charVal,enumVal1,enumVal2,mask,optionEnumVal,unionVarVal,floatVal,doubleVal,shortVal,intVal,longVal,llongVal,uIntegerVal,functionPointerDefault,myBlock1,myBlock2,resultBool,uint32Val,charRef,mclass;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self change];
        
    }
    return self;
}

- (void)change
{
    /// oc
    // string
    self.strongStr = @"strongStr";
    self.mcopyStr = @"mcopyStr";
    self.mutStr = [[NSMutableString alloc] init];
    // array
    self.strongAry = @[@"strongAry"];
    self.mCopyAry = @[@"mCopyAry"];
    self.mutAry = @[@"mutAry"].mutableCopy;
    // set
    self.set = [[NSSet alloc] init];
    self.mutSet = [NSMutableSet set];
    // map
    self.mapTable = [NSMapTable weakToWeakObjectsMapTable];
    // block
    self.myBlock1 = ^{
        NSLog(@"myblock1");
    };
    self.myBlock2 = ^int(NSString * _Nonnull str) {
        NSLog(@"myBlock2");
        return 1;
    };
    // id
    self.idObjc = [NSObject new];
    self.objc = [NSObject new];
    
    // 指针
    self.mclass = [NSObject class];
    NSLog(@"%@",self.mclass);
    self.charRef = "123";
    self.functionPointerDefault = max;
    self.functionPointerDefault('c');
    int i = 10;
    self.intPtr = &i;
    self.voidPtr = &content;
    NSLog(@"%s",@encode(CGPoint));
//    self.frame = CGRectMake(1, 1, 1, 1);
//    self.point = CGPointMake(1, 1);
//
//    NSLog(@"%@",NSStringFromCGPoint(self.point) );
    
    // 基础数据类型
    self.uint32Val = 111;
    self.resultBool = YES;
    self.ucharVal = 'c';
    self.charVal = 'c';
    self.realUCharVal = 'C';
    self.doubleVal = 123.123;
    self.enumVal1 = enum11;
    self.enumVal2 = enum22;
    self.shortVal = 1;
    self.mask = PersonRichMask;
    self.optionEnumVal = OPTIONSEnum1;
    self.floatVal = 123.123;
    self.intVal = 1;
    self.longVal = 1;
    self.llongVal = 10;
    
    self.uIntegerVal = 1;
    self.uIntegerVal = -1;
    
    NSLog(@"%@",self.resultBool ? @"YES" : @"NO");
    NSLog(@"%@",self.strongStr);
    NSLog(@"%@",self.mcopyStr);
    NSLog(@"%@",self.mutStr);
    NSLog(@"%@",self.strongAry);
    NSLog(@"%@",self.mCopyAry);
    NSLog(@"%@",self.mutAry);
    NSLog(@"%@",self.set);
    NSLog(@"%@",self.mapTable);
    NSLog(@"%@",self.myBlock1);
    NSLog(@"%@",self.myBlock2);
    NSLog(@"%@",self.idObjc);
    NSLog(@"%@",self.objc);
    NSLog(@"%d",*(self.intPtr));
    NSLog(@"%d",self.voidPtr);
    NSLog(@"%c",self.charVal);
    NSLog(@"%lf",self.doubleVal);
    NSLog(@"%ld",self.enumVal1);
    NSLog(@"%ld",self.enumVal2);
    NSLog(@"%hhu",self.mask);
    NSLog(@"%ld",self.optionEnumVal);
    NSLog(@"%f",self.floatVal);
    NSLog(@"%d",self.intVal);
    NSLog(@"%ld",self.longVal);
    NSLog(@"%d",self.shortVal);
    NSLog(@"%ld",self.uIntegerVal);
    
    
}


@end

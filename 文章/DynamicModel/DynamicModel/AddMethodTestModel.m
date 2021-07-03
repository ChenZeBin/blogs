//
//  AddMethodTestModel.m
//  DynamicModel
//
//  Created by bytedance on 2021/7/2.
//

#import "AddMethodTestModel.h"

#define TimeConsuming(Code,LogCode) \
{\
    NSTimeInterval var1 = [[NSDate date] timeIntervalSince1970] * 1000;\
    Code\
    NSTimeInterval var2 = [[NSDate date] timeIntervalSince1970] * 1000;\
    NSTimeInterval timeConsuming = var2 - var1;\
    LogCode\
}

@implementation AddMethodTestModel
@dynamic string1,string2,string3,string4,string5,string6,string7,string8,string9,string10,string11,string12,string13,string14,string15,string16,string17,string18,string19,string110,string21,string22,string23,string24,string25,string26,string27,string28,string29,string210,string31,string32,string33,string34,string35,string36,string37,string38,string39,string310,string311,string312,string313,string314,string315,string316,string317,string318,string319,string3110,string321,string322,string323,string324,string325,string326,string327,string328,string329,string3210,string821,string822,string823,string824,string825,string826,string827,string828,string829,string8210,string831,string832,string833,string834,string835,string836,string837,string838,string839,string8310,string8311,string8312,string8313,string8314,string8315,string8316,string8317,string8318,string8319,string83110,string8321,string8322,string8323,string8324,string8325,string8326,string8327,string8328,string8329,string83210;
//
//

@dynamic intVal1,intVal2,intVal3,intVal4,intVal5,intVal6,intVal7,intVal8,intVal9,intVal10,intVal11,intVal12,intVal13,intVal14,intVal15,intVal16,intVal17,intVal18,intVal19,intVal110,intVal21,intVal22,intVal23,intVal24,intVal25,intVal26,intVal27,intVal28,intVal29,intVal210,intVal31,intVal32,intVal33,intVal34,intVal35,intVal36,intVal37,intVal38,intVal39,intVal310,intVal311,intVal312,intVal313,intVal314,intVal315,intVal316,intVal317,intVal318,intVal319,intVal3110,intVal321,intVal322,intVal323,intVal324,intVal325,intVal326,intVal327,intVal328,intVal329,intVal3210,intVal821,intVal822,intVal823,intVal824,intVal825,intVal826,intVal827,intVal828,intVal829,intVal8210,intVal831,intVal832,intVal833,intVal834,intVal835,intVal836,intVal837,intVal838,intVal839,intVal8310,intVal8311,intVal8312,intVal8313,intVal8314,intVal8315,intVal8316,intVal8317,intVal8318,intVal8319,intVal83110,intVal8321,intVal8322,intVal8323,intVal8324,intVal8325,intVal8326,intVal8327,intVal8328,intVal8329,intVal83210;


- (instancetype)init
{
    if (self = [super init]) {
        
        NSLog(@"OC类型");
        TimeConsuming({
            [self getterMethod];
        },{
            NSLog(@"getter 首次耗时:%lf ms",timeConsuming);
        });

        TimeConsuming({
            [self getterMethod];
        },{
            NSLog(@"getter 非首次耗时:%lf ms",timeConsuming);
        });

        TimeConsuming({
            [self setterMethod];
        },{
            NSLog(@"setter 首次耗时:%lf ms",timeConsuming);
        });

        TimeConsuming({
            [self setterMethod];
        },{
            NSLog(@"setter 非首次耗时:%lf ms",timeConsuming);
        });

        
        NSLog(@"基础数据类型");
        TimeConsuming({
            [self getterMethod111];
        },{
            NSLog(@"getter 首次耗时:%lf ms",timeConsuming);
        });
        
        TimeConsuming({
            [self getterMethod111];
        },{
            NSLog(@"getter 非首次耗时:%lf ms",timeConsuming);
        });
        
        TimeConsuming({
            [self setterMethod111];
        },{
            NSLog(@"setter 首次耗时:%lf ms",timeConsuming);
        });
        
        TimeConsuming({
            [self setterMethod111];
        },{
            NSLog(@"setter 非首次耗时:%lf ms",timeConsuming);
        });
//        
        
    }
    
    return self;
}

- (void)setterMethod
{
    // 100个属性
    self.string1 = @"123";
    self.string2 = @"123";
    self.string3 = @"123";
    self.string4 = @"123";
    self.string5 = @"123";
    self.string6 = @"123";
    self.string7 = @"123";
    self.string8 = @"123";
    self.string9 = @"123";
    self.string10 = @"123";

    self.string11 = @"123";
    self.string12 = @"123";
    self.string13 = @"123";
    self.string14 = @"123";
    self.string15 = @"123";
    self.string16 = @"123";
    self.string17 = @"123";
    self.string18 = @"123";
    self.string19 = @"123";
    self.string110 = @"123";

    self.string21 = @"123";
    self.string22 = @"123";
    self.string23 = @"123";
    self.string24 = @"123";
    self.string25 = @"123";
    self.string26 = @"123";
    self.string27 = @"123";
    self.string28 = @"123";
    self.string29 = @"123";
    self.string210 = @"123";

    self.string31 = @"123";
    self.string32 = @"123";
    self.string33 = @"123";
    self.string34 = @"123";
    self.string35 = @"123";
    self.string36 = @"123";
    self.string37 = @"123";
    self.string38 = @"123";
    self.string39 = @"123";
    self.string310 = @"123";

    self.string311 = @"123";
    self.string312 = @"123";
    self.string313 = @"123";
    self.string314 = @"123";
    self.string315 = @"123";
    self.string316 = @"123";
    self.string317 = @"123";
    self.string318 = @"123";
    self.string319 = @"123";
    self.string3110 = @"123";

    self.string321 = @"123";
    self.string322 = @"123";
    self.string323 = @"123";
    self.string324 = @"123";
    self.string325 = @"123";
    self.string326 = @"123";
    self.string327 = @"123";
    self.string328 = @"123";
    self.string329 = @"123";
    self.string3210 = @"123";

    self.string821 = @"123";
    self.string822 = @"123";
    self.string823 = @"123";
    self.string824 = @"123";
    self.string825 = @"123";
    self.string826 = @"123";
    self.string827 = @"123";
    self.string828 = @"123";
    self.string829 = @"123";
    self.string8210 = @"123";

    self.string831 = @"123";
    self.string832 = @"123";
    self.string833 = @"123";
    self.string834 = @"123";
    self.string835 = @"123";
    self.string836 = @"123";
    self.string837 = @"123";
    self.string838 = @"123";
    self.string839 = @"123";
    self.string8310 = @"123";

    self.string8311 = @"123";
    self.string8312 = @"123";
    self.string8313 = @"123";
    self.string8314 = @"123";
    self.string8315 = @"123";
    self.string8316 = @"123";
    self.string8317 = @"123";
    self.string8318 = @"123";
    self.string8319 = @"123";
    self.string83110 = @"123";

    self.string8321 = @"123";
    self.string8322 = @"123";
    self.string8323 = @"123";
    self.string8324 = @"123";
    self.string8325 = @"123";
    self.string8326 = @"123";
    self.string8327 = @"123";
    self.string8328 = @"123";
    self.string8329 = @"123";
    self.string83210 = @"123";
}

- (void)getterMethod
{
    // 100个属性
    self.string1 ;
    self.string2 ;
    self.string3 ;
    self.string4 ;
    self.string5 ;
    self.string6 ;
    self.string7 ;
    self.string8 ;
    self.string9 ;
    self.string10 ;

    self.string11 ;
    self.string12 ;
    self.string13 ;
    self.string14 ;
    self.string15 ;
    self.string16 ;
    self.string17 ;
    self.string18 ;
    self.string19 ;
    self.string110 ;

    self.string21 ;
    self.string22 ;
    self.string23 ;
    self.string24 ;
    self.string25 ;
    self.string26 ;
    self.string27 ;
    self.string28 ;
    self.string29 ;
    self.string210 ;

    self.string31 ;
    self.string32 ;
    self.string33 ;
    self.string34 ;
    self.string35 ;
    self.string36 ;
    self.string37 ;
    self.string38 ;
    self.string39 ;
    self.string310 ;

    self.string311 ;
    self.string312 ;
    self.string313 ;
    self.string314 ;
    self.string315 ;
    self.string316 ;
    self.string317 ;
    self.string318 ;
    self.string319 ;
    self.string3110 ;

    self.string321 ;
    self.string322 ;
    self.string323 ;
    self.string324 ;
    self.string325 ;
    self.string326 ;
    self.string327 ;
    self.string328 ;
    self.string329 ;
    self.string3210 ;

    self.string821 ;
    self.string822 ;
    self.string823 ;
    self.string824 ;
    self.string825 ;
    self.string826 ;
    self.string827 ;
    self.string828 ;
    self.string829 ;
    self.string8210 ;

    self.string831 ;
    self.string832 ;
    self.string833 ;
    self.string834 ;
    self.string835 ;
    self.string836 ;
    self.string837 ;
    self.string838 ;
    self.string839 ;
    self.string8310 ;

    self.string8311 ;
    self.string8312 ;
    self.string8313 ;
    self.string8314 ;
    self.string8315 ;
    self.string8316 ;
    self.string8317 ;
    self.string8318 ;
    self.string8319 ;
    self.string83110 ;

    self.string8321 ;
    self.string8322 ;
    self.string8323 ;
    self.string8324 ;
    self.string8325 ;
    self.string8326 ;
    self.string8327 ;
    self.string8328 ;
    self.string8329 ;
    self.string83210 ;
}
- (void)setterMethod111
{
    // 100个属性
    self.intVal1 = 123;
    self.intVal2 = 123;
    self.intVal3 = 123;
    self.intVal4 = 123;
    self.intVal5 = 123;
    self.intVal6 = 123;
    self.intVal7 = 123;
    self.intVal8 = 123;
    self.intVal9 = 123;
    self.intVal10 = 123;

    self.intVal11 = 123;
    self.intVal12 = 123;
    self.intVal13 = 123;
    self.intVal14 = 123;
    self.intVal15 = 123;
    self.intVal16 = 123;
    self.intVal17 = 123;
    self.intVal18 = 123;
    self.intVal19 = 123;
    self.intVal110 = 123;

    self.intVal21 = 123;
    self.intVal22 = 123;
    self.intVal23 = 123;
    self.intVal24 = 123;
    self.intVal25 = 123;
    self.intVal26 = 123;
    self.intVal27 = 123;
    self.intVal28 = 123;
    self.intVal29 = 123;
    self.intVal210 = 123;

    self.intVal31 = 123;
    self.intVal32 = 123;
    self.intVal33 = 123;
    self.intVal34 = 123;
    self.intVal35 = 123;
    self.intVal36 = 123;
    self.intVal37 = 123;
    self.intVal38 = 123;
    self.intVal39 = 123;
    self.intVal310 = 123;

    self.intVal311 = 123;
    self.intVal312 = 123;
    self.intVal313 = 123;
    self.intVal314 = 123;
    self.intVal315 = 123;
    self.intVal316 = 123;
    self.intVal317 = 123;
    self.intVal318 = 123;
    self.intVal319 = 123;
    self.intVal3110 = 123;

    self.intVal321 = 123;
    self.intVal322 = 123;
    self.intVal323 = 123;
    self.intVal324 = 123;
    self.intVal325 = 123;
    self.intVal326 = 123;
    self.intVal327 = 123;
    self.intVal328 = 123;
    self.intVal329 = 123;
    self.intVal3210 = 123;

    self.intVal821 = 123;
    self.intVal822 = 123;
    self.intVal823 = 123;
    self.intVal824 = 123;
    self.intVal825 = 123;
    self.intVal826 = 123;
    self.intVal827 = 123;
    self.intVal828 = 123;
    self.intVal829 = 123;
    self.intVal8210 = 123;

    self.intVal831 = 123;
    self.intVal832 = 123;
    self.intVal833 = 123;
    self.intVal834 = 123;
    self.intVal835 = 123;
    self.intVal836 = 123;
    self.intVal837 = 123;
    self.intVal838 = 123;
    self.intVal839 = 123;
    self.intVal8310 = 123;

    self.intVal8311 = 123;
    self.intVal8312 = 123;
    self.intVal8313 = 123;
    self.intVal8314 = 123;
    self.intVal8315 = 123;
    self.intVal8316 = 123;
    self.intVal8317 = 123;
    self.intVal8318 = 123;
    self.intVal8319 = 123;
    self.intVal83110 = 123;

    self.intVal8321 = 123;
    self.intVal8322 = 123;
    self.intVal8323 = 123;
    self.intVal8324 = 123;
    self.intVal8325 = 123;
    self.intVal8326 = 123;
    self.intVal8327 = 123;
    self.intVal8328 = 123;
    self.intVal8329 = 123;
    self.intVal83210 = 123;
}

- (void)getterMethod111
{
    // 100个属性
    self.intVal1 ;
    self.intVal2 ;
    self.intVal3 ;
    self.intVal4 ;
    self.intVal5 ;
    self.intVal6 ;
    self.intVal7 ;
    self.intVal8 ;
    self.intVal9 ;
    self.intVal10 ;

    self.intVal11 ;
    self.intVal12 ;
    self.intVal13 ;
    self.intVal14 ;
    self.intVal15 ;
    self.intVal16 ;
    self.intVal17 ;
    self.intVal18 ;
    self.intVal19 ;
    self.intVal110 ;

    self.intVal21 ;
    self.intVal22 ;
    self.intVal23 ;
    self.intVal24 ;
    self.intVal25 ;
    self.intVal26 ;
    self.intVal27 ;
    self.intVal28 ;
    self.intVal29 ;
    self.intVal210 ;

    self.intVal31 ;
    self.intVal32 ;
    self.intVal33 ;
    self.intVal34 ;
    self.intVal35 ;
    self.intVal36 ;
    self.intVal37 ;
    self.intVal38 ;
    self.intVal39 ;
    self.intVal310 ;

    self.intVal311 ;
    self.intVal312 ;
    self.intVal313 ;
    self.intVal314 ;
    self.intVal315 ;
    self.intVal316 ;
    self.intVal317 ;
    self.intVal318 ;
    self.intVal319 ;
    self.intVal3110 ;

    self.intVal321 ;
    self.intVal322 ;
    self.intVal323 ;
    self.intVal324 ;
    self.intVal325 ;
    self.intVal326 ;
    self.intVal327 ;
    self.intVal328 ;
    self.intVal329 ;
    self.intVal3210 ;

    self.intVal821 ;
    self.intVal822 ;
    self.intVal823 ;
    self.intVal824 ;
    self.intVal825 ;
    self.intVal826 ;
    self.intVal827 ;
    self.intVal828 ;
    self.intVal829 ;
    self.intVal8210 ;

    self.intVal831 ;
    self.intVal832 ;
    self.intVal833 ;
    self.intVal834 ;
    self.intVal835 ;
    self.intVal836 ;
    self.intVal837 ;
    self.intVal838 ;
    self.intVal839 ;
    self.intVal8310 ;

    self.intVal8311 ;
    self.intVal8312 ;
    self.intVal8313 ;
    self.intVal8314 ;
    self.intVal8315 ;
    self.intVal8316 ;
    self.intVal8317 ;
    self.intVal8318 ;
    self.intVal8319 ;
    self.intVal83110 ;

    self.intVal8321 ;
    self.intVal8322 ;
    self.intVal8323 ;
    self.intVal8324 ;
    self.intVal8325 ;
    self.intVal8326 ;
    self.intVal8327 ;
    self.intVal8328 ;
    self.intVal8329 ;
    self.intVal83210 ;
}


@end

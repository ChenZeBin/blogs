//
//  ModelTwo.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/7.
//

#import "ModelTwo.h"

@implementation ModelTwo
@dynamic str,ary,mutableAry,number,isTrue,enumType,integerType,doubleType,TypesSInt32,typesSInt64,typesFloat32,typesFloat64,mutableDic,dic;

- (void)change
{
    self.number = 10;
    self.isTrue = false;
    self.isTrue = true;
    self.integerType = 90;
    self.enumType = IDLForumApiForumStatusDEIT;
    self.doubleType = 9.8;
    NSMutableArray *temp = [NSMutableArray new];
    [temp addObject:@"1111"];
    self.mutableAry = temp;
    self.ary = temp;
    [temp addObject:@"33333"];
    self.str = @"chenzebin";
    
    NSMutableDictionary *dicTemp = [NSMutableDictionary new];
    [dicTemp setValue:@"2222" forKey:@"1"];
    self.mutableDic = dicTemp;
    self.dic = dicTemp;
    [dicTemp setValue:@"eeee" forKey:@"2"];
    
    self.typesFloat32 = 32.32;
    self.typesFloat64 = 79.99;
    self.typesSInt64 = 64;
    self.TypesSInt32 = 32;
    
    NSInteger integerTypeTemp = self.integerType;
    int64_t intTypeTemp = self.number;
    double doubleTypeTemp = self.doubleType;
    BOOL  isTrueTemp = self.isTrue;
    IDLForumApiForumStatus enumTypeTemp = self.enumType;
    SInt64 typesSInt64 = self.typesSInt64;
    SInt32 typesSInt32 = self.TypesSInt32;
    SInt32 typesSInt321 = self.TypesSInt32;
    Float32 typesFloat32 = self.typesFloat32;
    Float64 typesFloat64 = self.typesFloat64;
    
    NSLog(@"%@", self.str);
    NSLog(@"%@", self.ary);
    NSLog(@"%@", self.mutableAry);
    int a  =0 ;
}

@end

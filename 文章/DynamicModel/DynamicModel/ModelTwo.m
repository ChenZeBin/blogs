//
//  ModelTwo.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/7.
//

#import "ModelTwo.h"
#import <objc/runtime.h>

NSArray<NSString *> *getPropertiesList11(Class cls)
{
    NSMutableArray *dicTemp = [NSMutableArray array];
    // 遍历子类到父类的所有属性
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *key = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];;
        [dicTemp addObject:key];
    }
    free(properties);
    return [dicTemp copy];
}

@implementation ModelTwo
@dynamic str,mutableAry,ary,mutableDic,dic,integerType,number,doubleType,isTrue,enumType,typesSInt64,TypesSInt32,typesFloat32,typesFloat64;

+ (void)load
{
    NSArray *arr = getPropertiesList11([self class]);
    __block NSMutableString *string = [NSMutableString stringWithString:@"@dynamic "];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendString:[NSString stringWithFormat:@"%@,",obj]];
    }];
    [string replaceCharactersInRange:NSMakeRange(string.length-1, 1) withString:@";"];
    
    NSLog(@"czb__%@",string);
}



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

//
//  ModelTwo.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/7.
//

#import "ModelTwo.h"
#import <objc/runtime.h>
#import <ReactiveObjC/ReactiveObjC.h>

@implementation ModelTwo
@dynamic str,mutableAry,ary,mutableDic,dic,integerType,number,doubleType,isTrue,enumType,typesSInt64,TypesSInt32,typesFloat32,typesFloat64;

- (instancetype)init
{
    if (self = [super init]) {
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
        [self addObserver:self forKeyPath:@"number" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"mutableAry" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"str" options:NSKeyValueObservingOptionNew context:nil];

        
        [RACObserve(self, number) subscribeNext:^(NSNumber *  _Nullable x) {
            NSLog(@"rac:number:%@",x);
        }];
        [RACObserve(self, mutableAry) subscribeNext:^(id  _Nullable x) {
            NSLog(@"rac:mutableAry:%@",x);
        }];
        [RACObserve(self, str) subscribeNext:^(id  _Nullable x) {
            NSLog(@"rac:str:%@",x);
        }];
        self.number = 88;
        self.mutableAry = [NSMutableDictionary dictionaryWithDictionary:@{@"new" : @1}];
        self.str = @"123";
        [self setValue:@"321" forKey:@"str"];
        
        
        
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"kvo:%@--%@",object,change);
}



@end

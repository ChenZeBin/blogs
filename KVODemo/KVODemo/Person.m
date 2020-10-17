//
//  Person.m
//  KVODemo
//
//  Created by chenzebin on 2019/1/9.
//  Copyright © 2019年 陈泽槟. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    return YES;
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"dog"]) {
        return [[NSSet alloc] initWithObjects:@"_dog.name", nil];
    } else {
        return [super keyPathsForValuesAffectingValueForKey:key];
    }
}

- (NSMutableArray *)mArr
{
    if (!_mArr) {
        _mArr = [[NSMutableArray alloc] init];
    }
    return _mArr;
}

@end

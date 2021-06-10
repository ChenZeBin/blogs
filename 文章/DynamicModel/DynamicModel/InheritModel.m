//
//  InheritModel.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/9.
//

#import "InheritModel.h"

@implementation InheritModel

@end

@implementation InheritModel1


@end


@implementation InheritModel2


@end


@implementation InheritModel3

- (instancetype)init
{
    if (self = [super init]) {
        self._111 = @"111";
        self._222 = @"222";
        self._333 = @"333";
        NSLog(@"%@,%@,%@",self._111,self._222,self._333);
    }
    
    return self;
}

@end


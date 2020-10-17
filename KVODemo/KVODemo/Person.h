//
//  Person.h
//  KVODemo
//
//  Created by chenzebin on 2019/1/9.
//  Copyright © 2019年 陈泽槟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Dog *dog;
@property (nonatomic, strong) NSMutableArray *mArr;

@end

NS_ASSUME_NONNULL_END

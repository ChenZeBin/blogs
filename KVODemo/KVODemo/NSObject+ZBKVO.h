//
//  NSObject+ZBKVO.h
//  KVODemo
//
//  Created by chenzebin on 2019/1/11.
//  Copyright © 2019年 陈泽槟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZBKVO)

-(void)zb_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end

NS_ASSUME_NONNULL_END

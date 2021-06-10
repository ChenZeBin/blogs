//
//  InheritModel.h
//  DynamicModel
//
//  Created by bytedance on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import "IESLiveDynamicModelDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface InheritModel : IESLiveDynamicModel

@end

@interface InheritModel1 : InheritModel

@property (nonatomic, strong) NSString *_111;

@end


@interface InheritModel2 : InheritModel1

@property (nonatomic, strong) NSString *_222;

@end


@interface InheritModel3 : InheritModel2

@property (nonatomic, strong) NSString *_333;

@end

NS_ASSUME_NONNULL_END

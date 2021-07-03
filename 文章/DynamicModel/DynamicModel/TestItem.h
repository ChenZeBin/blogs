//
//  TestItem.h
//  DynamicModel
//
//  Created by bytedance on 2021/6/28.
//

#import <Foundation/Foundation.h>
#import "IESLiveDynamicModelDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestIDItem : IESLiveDynamicModel

@property (nonatomic, strong) NSString *string;

@end

@interface TestItem : IESLiveDynamicModel
@property (nonatomic, strong) NSString *string;

@end

@interface TestaaItem : UIButton
@property (nonatomic, strong) NSString *string;

@end

@interface Testaa1Item:UIButton
@property (nonatomic, strong) NSString *string;

@end
@interface Testaa2Item :UIButton
@property (nonatomic, strong) NSString *string;

@end
@interface Testaa3Item: UIButton
@property (nonatomic, strong) NSString *string;

@end
NS_ASSUME_NONNULL_END

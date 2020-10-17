//
//  ShareItem.h
//  BinSystemShare
//
//  Created by chenzebin on 2019/5/12.
//  Copyright © 2019年 陈泽槟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareItem : NSObject<UIActivityItemSource>
/*
 不需要设置UIActivityItemSource的代理，只需要实现代理方法就可以了，因为在
 UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[item] applicationActivities:nil];方法中，估计这个方法里面会在对应的时机通过item调对应的代理方法，以此来达到回调的目的
 */

- (instancetype)initWithUrlString:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END

//
//  ShareItem.m
//  BinSystemShare
//
//  Created by chenzebin on 2019/5/12.
//  Copyright © 2019年 陈泽槟. All rights reserved.
//

#import "ShareItem.h"

@interface ShareItem()

@property (nonatomic, copy) NSString *urlString;

@end

@implementation ShareItem

- (instancetype)initWithUrlString:(NSString *)urlString
{
    if (self = [super init]) {
        self.urlString = urlString;
    }
    
    return self;
}

#pragma mark - UIActivityItemSource
-(id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return [NSURL URLWithString:self.urlString];
}

-(id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    NSLog(@"%@", activityType);
    return [NSURL URLWithString:self.urlString];
}

@end

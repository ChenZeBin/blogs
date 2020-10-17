//
//  ViewController.m
//  BinSystemShare
//
//  Created by chenzebin on 2019/5/12.
//  Copyright © 2019年 陈泽槟. All rights reserved.
//

#import "ViewController.h"
#import "ShareItem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ShareItem *item = [[ShareItem alloc] initWithUrlString:@"https://itunes.apple.com/cn/app/wps-office-shen-du-jian-rongword/id599852710?mt=8"];
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[item] applicationActivities:nil];
    vc.excludedActivityTypes = [self excludetypes];
    [self presentViewController:vc animated:YES completion:nil];
}

-(NSArray *)excludetypes{
    
    NSMutableArray *excludeTypesM =  [NSMutableArray arrayWithArray:@[//UIActivityTypePostToFacebook,
                                                                      UIActivityTypePostToTwitter,
                                                                      UIActivityTypePostToWeibo,
                                                                      ]];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
        [excludeTypesM addObject:UIActivityTypeMarkupAsPDF];
    }
    
    return excludeTypesM;
}

@end

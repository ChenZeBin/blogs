//
//  ViewController.m
//  PipelineDesign
//
//  Created by bytedance on 2021/5/15.
//

#import "ViewController.h"
#import "ShareDocLinkModule.h"

@interface ViewController ()

@property (nonatomic, strong) ShareDocLinkModule *shareDocLinkModule;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shareDocLinkModule = [ShareDocLinkModule new];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.shareDocLinkModule receiveShareEvent:@{
        @"docId" : @"111111",
        @"userId" : @"22222",
        @"entrance" : @"test"
    } generateLinkBlock:^(NSString * _Nonnull link) {
        NSLog(@"link:%@",link);
    }];
}


@end

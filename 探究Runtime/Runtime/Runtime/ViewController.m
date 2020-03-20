//
//  ViewController.m
//  Runtime
//
//  Created by Corbin on 2019/12/3.
//  Copyright © 2019 ChenZeBin. All rights reserved.
//

#import "ViewController.h"
#import "BIvar.h"

@interface ViewController ()

@property (nonatomic, strong) BIvar *bIvar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.bIvar test];
}


#pragma mark - getter
- (BIvar *)bIvar
{
    if (!_bIvar)
    {
        _bIvar = [[BIvar alloc] init];
    }
    
    return _bIvar;
}


@end

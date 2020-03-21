//
//  BaseViewController.m
//  CrashDemo
//
//  Created by chenzebin on 2020/3/21.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "BaseViewController.h"
#import "CrashHandler.h"
#import <objc/runtime.h>

@interface BaseViewController ()

@property (nonatomic, strong) CrashHandler *crashHandler;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    BOOL test = [super resolveInstanceMethod:sel];
    
    return test;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (!class_getInstanceMethod([self.crashHandler class], aSelector)) {
        class_addMethod([self.crashHandler class], aSelector, (IMP)crashHandler_crash, "@@:@");
    }
    return self.crashHandler;
}

- (CrashHandler *)crashHandler
{
    if (!_crashHandler) {
        _crashHandler = [[CrashHandler alloc] init];
    }
    
    return _crashHandler;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ViewController.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/7.
//

#import "ViewController.h"
#import "ModelOne.h"
#import "ModelTwo.h"
#import <objc/runtime.h>
#import "InheritModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ModelOne *one = [ModelOne new];
    
    ModelTwo *two = [ModelTwo new];
    
    InheritModel3 *three = [InheritModel3 new];
    
}



@end

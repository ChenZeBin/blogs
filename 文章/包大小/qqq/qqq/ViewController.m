//
//  ViewController.m
//  qqq
//
//  Created by bytedance on 2021/5/25.
//


#import "ViewController.h"

#define MethodBlockFunc(BLOCK)\
[self doSomeThing];\
BLOCK\
[self againDoSomeThing];\

void methodBlockFunc(ViewController *vc, void(^block)(void))
{
    [vc methodBlock:block];
}

@interface A : NSObject


@end

@implementation A

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"123");

}

- (void)methodBlock:(void(^)(void))block
{
    [self doSomeThing];
    block();
    [self againDoSomeThing];
}

- (void)blockCallbackDoSomeThing
{
    
}

- (void)doSomeThing
{
    
}

- (void)againDoSomeThing
{
    
}

@end

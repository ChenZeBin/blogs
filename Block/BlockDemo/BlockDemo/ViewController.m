//
//  ViewController.m
//  BlockDemo
//
//  Created by chenzebin on 2020/4/12.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test1];
//    [self test2];
    [self test3];
}

- (void)test1
{
    NSString *string = @"aaa";
    NSLog(@"str指针:%p",&string);
    NSString*(^append)(void)=^{
        NSLog(@"blockStr指针:%p",&string);
        return [string stringByAppendingString:@"ccc"];
    };
    append();
    string = @"bbb";
    NSLog(@"str指针：%p",&string);
    NSLog(@"\\n %@",append());  //结果：aaaccc
}

- (void)test2
{
    int a = 1;
    static int b = 1;
    NSLog(@"a:%p",&a);
    NSLog(@"b:%p",&b);
    
    void(^block)(void) = ^{
        NSLog(@"block_a:%p",&a);
        NSLog(@"block_b:%p",&b);
    };
    
    block();
}

- (void)test3
{
    __block int a = 1;
    
    void(^block1)(void) = ^{
        a++;
    };
    
    void(^block2)(void) = ^{
        a++;
    };
    
    block1();
    block2();
    
    a++;
    
    NSLog(@"a:%d",a);
}


@end

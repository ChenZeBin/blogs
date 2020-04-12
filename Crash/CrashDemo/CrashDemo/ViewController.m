//
//  ViewController.m
//  CrashDemo
//
//  Created by chenzebin on 2020/3/21.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"

@interface teststr : NSObject


@end

@implementation teststr

- (void)dealloc
{
    
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(aaaa)];
    
    __weak teststr *str1;
    @autoreleasepool {
        NSArray *str = [[NSArray alloc] init];
        str1 = str;
    }
    NSLog(@"%@", str1); // Console: (null)
    
}


@end

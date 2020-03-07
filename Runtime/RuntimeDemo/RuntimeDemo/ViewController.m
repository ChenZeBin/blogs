//
//  ViewController.m
//  RuntimeDemo
//
//  Created by chenzebin on 2020/3/5.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@property (nonatomic, copy) NSString *string;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test1];
}

- (void)test1
{
    objc_property_t t = class_getProperty([self class],"string");
    
    const char *name = property_getName(t);

    const char *att = property_getAttributes(t);
    
    NSLog(@"name:%s,att:%s,----%s",name, att,@encode(NSString));
    
}


@end

//
//  ViewController.m
//  RuntimeDemo
//
//  Created by chenzebin on 2020/3/5.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()

@property (nonatomic, copy) NSString *string;

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
    objc_property_t t = class_getProperty([self class],"string");
    
    const char *name = property_getName(t);

    const char *att = property_getAttributes(t);
    
    NSLog(@"name:%s,att:%s,----%s",name, att,@encode(NSString));
}

- (void)test2
{
    //获取类中的属性列表
    unsigned int propertyCount;
    objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i<propertyCount; i++) {
        NSLog(@"属性的名称为 : %s",property_getName(properties[i]));
        NSLog(@"属性的特性字符串为: %s",property_getAttributes(properties[i]));
    }
    free(properties);
}

- (void)test3
{
    ViewController *vc1 = [ViewController new];
    ViewController *vc2 = [ViewController new];

//    NSLog(@"vc1.class:%p",[vc1 class]);
//    NSLog(@"vc2.class:%p",[vc2 class]);
    
    NSLog(@"v1.object_getClass:%p",object_getClass(vc1));
    NSLog(@"v2.object_getClass:%p",object_getClass(vc2));

}




@end

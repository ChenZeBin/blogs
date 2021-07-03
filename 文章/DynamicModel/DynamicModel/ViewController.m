//
//  ViewController.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/7.
//

#import "ViewController.h"
#import "FourModel.h"
#import "AddMethodTestModel.h"
#import <objc/runtime.h>

@interface ViewController ()

@property (nonatomic, strong) NSString *MyString;
- (void)testNotFoundMethod1;
- (void)testNotFoundMethod2;
- (void)testNotFoundMethod3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FourModel *fourModel = [FourModel new];
    AddMethodTestModel *add = [AddMethodTestModel new];
 
    objc_property_t p = class_getProperty([self class], "myString");
    
    NSString *ivarName = @"MyString";
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:ivarName forKey:ivarName];
    NSLog(@"%lf",[[NSDate date] timeIntervalSince1970]);
    Class cls = [self class];
    for (NSInteger i = 0; i < 1000000; i++) {
        cls;
    }
    NSLog(@"%lf",[[NSDate date] timeIntervalSince1970]);

    
    NSLog(@"");
    
    
    CFMutableDictionaryRef myDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    NSString *key = @"someKey";
    NSNumber *value = [NSNumber numberWithInt: 1];
  
}







@end


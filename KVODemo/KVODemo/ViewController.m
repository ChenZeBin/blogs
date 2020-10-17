//
//  ViewController.m
//  KVODemo
//
//  Created by chenzebin on 2019/1/9.
//  Copyright © 2019年 陈泽槟. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/message.h>

@interface ViewController ()

/** person */
@property (nonatomic, strong) Person *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _person = [[Person alloc] init];
    
    // 1.kvo对属性的监听
    [_person addObserver:self forKeyPath:NSStringFromSelector(@selector(name)) options:NSKeyValueObservingOptionNew context:nil];
    // 2.kvo属性关联,这个我们是监听dog的变化，那如果是dog属性的变化，如果不做处理，是监听不到的
    [_person addObserver:self forKeyPath:NSStringFromSelector(@selector(dog)) options:NSKeyValueObservingOptionNew context:nil];
    // 3.容器监听
    [_person addObserver:self forKeyPath:NSStringFromSelector(@selector(mArr)) options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)test:(NSString *)a b:(NSString *)b c:(NSString *)c
{
    NSLog(@"%@%@%@",a,b,c);
}

- (void)test:(NSString *)a b:(NSString *)b
{
    
}

- (void)test:(NSString *)a
{
    
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    /*
//    typedef NS_ENUM(NSUInteger, NSKeyValueChange) {
//        NSKeyValueChangeSetting = 1, // set方法
//        NSKeyValueChangeInsertion = 2, // 容器插入
//        NSKeyValueChangeRemoval = 3, // 容器移除
//        NSKeyValueChangeReplacement = 4, // 容器替换
//    };
//     */
//
//    NSLog(@"%@",change);
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString *name = NSStringFromSelector(@selector(name));
    
    // 手动触发 这两个方法必须是成对的，然后回调observeValueForKeyPath方法，至于为什么成对呢，猜想应该是苹果做了处理，点进去官方的注释也有说明这两个方法必须成对存在
    // 如果想要手动触发需要在被监听类中实现+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key返回NO
    [_person willChangeValueForKey:name];
    [_person didChangeValueForKey:name];
    
    // kvc
    [_person setValue:@"123" forKey:name];
    
    // 容器
    NSMutableArray *arr1 = [_person mutableArrayValueForKey:NSStringFromSelector(@selector(mArr))];
    [arr1 addObject:@"123"];
    
    NSMutableArray *arr2 = [_person mutableArrayValueForKey:NSStringFromSelector(@selector(mArr))];
    [arr2 replaceObjectAtIndex:0 withObject:@"1234"];
    
    NSMutableArray *arr3 = [_person mutableArrayValueForKey:NSStringFromSelector(@selector(mArr))];
    [arr3 removeAllObjects];
    

    
    // 属性关联
    // 属性关联需要在被监听类中实现+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key
    _person.dog.name = @"myDog";
}

- (void)setPerson:(Person *)person
{
    _person = person;
}

- (void)dealloc
{
    // 移除懒得写了
//    _person removeObserver:self forKeyPath:<#(nonnull NSString *)#>
}


@end

//
//  NSObject+ZBKVO.m
//  KVODemo
//
//  Created by chenzebin on 2019/1/11.
//  Copyright © 2019年 陈泽槟. All rights reserved.
//

#import "NSObject+ZBKVO.h"
#import <objc/message.h>

@implementation NSObject (ZBKVO)

/** 注册 */
-(void)zb_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    
    /**
     * 定义NSKVONotifying_Person子类
     * 重写setName,在内部恢复父类做法
     * 修改当前对象的isa指针！指向NSKVONotifying_Person
     */
    
    
    /** 1.动态生成一个类 */
    /** 1.1 动态生成一个类名 */
    NSString *oldClassName = NSStringFromClass(self.class);
    NSString *newClassName = [@"HKKVO_" stringByAppendingString:oldClassName];
    
    /** 定义一个类，继承传进来的类 */
    Class MyClass = objc_allocateClassPair(self.class, newClassName.UTF8String, 0);
    
    /** 添加set方法 */
    class_addMethod(MyClass, @selector(setName:), (IMP)setName, "V@:@");
    
    
    /** 注册该类 */
    objc_registerClassPair(MyClass);
    
    /** 修改isa指针 */
    object_setClass(self, MyClass);
    
    /** 将观察者保存到当前对象 */
    objc_setAssociatedObject(self, @"objc", observer, OBJC_ASSOCIATION_ASSIGN);
    
}


/** set方法 */
void setName(id self,SEL _cmd,NSString * newName){
//    NSLog(@"来了！");
//    /** 保存当前类型 */
//    Class class = [self class];
//    /** 调用父类方法 */
//    object_setClass(self, class_getSuperclass(class));
//    objc_msgSend(self, @selector(setName:),newName);
//    /** 通知观察者 */
//    id observer = objc_getAssociatedObject(self, @"objc");
//    if (observer) {
//        objc_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:),@"name",self,@{@"new:":[self valueForKey:@"name"],@"kind:":@1},nil);
//    }
//    /** 改回子类 */
//    object_setClass(self, class);
//
    
}


@end

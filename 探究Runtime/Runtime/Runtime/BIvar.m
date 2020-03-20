//
//  BIvar.m
//  Runtime
//
//  Created by Corbin on 2019/12/3.
//  Copyright © 2019 ChenZeBin. All rights reserved.
//

#import "BIvar.h"
#import <objc/runtime.h>

@implementation BIvar

- (void)test
{
     //在运行时创建继承自NSObject的People类
     Class People = objc_allocateClassPair([NSObject class], "People", 0);
     //添加_name成员变量
     BOOL flag1 = class_addIvar(People, "_name", sizeof(NSString*), log2(sizeof(NSString*)), @encode(NSString*));
     if (flag1) {
         NSLog(@"NSString*类型  _name变量添加成功");
     }
     //添加_age成员变量
     BOOL flag2 = class_addIvar(People, "_age", sizeof(int), sizeof(int), @encode(int));
     if (flag2) {
         NSLog(@"int类型 _age变量添加成功");
     }
     //完成People类的创建
     objc_registerClassPair(People);
     unsigned int varCount;
     //拷贝People类中的成员变量列表
     Ivar * varList = class_copyIvarList(People, &varCount);
     for (int i = 0; i<varCount; i++) {
         NSLog(@"%s",ivar_getName(varList[i]));
     }
     //释放varList
     free(varList);
     //创建People对象p1
     id p1 = [[People alloc]init];
     //从类中获取成员变量Ivar
     Ivar nameIvar = class_getInstanceVariable(People, "_name");
     Ivar ageIvar = class_getInstanceVariable(People, "_age");
     //为p1的成员变量赋值
     object_setIvar(p1, nameIvar, @"张三");
     object_setIvar(p1, ageIvar, @33);
     //获取p1成员变量的值
     // object_getIvar返回成员变量的值，第一个参数是哪个对象的成员变量，第二个参数是这个成员变量的ivar
     NSLog(@"%@",object_getIvar(p1, nameIvar));
     NSLog(@"%@",object_getIvar(p1, ageIvar));


}

@end

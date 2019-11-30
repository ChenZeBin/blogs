//
//  main.m
//  OCDemo
//
//  Created by Corbin on 2019/11/26.
//  Copyright © 2019 ChenZeBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSObject *objc = [[NSObject alloc] init];
        
        // 获得 NSObject 实例对象的成员变量所占用的大小 >> 8
        NSLog(@"%zd", class_getInstanceSize([NSObject class])); // 输出为8

        // 获得 obj 指针所指向内存的大小 >> 16
        NSLog(@"%zd", malloc_size((__bridge const void *)(objc))); // 输出为 16
    }
    return 0;
}

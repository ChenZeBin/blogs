//
//  main.m
//  BlockDemo
//
//  Created by Corbin on 2019/11/24.
//  Copyright © 2019 ChenZeBin. All rights reserved.
//

#import <Foundation/Foundation.h>

int c = 10;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        __block int temp = 10;
        
        void (^block)(void) = ^{
            temp++;
            NSLog(@"%d", temp);
        };
        
        block();
        
        
        //  __block
        
        __block int aa = 10;
        
        void(^block1)(void) = ^{
            aa = 20;
            
            NSLog(@"%d",aa);
        };
        
        void(^block2)(void) = ^{
            aa = 30;
            
            NSLog(@"%d",aa);
        };
        
        block1();
        block2();
        
        return 0;
        
    }
    return 0;
}

//void captureBlock()
//{
//    __block int temp = 10;
//
//    NSLog(@"%@",^{
//        NSLog(@"*******%d %p",temp ++,&temp);
//
//    });
//
//
//    int a = 10;
//    void (^block)(void) = ^{
//
//        NSLog(@"Hello World!--%d", a);
//    };
//
//    block();
//
//    __block int aa = 10;
//    void (^blockaa)(void) = ^{
//
//        NSLog(@"Hello World!--%d", aa);
//    };
//
//    aa = 20;
//
//    blockaa();
//
//
//    NSLog(@"捕获局部的block%@\n %@\n %@\n %@", [block class], [[block class] superclass], [[[block class] superclass] superclass], [[[[block class] superclass] superclass] superclass]);
//
//    void (^block1)(void) = ^{
//        NSLog(@"aaa");
//    };
//
//    NSLog(@"啥都没有捕获的block:%@",[block1 class]);
//
//    static int b = 10;
//    void (^block2)(void) = ^{
//        NSLog(@"aaa:%d",b);
//    };
//
//    NSLog(@"捕获静态变量的block:%@",[block2 class]);
//
//
//    void (^block3)(void) = ^{
//        NSLog(@"捕获全局变量的block:%d",c);
//    };
//
//    NSLog(@"捕获全局变量的block:%@",[block3 class]);
//
//
//    NSLog(@"对__NSGlobalBlock__的block进行copy:%@",[[block3 copy] class]);
//
//    NSLog(@"对block__NSStackBlock__的block进行copy:%@",[[block copy] class]);
//}

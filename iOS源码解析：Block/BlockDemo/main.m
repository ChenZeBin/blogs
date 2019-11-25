//
//  main.m
//  BlockDemo
//
//  Created by Corbin on 2019/11/24.
//  Copyright © 2019 ChenZeBin. All rights reserved.
//

#import <Foundation/Foundation.h>


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        int a = 10;
        void (^block)(void) = ^{
            
            NSLog(@"Hello World!--%d", a);
        };
        
        block();
        
        
        NSLog(@"%@\n %@\n %@\n %@", [block class], [[block class] superclass], [[[block class] superclass] superclass], [[[[block class] superclass] superclass] superclass]);
            
        return 0;
        
    }
    return 0;
}

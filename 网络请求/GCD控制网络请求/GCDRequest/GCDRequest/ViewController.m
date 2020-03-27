//
//  ViewController.m
//  GCDRequest
//
//  Created by chenzebin on 2020/2/15.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface Person: NSObject
@end
@implementation Person
+ (void)printStatic{
}
- (void)print{
    NSLog(@"This object is %p.", self);
    NSLog(@"Class is %@, and super is %@.", [self class], [self superclass]);
    const char *name = object_getClassName(self);
    Class metaClass = objc_getMetaClass(name);
    NSLog(@"MetaClass is %p----%@",metaClass,metaClass);
    Class currentClass = [self class];
    for (int i = 1; i < 5; i++)
    {
        NSLog(@"Following the isa pointer %d times gives %p----%@", i, currentClass,currentClass);
            unsigned int countMethod = 0;
        NSLog(@"---------------**%d start**-----------------------",i);
        Method * methods = class_copyMethodList(currentClass, &countMethod);
        [self printMethod:countMethod methods:methods ];
        NSLog(@"---------------**%d end**-----------------------",i);
        currentClass = object_getClass(currentClass);
        NSLog(@"输出currentClass:%@",currentClass);
        
    }
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
}
- (void)printMethod:(int)count methods:(Method *) methods{
    for (int j = 0; j < count; j++) {
        Method method = methods[j];
        SEL methodSEL = method_getName(method);
        const char * selName = sel_getName(methodSEL);
        if (methodSEL) {
            NSLog(@"sel------%s", selName);
        }
    }
}
@end
@interface Animal: NSObject
@end
@implementation Animal
- (void)print{
    NSLog(@"This object is %p.", self);
    NSLog(@"Class is %@, and super is %@.", [self class], [self superclass]);
    const char *name = object_getClassName(self);
    Class metaClass = objc_getMetaClass(name);
    NSLog(@"MetaClass is %p",metaClass);
    Class currentClass = [self class];
    for (int i = 1; i < 5; i++)
    {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = object_getClass(currentClass);
    }
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
}
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self group1Use];
//    [self group2Use];
//    [self group3Use];
    [self group4Use];
}

- (void)group1Use
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务一完成");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务二完成");
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"都完成了");
    });
}

- (void)group2Use
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            NSLog(@"任务一完成");
        });
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            NSLog(@"任务二完成");
        });
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"都完成了");
    });
}

- (void)group3Use
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"任务一完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"任务二完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"都完成了");
    });
}

- (void)group4Use
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    // 注意，故意将这个任务一的延迟时间调成4s，比任务二多2s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"任务一完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"任务二完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"都完成了");
    });
}


@end


























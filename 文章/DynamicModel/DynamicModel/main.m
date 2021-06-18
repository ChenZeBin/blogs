//
//  main.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/7.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


typedef struct {
    int refcount;
    int val;
} mystruct;

//const void *myretain(CFAllocatorRef allocator, const void *value)
//{
//    [value retain]
//}
//
//void myrelease(CFAllocatorRef allocator, const void *value)
//{
//    mystruct *p = (mystruct *)value;
//    if (p->refcount == 1)
//     free(p);
//    else
//     p->refcount--;
//}

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        CGSize pp = {10,10};
//        mystruct *p = malloc(sizeof(*p));
//        p->refcount = 1;
//        p->val = 13;

//        CFDictionaryValueCallBacks vcb = { 0 , myretain, myrelease, NULL, NULL };
        CFDictionaryValueCallBacks valueCallbacks = {0};
        CFMutableDictionaryRef dict = CFDictionaryCreateMutable(NULL, 0, &kCFCopyStringDictionaryKeyCallBacks, &valueCallbacks);

        int sd = 13;
        CFNumberRef key = CFNumberCreate(NULL, kCFNumberIntType, &sd);

        CFDictionarySetValue(dict, key, &pp);
        // refcount == 2
//        myrelease(NULL, &pp);
        // refcount == 1

        CGSize *q = CFDictionaryGetValue(dict, key);
        // refcount is still 1, "GetValue" does not increment the refcount

        CFRelease(dict);
        // object is deallocated
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

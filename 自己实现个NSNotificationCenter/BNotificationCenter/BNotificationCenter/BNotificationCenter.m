//
//  BNotificationCenter.m
//  BDelegateObserver
//
//  Created by chenzebin on 2020/3/22.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "BNotificationCenter.h"

static BNotificationCenter *center = nil;
static const NSUInteger kBNotificationParamIndex = 2;
static NSString * const kSelectorParamFlag = @":";

typedef NSHashTable<BNotificationCenterModel *> BNotificationHash;

@interface BNotificationCenter()

@property (nonatomic, strong) NSMapTable<NSString *, BNotificationHash *> *dict;
@property (nonatomic, strong) BNotificationHash *weakHash;

@end


@implementation BNotificationCenter

+ (instancetype)defaultCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[BNotificationCenter alloc] init];
        center.dict = [NSMapTable strongToStrongObjectsMapTable];
        center.weakHash = [BNotificationHash weakObjectsHashTable];
    });
    
    return center;
}

#pragma mark - Public
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable BNotificationName)aName object:(nullable id)anObject
{
    BNotificationHash *set = [self.dict objectForKey:aName];
    
    if (!set) { set = [[BNotificationHash alloc] init]; }
    
    BNotificationCenterModel *model = [BNotificationCenterModel modelWithObserver:observer selector:aSelector name:aName object:anObject];
    
    [set addObject:model];
    
    [self.dict setObject:set forKey:aName];
}

- (void)postNotificationName:(BNotificationName)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo
{
    if (!anObject) {
        [self postNotificationName:aName userInfo:aUserInfo];
    } else {
        [self postNotificationName:aName anObject:anObject userInfo:aUserInfo];
    }
}

#pragma mark - Private
- (void)postNotificationName:(BNotificationName _Nonnull)aName userInfo:(nullable NSDictionary *)aUserInfo
{
    BNotificationHash *hash = [self.dict objectForKey:aName];
    
    NSEnumerator<BNotificationCenterModel *> *enumerator = [hash objectEnumerator];
    
    BNotificationCenterModel *objc = nil;
    
    while (objc = [enumerator nextObject]) {
        if (!objc.anObject) {
            [self invokeWithModel:objc userInfo:aUserInfo];
        }
    }
}

- (void)postNotificationName:(BNotificationName _Nonnull)aName anObject:(id _Nullable)anObject userInfo:(nullable NSDictionary *)aUserInfo
{
    BNotificationHash *hash = [self.dict valueForKey:aName];

    NSEnumerator<BNotificationCenterModel *> *enumerator = [hash objectEnumerator];
    
    BNotificationCenterModel *objc = nil;
    
    while (objc = [enumerator nextObject]) {
        if ([anObject isEqual:objc.anObject]) {
            [self invokeWithModel:objc userInfo:aUserInfo];
        }
    }
}

- (void)invokeWithModel:(BNotificationCenterModel *)model userInfo:(nullable NSDictionary *)aUserInfo
{
    if ([BNotificationCenterHelper hasParamWithSelector:model.aSelector]) {
        [model updateUserinfo:aUserInfo];
    }
    
    NSInvocation *inv = [BNotificationCenterHelper getInvocationWithModel:model];
    
    [inv invoke];
}

@end

@implementation BNotification
@synthesize object = _object;
@synthesize userInfo = _userInfo;

- (instancetype)initWithName:(NSNotificationName)name object:(nullable id)object userInfo:(nullable NSDictionary *)userInfo
{
    if (self = [super init]) {
        _name = name;
        _object = object;
        _userInfo = userInfo;
    }
    
    return self;
}

- (void)updateUserinfo:(id)userinfo
{
    _userInfo = userinfo;
}

@end

@implementation BNotificationCenterModel
@synthesize observer = _observer;
@synthesize aName = _aName;
@synthesize aSelector = _aSelector;
@synthesize anObject = _anObject;
@synthesize aUserInfo = _aUserInfo;
@synthesize notification = _notification;

+ (instancetype)modelWithObserver:(id)observer selector:(SEL)aSelector name:(BNotificationName)aName object:(nullable id)anObject
{
    BNotificationCenterModel *model = [[BNotificationCenterModel alloc] initWithObserver:observer selector:aSelector name:aName object:anObject];

    return model;
}

- (instancetype)initWithObserver:(id)observer selector:(SEL)aSelector name:(BNotificationName)aName object:(nullable id)anObject
{
    if (self = [super init]) {
        _observer = observer;
        _aSelector = aSelector;
        _aName = aName;
        _anObject = anObject;
        _notification = [[BNotification alloc] initWithName:aName object:anObject userInfo:nil];
    }
    
    return self;
}

- (void)updateUserinfo:(id)userinfo
{
    _aUserInfo = userinfo;
    [self.notification updateUserinfo:userinfo];
}

@end

@implementation BNotificationCenterHelper

+ (NSInvocation *)getInvocationWithModel:(BNotificationCenterModel *)model
{
    id observer = model.observer;
    SEL selector = model.aSelector;
    
    NSInvocation *inv = [NSInvocation b_invocationWithObserver:observer selector:selector];
    
    NSDictionary *dict = model.aUserInfo;
        
    if (dict) {
        BNotification *noti = model.notification;
        [inv setArgument:&noti atIndex:kBNotificationParamIndex];
    }
    
    return inv;
}

+ (BOOL)hasParamWithSelector:(SEL)sel
{
    NSString *str = NSStringFromSelector(sel);
    
    return [str containsString:kSelectorParamFlag];
}

@end

@implementation NSInvocation (BNotificationCenter)

+ (NSInvocation *)b_invocationWithObserver:(id)observer selector:(SEL)aSelector
{
    NSMethodSignature *sign = [[observer class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sign];
    [inv setTarget:observer];
    [inv setSelector:aSelector];
    
    return inv;
}

@end

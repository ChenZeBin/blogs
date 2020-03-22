//
//  BNotificationCenter.h
//  BDelegateObserver
//
//  Created by chenzebin on 2020/3/22.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSNotificationName BNotificationName;

@interface BNotificationCenter : NSObject

+ (instancetype)defaultCenter;

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable BNotificationName)aName object:(nullable id)anObject;

- (void)postNotificationName:(BNotificationName)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;

@end

@interface BNotification : NSObject

- (instancetype)initWithName:(NSNotificationName)name object:(nullable id)object userInfo:(nullable NSDictionary *)userInfo;
- (void)updateUserinfo:(id)userinfo;

@property (readonly, copy, readonly) NSNotificationName name;
@property (nullable, retain, readonly) id object;
@property (nullable, copy, readonly) NSDictionary *userInfo;

@end

#pragma mark - 不对外部公开的类
@interface BNotificationCenterModel : NSObject

+ (instancetype)modelWithObserver:(id)observer selector:(SEL)aSelector name:(BNotificationName)aName object:(nullable id)anObject;
- (void)updateUserinfo:(id)userinfo;

@property (nonatomic, weak, readonly) id observer;
@property (nonatomic, copy, readonly) BNotificationName aName;
@property (nonatomic, assign, readonly) SEL aSelector;
@property (nonatomic, strong, readonly) id anObject;
@property (nonatomic, strong, readonly) NSDictionary *aUserInfo;

@property (nonatomic, strong, readonly) BNotification *notification;

@end

@interface BNotificationCenterHelper : NSObject

+ (NSInvocation *)getInvocationWithModel:(BNotificationCenterModel *)model;
+ (BOOL)hasParamWithSelector:(SEL)sel;

@end

@interface NSInvocation (BNotificationCenter)

+ (NSInvocation *)b_invocationWithObserver:(id)observer selector:(SEL)aSelector;

@end


NS_ASSUME_NONNULL_END

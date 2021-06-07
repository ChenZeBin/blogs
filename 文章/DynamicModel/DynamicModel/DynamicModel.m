//
//  DynamicModel.m
//  DynamicModel
//
//  Created by ChenZeBin on 2021/6/7.
//

#import "DynamicModel.h"
#import <objc/runtime.h>

static const int kIESLiveSetMethodLenNotIncloudIvarName = 4;
static const int kIESLiveSetMethodLen = 3;
static const void *kPropertiesListKey = nil;

#define IESLiveCacheBasicDataTypeIVar cacheBasicDataTypeIVar(self, _cmd, @(number))
#define IESLiveGetCacheBasicDataTypeIVar getCacheBasicDataTypeIVar(self, _cmd)
#define IESLiveAddMethod(impl) addMethod(mSelf,selector,@selector(impl))

/// 获取属性列表
static inline NSDictionary *getPropertiesList(Class cls)
{
    // 先直接读缓存
    NSDictionary *propertiesDic = objc_getAssociatedObject(cls, &kPropertiesListKey);
    
    if(propertiesDic == nil) {
        NSMutableDictionary *dicTemp = [NSMutableDictionary new];
        while (![NSStringFromClass(cls) isEqualToString:NSStringFromClass([DynamicModel class])]) {
            unsigned int count;
            objc_property_t *properties = class_copyPropertyList(cls, &count);
            for (int i = 0; i < count; i++) {
                objc_property_t property = properties[i];
                const char *pro = property_getAttributes(property);
                const char *cName = property_getName(property);
                NSString *key = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];;
                NSString *value = [NSString stringWithCString:pro encoding:NSUTF8StringEncoding];;
                [dicTemp setValue:value forKey:key];
            }
            free(properties);
            cls = [cls superclass];
        }
        propertiesDic = [dicTemp copy];
        
        // 提升效率
        objc_setAssociatedObject(cls, &kPropertiesListKey, propertiesDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return propertiesDic;
}

/// 获取属性名
static inline NSString *getPropertyName(DynamicModel *mSelf, SEL selector)
{
    const char *cSelStr = sel_getName(selector);
    size_t cSelStrLen = strlen(cSelStr);
    char *cPropertyNameCapital = (char *)malloc((cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1)*sizeof(char));
    memset(cPropertyNameCapital, '\0', cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName +1);
    strncpy(cPropertyNameCapital, cSelStr + kIESLiveSetMethodLen, cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName);
    NSString *propertyNameCapital = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
    cPropertyNameCapital[0] = tolower(cPropertyNameCapital[0]);
    NSString *propertyName = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
    NSDictionary *propertyDic = getPropertiesList([mSelf class]);
    free(cPropertyNameCapital);
    if (propertyDic[propertyName]) {
        return propertyName;
    } else if (propertyDic[propertyNameCapital]) { // 属性名首字母是大写，则命中这个分支逻辑
        return propertyNameCapital;
    }
    return nil;
}

/// 缓存基础数据类型的值
static inline void cacheBasicDataTypeIVar(DynamicModel *mSelf, SEL selector, NSNumber * value)
{
    NSString *ivarName = getPropertyName(mSelf, selector);
    // 使用一个全局的map来存objc_setAssociatedObject的key(地址)
    [mSelf.propertyNamePtrMap setObject:ivarName forKey:ivarName];
    objc_setAssociatedObject(mSelf,(__bridge const void * _Nonnull)(ivarName),value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSLog(@"czb__cache_name:%p,value:%@",(__bridge const void * _Nonnull)(ivarName),value);
}

/// 从缓存中获取基础数据类型的值
static inline NSNumber * getCacheBasicDataTypeIVar(DynamicModel *mSelf, SEL selector)
{
    NSString *ivarName = mSelf.propertyNamePtrMap[NSStringFromSelector(selector)];
    NSNumber *value = objc_getAssociatedObject(mSelf, (__bridge const void * _Nonnull)(ivarName));
    NSLog(@"czb__get_name:%p,value:%@",(__bridge const void * _Nonnull)(ivarName),value);
    return value;
}

static inline void addMethod(Class cls,SEL originSelector,SEL implSelector)
{
    class_addMethod(cls,originSelector,class_getMethodImplementation(cls,implSelector),method_getTypeEncoding(class_getInstanceMethod(cls, implSelector)));
}

@implementation DynamicModel

- (instancetype)init
{
    if (self = [super init]) {
        _propertyNamePtrMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

static BOOL resolveInstanceMethod(DynamicModel *mSelf, SEL selector)
{
    NSDictionary *propertyDic = getPropertiesList(DynamicModel);
    const char *cSelStr = sel_getName(selector);
    size_t cSelStrLen = strlen(cSelStr);
    BOOL isSetMethod = false;
    if (cSelStrLen > kIESLiveSetMethodLenNotIncloudIvarName && cSelStr[0] == 's' &&  cSelStr[1] == 'e' && cSelStr[2] == 't' ) {
        isSetMethod = true;
    }
    if (isSetMethod) {
        // 获取去掉set字符的字符串，例如"SetAry:"，cPropertyNameCapital=="Ary"
        char *cPropertyNameCapital = (char *)malloc((cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1)*sizeof(char));
        memset(cPropertyNameCapital, '\0', cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1);
        strncpy(cPropertyNameCapital, cSelStr + kIESLiveSetMethodLen, cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName);
        NSString *propertyNameCapital = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
        // 将首字符变成小写，例如"Ary"->"ary"
        cPropertyNameCapital[0] = tolower(cPropertyNameCapital[0]);
        NSString *propertyName = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
        free(cPropertyNameCapital);
        // 用"ary"取下，如果取不到，用"Ary"再尝试取下看看
        NSString *propertyAttributes = propertyDic[propertyName] ? : propertyDic[propertyNameCapital];
        const char *cPropertyAttributes = [propertyAttributes cStringUsingEncoding:NSUTF8StringEncoding];
        if (propertyAttributes == nil) {
            return NO;
        } else {
            // cPropertyAttributes中搜索是否有"@"
            if(strstr(cPropertyAttributes,"@")){
                IESLiveAddMethod(dynamicSet:);
            } else {
                if (cPropertyAttributes[1] == 'i'|| cPropertyAttributes[1] == 'l') {
                    IESLiveAddMethod(dynamicSetSInt32:);
                } else if (cPropertyAttributes[1] == 'B'|| cPropertyAttributes[1] == 'c') {
                    IESLiveAddMethod(dynamicSetBool:);
                } else if (cPropertyAttributes[1] == 'q') {
                    IESLiveAddMethod(dynamicSetSInt64:);
                } else if (cPropertyAttributes[1] == 'd') {
                    IESLiveAddMethod(dynamicSetDouble:);
                } else if (cPropertyAttributes[1] == 'f') {
                    IESLiveAddMethod(dynamicSetFloat:);
                } else {
                    return NO;
                }
            }
            return YES;
        }
    } else {
        NSString *selStr = NSStringFromSelector(selector);
        NSString *propertyAttributes = propertyDic[selStr];
        const char *cPropertyAttributes = [propertyAttributes cStringUsingEncoding:NSUTF8StringEncoding];
        if (propertyAttributes == nil) {
            return NO;
        } else {
            if (strstr(cPropertyAttributes,"@")) {
                IESLiveAddMethod(dynamicGet);
            } else {
                if (cPropertyAttributes[1] == 'i'|| cPropertyAttributes[1] == 'l') {
                    IESLiveAddMethod(dynamicGetSInt32);
                } else if (cPropertyAttributes[1] == 'B'|| cPropertyAttributes[1] == 'c') {
                    IESLiveAddMethod(dynamicGetBool);
                } else if (cPropertyAttributes[1] == 'q') {
                    IESLiveAddMethod(dynamicGetSInt64);
                } else if (cPropertyAttributes[1] == 'd') {
                    IESLiveAddMethod(dynamicGetDouble);
                } else if (cPropertyAttributes[1] == 'f') {
                    IESLiveAddMethod(dynamicGetFloat);
                } else {
                    return NO;
                }
            }
            return YES;
        }
    }
}

+ (BOOL)resolveInstanceMethod:(SEL)selector
{
    resolveInstanceMethod(selector);
}

- (void)dynamicSet:(id)str
{
    const char *cSelStr = sel_getName(_cmd);
    size_t cSelStrLen = strlen(cSelStr);
    char *cPropertyNameCapital = (char *)malloc((cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1)*sizeof(char));
    memset(cPropertyNameCapital, '\0', cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1);
    strncpy(cPropertyNameCapital, cSelStr + kIESLiveSetMethodLen, cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName);
    NSString *propertyNameCapital = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
    cPropertyNameCapital[0] = tolower(cPropertyNameCapital[0]);
    NSString *propertyName = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
    NSDictionary *propertyDic = getPropertiesList([self class]);
    NSString *propertyAttributes = propertyDic[propertyName] ? : propertyDic[propertyNameCapital];
    const char *cPropertyAttributes = [propertyAttributes cStringUsingEncoding:NSUTF8StringEncoding];
    if (propertyAttributes == nil) {
        return;
    }
    size_t propertyLen =  strlen(cPropertyAttributes);
    objc_AssociationPolicy pro = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
    for(int i = 0; i < propertyLen; i++) {
        while (i < propertyLen ) {
            if(cPropertyAttributes[i] == ','){
                i++;
                break;
            }
            i++;
        }
        if (cPropertyAttributes[i] == 'C') {
            pro = OBJC_ASSOCIATION_COPY_NONATOMIC;
            break;
        }
    }
    objc_setAssociatedObject(self, NSSelectorFromString(propertyDic[propertyName] ? propertyName : propertyNameCapital), str, pro);
    free(cPropertyNameCapital);
}

- (id)dynamicGet
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)dynamicSetSInt32:(SInt32)number
{
    IESLiveCacheBasicDataTypeIVar;
}

- (SInt32)dynamicGetSInt32
{
    return [IESLiveGetCacheBasicDataTypeIVar intValue];
}

- (void)dynamicSetBool:(BOOL)number
{
    IESLiveCacheBasicDataTypeIVar;
}

- (BOOL)dynamicGetBool
{
    return [IESLiveGetCacheBasicDataTypeIVar boolValue];
}

- (void)dynamicSetSInt64:(SInt64)number
{
    IESLiveCacheBasicDataTypeIVar;
}

- (SInt64)dynamicGetSInt64
{
    return [IESLiveGetCacheBasicDataTypeIVar integerValue];
}

- (void)dynamicSetDouble:(double)number
{
    IESLiveCacheBasicDataTypeIVar;
}

- (double)dynamicGetDouble
{
    return [IESLiveGetCacheBasicDataTypeIVar doubleValue];
}

- (void)dynamicSetFloat:(Float32)number
{
    IESLiveCacheBasicDataTypeIVar;
}

- (Float32)dynamicGetFloat
{
    return [IESLiveGetCacheBasicDataTypeIVar floatValue];
}

@end


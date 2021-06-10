//
//  IESLiveDynamicModelUtil.h
//  DynamicModel
//
//  Created by bytedance on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@protocol IESLiveDynamicModel <NSObject>

@property (nonatomic, strong) NSMutableDictionary *DynamicModel_propertyNamePtrMap;

@end

FOUNDATION_EXTERN const int kIESLiveSetMethodLenNotIncloudIvarName;
FOUNDATION_EXTERN const int kIESLiveSetMethodLen;
FOUNDATION_EXTERN void * const kPropertiesListKey;

#define IESLiveCacheBasicDataTypeIVar(BaseCls) cacheBasicDataTypeIVar(self,BaseCls, _cmd, @(number))
#define IESLiveGetCacheBasicDataTypeIVar getCacheBasicDataTypeIVar(self, _cmd)
#define IESLiveAddMethod(impl) class_addMethod(self,selector,class_getMethodImplementation(self,@selector(impl)),method_getTypeEncoding(class_getInstanceMethod(self, @selector(impl))));



/// 获取属性列表
FOUNDATION_EXPORT NSDictionary *getPropertiesList(Class cls, Class BaseCls);
/// 获取属性名
FOUNDATION_EXPORT NSString *getPropertyName(id<IESLiveDynamicModel> mSelf,Class baseCls, SEL selector);
/// 缓存基础数据类型的值
FOUNDATION_EXPORT void cacheBasicDataTypeIVar(id<IESLiveDynamicModel> mSelf,Class baseCls, SEL selector, NSNumber * value);
/// 从缓存中获取基础数据类型的值
FOUNDATION_EXPORT NSNumber * getCacheBasicDataTypeIVar(id<IESLiveDynamicModel> mSelf, SEL selector);

/// 声明类
#define IESLiveDefineDynamicModelClass(ClassName, InheritClass) \
\
@interface ClassName : InheritClass<IESLiveDynamicModel>\
\
@end\

/// 实现类
#define IESLiveImplDynamicModelClass(ClassName) \
\
@implementation ClassName\
@synthesize DynamicModel_propertyNamePtrMap;\
\
- (instancetype)init\
{\
    if (self = [super init]) {\
        self.DynamicModel_propertyNamePtrMap = [NSMutableDictionary dictionary];\
    }\
    \
    return self;\
}\
\
+ (BOOL)resolveInstanceMethod:(SEL)selector\
{\
    NSDictionary *propertyDic = getPropertiesList([self class],[ClassName class]);\
    const char *cSelStr = sel_getName(selector);\
    size_t cSelStrLen = strlen(cSelStr);\
    BOOL isSetMethod = false;\
    if (cSelStrLen > kIESLiveSetMethodLenNotIncloudIvarName && cSelStr[0] == 's' &&  cSelStr[1] == 'e' && cSelStr[2] == 't' ) {\
        isSetMethod = true;\
    }\
    if (isSetMethod) {\
        char *cPropertyNameCapital = (char *)malloc((cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1)*sizeof(char));\
        memset(cPropertyNameCapital, '\0', cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1);\
        strncpy(cPropertyNameCapital, cSelStr + kIESLiveSetMethodLen, cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName);\
        NSString *propertyNameCapital = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];\
        cPropertyNameCapital[0] = tolower(cPropertyNameCapital[0]);\
        NSString *propertyName = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];\
        free(cPropertyNameCapital);\
        NSString *propertyAttributes = propertyDic[propertyName] ? : propertyDic[propertyNameCapital];\
        const char *cPropertyAttributes = [propertyAttributes cStringUsingEncoding:NSUTF8StringEncoding];\
        if (propertyAttributes == nil) {\
            return NO;\
        } else {\
            if(strstr(cPropertyAttributes,"@")){\
                IESLiveAddMethod(dynamicSet:);\
            } else {\
                if (cPropertyAttributes[1] == 'i'|| cPropertyAttributes[1] == 'l') {\
                    IESLiveAddMethod(dynamicSetSInt32:);\
                } else if (cPropertyAttributes[1] == 'B'|| cPropertyAttributes[1] == 'c') {\
                    IESLiveAddMethod(dynamicSetBool:);\
                } else if (cPropertyAttributes[1] == 'q') {\
                    IESLiveAddMethod(dynamicSetSInt64:);\
                } else if (cPropertyAttributes[1] == 'd') {\
                    IESLiveAddMethod(dynamicSetDouble:);\
                } else if (cPropertyAttributes[1] == 'f') {\
                    IESLiveAddMethod(dynamicSetFloat:);\
                } else {\
                    return NO;\
                }\
            }\
            return YES;\
        }\
    } else {\
        NSString *selStr = NSStringFromSelector(selector);\
        NSString *propertyAttributes = propertyDic[selStr];\
        const char *cPropertyAttributes = [propertyAttributes cStringUsingEncoding:NSUTF8StringEncoding];\
        if (propertyAttributes == nil) {\
            return NO;\
        } else {\
            if (strstr(cPropertyAttributes,"@")) {\
                IESLiveAddMethod(dynamicGet);\
            } else {\
                if (cPropertyAttributes[1] == 'i'|| cPropertyAttributes[1] == 'l') {\
                    IESLiveAddMethod(dynamicGetSInt32);\
                } else if (cPropertyAttributes[1] == 'B'|| cPropertyAttributes[1] == 'c') {\
                    IESLiveAddMethod(dynamicGetBool);\
                } else if (cPropertyAttributes[1] == 'q') {\
                    IESLiveAddMethod(dynamicGetSInt64);\
                } else if (cPropertyAttributes[1] == 'd') {\
                    IESLiveAddMethod(dynamicGetDouble);\
                } else if (cPropertyAttributes[1] == 'f') {\
                    IESLiveAddMethod(dynamicGetFloat);\
                } else {\
                    return NO;\
                }\
            }\
            return YES;\
        }\
    }\
}\
\
- (void)dynamicSet:(id)str\
{\
    const char *cSelStr = sel_getName(_cmd);\
    size_t cSelStrLen = strlen(cSelStr);\
    char *cPropertyNameCapital = (char *)malloc((cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1)*sizeof(char));\
    memset(cPropertyNameCapital, '\0', cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1);\
    strncpy(cPropertyNameCapital, cSelStr + kIESLiveSetMethodLen, cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName);\
    NSString *propertyNameCapital = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];\
    cPropertyNameCapital[0] = tolower(cPropertyNameCapital[0]);\
    NSString *propertyName = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];\
    NSDictionary *propertyDic = getPropertiesList([self class], [ClassName class]);\
    NSString *propertyAttributes = propertyDic[propertyName] ? : propertyDic[propertyNameCapital];\
    const char *cPropertyAttributes = [propertyAttributes cStringUsingEncoding:NSUTF8StringEncoding];\
    if (propertyAttributes == nil) {\
        return;\
    }\
    size_t propertyLen =  strlen(cPropertyAttributes);\
    objc_AssociationPolicy pro = OBJC_ASSOCIATION_RETAIN_NONATOMIC;\
    for(int i = 0; i < propertyLen; i++) {\
        while (i < propertyLen ) {\
            if(cPropertyAttributes[i] == ','){\
                i++;\
                break;\
            }\
            i++;\
        }\
        if (cPropertyAttributes[i] == 'C') {\
            pro = OBJC_ASSOCIATION_COPY_NONATOMIC;\
            break;\
        }\
    }\
    objc_setAssociatedObject(self, NSSelectorFromString(propertyDic[propertyName] ? propertyName : propertyNameCapital), str, pro);\
    free(cPropertyNameCapital);\
}\
\
- (id)dynamicGet\
{\
    return objc_getAssociatedObject(self, _cmd);\
}\
\
- (void)dynamicSetSInt32:(SInt32)number\
{\
    IESLiveCacheBasicDataTypeIVar([ClassName class]);\
}\
\
- (SInt32)dynamicGetSInt32\
{\
    return [IESLiveGetCacheBasicDataTypeIVar intValue];\
}\
\
- (void)dynamicSetBool:(BOOL)number\
{\
    IESLiveCacheBasicDataTypeIVar([ClassName class]);\
}\
\
- (BOOL)dynamicGetBool\
{\
    return [IESLiveGetCacheBasicDataTypeIVar boolValue];\
}\
\
- (void)dynamicSetSInt64:(SInt64)number\
{\
    IESLiveCacheBasicDataTypeIVar([ClassName class]);\
}\
\
- (SInt64)dynamicGetSInt64\
{\
    return [IESLiveGetCacheBasicDataTypeIVar integerValue];\
}\
\
- (void)dynamicSetDouble:(double)number\
{\
    IESLiveCacheBasicDataTypeIVar([ClassName class]);\
}\
\
- (double)dynamicGetDouble\
{\
    return [IESLiveGetCacheBasicDataTypeIVar doubleValue];\
}\
\
- (void)dynamicSetFloat:(Float32)number\
{\
    IESLiveCacheBasicDataTypeIVar([ClassName class]);\
}\
\
- (Float32)dynamicGetFloat\
{\
    return [IESLiveGetCacheBasicDataTypeIVar floatValue];\
}\
\
@end





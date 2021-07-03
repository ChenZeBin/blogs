//
//  IESLiveDynamicModelUtil.h
//  DynamicModel
//
//  Created by ChenZeBin on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "IESLiveDynamicTypeCodeDefine.h"
#import <UIKit/UIKit.h>

#define IESLiveEqual(charRef) (cPropertyAttributes[1] == charRef[0])
#define IESLiveCacheBasicDataTypeIVar(BaseCls) cacheBasicDataTypeIVar(self,BaseCls, _cmd, @(number))
#define IESLiveAddMethod(impl) class_addMethod(self,selector,class_getMethodImplementation(self,@selector(impl)),method_getTypeEncoding(class_getInstanceMethod(self, @selector(impl))));

#define IESLiveDefineBaseDataDynamicGetterSetterMethod(type,decodeValue,className)\
- (void)dynamicSet##type:(type)number\
{\
    IESLiveCacheBasicDataTypeIVar([className class]);\
}\
- (type)dynamicGet##type\
{\
    return [objc_getAssociatedObject(self, _cmd) decodeValue];\
}

#define IESLiveDefineStructDynamicGetterSetterMethod(Type)\
- (void)dynamicSet##Type:(Type)val\
{\
    IESLiveSetStruct(Type)\
}\
- (Type)dynamicGet##Type\
{\
    IESLiveGetStruct(Type)\
}\

#define IESLiveSetStruct(type) \
NSValue *value = [NSValue valueWithBytes:&val objCType:@encode(type)];\
NSString *ivarName = getPropertyName(self, [NSObject class], _cmd);\
objc_setAssociatedObject(self,NSSelectorFromString(ivarName),value, OBJC_ASSOCIATION_ASSIGN);\

#define IESLiveGetStruct(type)\
NSValue *value = objc_getAssociatedObject(self, _cmd);\
type result;\
if (@available(iOS 11.0, *)) {\
    [value getValue:&result size:sizeof(type)];\
} else {\
    [value getValue:&result];\
}\
return result;
/// 获取属性的Attributes
FOUNDATION_EXPORT void getPropertyAttributes(const char *cSelStr, size_t cSelStrLen, NSDictionary *propertiesDic, NSString **propertyAttributes, NSString **propertyName);

/// 获取属性列表
FOUNDATION_EXPORT NSDictionary *getPropertiesList(Class cls, Class BaseCls);
/// 获取属性名
FOUNDATION_EXPORT NSString *getPropertyName(id mSelf,Class baseCls, SEL selector);
/// 缓存基础数据类型的值
FOUNDATION_EXPORT void cacheBasicDataTypeIVar(id mSelf,Class baseCls, SEL selector, NSNumber * value);

/// 声明类
#define _IESLiveDefineDynamicModelClass(ClassName, InheritClass) \
\
@interface ClassName : InheritClass\
\
@end\

/// 实现类
#define _IESLiveImplDynamicModelClass(ClassName) \
@implementation ClassName\
\
+ (BOOL)resolveInstanceMethod:(SEL)selector\
{\
    NSDictionary *propertiesDic = getPropertiesList([self class],[ClassName class]);\
    const char *cSelStr = sel_getName(selector);\
    size_t cSelStrLen = strlen(cSelStr);\
    BOOL isSetMethod = NO;\
    if (cSelStrLen > kIESLiveSetMethodLenNotIncloudIvarName && cSelStr[cSelStrLen-1] == ':' && cSelStr[0] == 's' &&  cSelStr[1] == 'e' && cSelStr[2] == 't') {\
        isSetMethod = YES;\
    }\
    \
    if (isSetMethod) {\
        NSString *propertyName;\
        NSString *propertyAttributes;\
        getPropertyAttributes(cSelStr, cSelStrLen, propertiesDic, &propertyAttributes, &propertyName);\
\
        if (propertyAttributes == nil) {\
            return [super resolveInstanceMethod:selector];\
        } else {\
            const char *cPropertyAttributes = [propertyAttributes cStringUsingEncoding:NSUTF8StringEncoding];\
\
            if (IESLiveEqual(kOCObjcCode)) {\
                IESLiveAddMethod(dynamicSet:);\
            } else if (IESLiveEqual(kPointRefCode) || IESLiveEqual(kCharRefCode) || IESLiveEqual(kClassCode)) {\
                IESLiveAddMethod(dynamicSetPtr:);\
            } else if (IESLiveEqual(kBoolCode)) {\
                IESLiveAddMethod(dynamicSetBOOL:);\
            } else if (IESLiveEqual(kCharCode)) {\
                IESLiveAddMethod(dynamicSetchar:);\
            } else if (IESLiveEqual(kUnsignedCharCode)) {\
                IESLiveAddMethod(dynamicSetuint8_t:)\
            } else if (IESLiveEqual(kShortCode)) {\
                IESLiveAddMethod(dynamicSetshort:);\
            } else if (IESLiveEqual(kUnsignedShortCode)) {\
                IESLiveAddMethod(dynamicSetushort:)\
            } else if (IESLiveEqual(kSInt32Code) || IESLiveEqual(k32LongCode)) {\
                IESLiveAddMethod(dynamicSetSInt32:);\
            } else if (IESLiveEqual(kUInt32Code) || IESLiveEqual(k32ULongCode)) {\
                IESLiveAddMethod(dynamicSetUInt32:)\
            } else if (IESLiveEqual(kSInt64Code)) {\
                IESLiveAddMethod(dynamicSetSInt64:);\
            } else if (IESLiveEqual(kUInt64Code)) {\
                IESLiveAddMethod(dynamicSetUInt64:);\
            } else if (IESLiveEqual(kFloatCode)) {\
                IESLiveAddMethod(dynamicSetFloat32:);\
            } else if (IESLiveEqual(kDoubleCode)) {\
                IESLiveAddMethod(dynamicSetdouble:);\
            } else if (IESLiveEqual(kCGRectCode)) {\
                IESLiveAddMethod(dynamicSetCGRect:);\
            } else if (IESLiveEqual(kCGPointCode)) {\
                IESLiveAddMethod(dynamicSetCGPoint:);\
            } else if (IESLiveEqual(kCGSizeCode)) {\
                IESLiveAddMethod(dynamicSetCGSize:);\
            } else if (IESLiveEqual(kUIEdgeInsetsCode)) {\
                IESLiveAddMethod(dynamicSetUIEdgeInsets:);\
            } else if (IESLiveEqual(kNSRangeCode)) {\
                IESLiveAddMethod(dynamicSetNSRange:);\
            }\
            else {\
                return [super resolveInstanceMethod:selector];\
            }\
            return YES;\
        }\
    } else {\
        NSString *selStr = NSStringFromSelector(selector);\
        NSString *propertyAttributes = propertiesDic[selStr];\
        const char *cPropertyAttributes = [propertyAttributes cStringUsingEncoding:NSUTF8StringEncoding];\
        if (propertyAttributes == nil) {\
            return [super resolveInstanceMethod:selector];\
        } else {\
            if(strstr(cPropertyAttributes,kOCObjcCode)){\
                IESLiveAddMethod(dynamicGet);\
            } else {\
                if (IESLiveEqual(kPointRefCode) || IESLiveEqual(kCharRefCode) || IESLiveEqual(kClassCode)) {\
                    IESLiveAddMethod(dynamicGetPtr);\
                } else if (IESLiveEqual(kBoolCode)) {\
                    IESLiveAddMethod(dynamicGetBOOL);\
                } else if (IESLiveEqual(kCharCode)) {\
                    IESLiveAddMethod(dynamicGetchar);\
                } else if (IESLiveEqual(kUnsignedCharCode)) {\
                    IESLiveAddMethod(dynamicGetuint8_t)\
                } else if (IESLiveEqual(kShortCode)) {\
                    IESLiveAddMethod(dynamicGetshort);\
                } else if (IESLiveEqual(kUnsignedShortCode)) {\
                    IESLiveAddMethod(dynamicGetushort)\
                } else if (IESLiveEqual(kSInt32Code) || IESLiveEqual(k32LongCode)) {\
                    IESLiveAddMethod(dynamicGetSInt32);\
                } else if (IESLiveEqual(kUInt32Code) || IESLiveEqual(k32ULongCode)) {\
                    IESLiveAddMethod(dynamicGetUInt32)\
                } else if (IESLiveEqual(kSInt64Code)) {\
                    IESLiveAddMethod(dynamicGetSInt64);\
                } else if (IESLiveEqual(kUInt64Code)) {\
                    IESLiveAddMethod(dynamicGetUInt64);\
                } else if (IESLiveEqual(kFloatCode)) {\
                    IESLiveAddMethod(dynamicGetFloat32);\
                } else if (IESLiveEqual(kDoubleCode)) {\
                    IESLiveAddMethod(dynamicGetdouble);\
                } else if (IESLiveEqual(kCGRectCode)) {\
                    IESLiveAddMethod(dynamicGetCGRect);\
                } else if (IESLiveEqual(kCGPointCode)) {\
                    IESLiveAddMethod(dynamicGetCGPoint);\
                } else if (IESLiveEqual(kCGSizeCode)) {\
                    IESLiveAddMethod(dynamicGetCGSize);\
                } else if (IESLiveEqual(kUIEdgeInsetsCode)) {\
                    IESLiveAddMethod(dynamicGetUIEdgeInsets);\
                } else if (IESLiveEqual(kNSRangeCode)) {\
                    IESLiveAddMethod(dynamicGetNSRange);\
                }\
                else {\
                    return [super resolveInstanceMethod:selector];\
                }\
            }\
            return YES;\
        }\
    }\
}\
\
- (void)dynamicSet:(id)str\
{\
    NSDictionary *propertiesDic = getPropertiesList([self class],[ClassName class]);\
    const char *cSelStr = sel_getName(_cmd);\
    size_t cSelStrLen = strlen(cSelStr);\
    \
    NSString * propertyName;\
    NSString * propertyAttributes;\
    getPropertyAttributes(cSelStr, cSelStrLen, propertiesDic, &propertyAttributes, &propertyName);\
\
    if (propertyAttributes == nil) {\
        return;\
    }\
    \
    const char *cPropertyAttributes = [propertyAttributes cStringUsingEncoding:NSUTF8StringEncoding];\
    \
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
        \
        if (cPropertyAttributes[i] == 'C') {\
            pro = OBJC_ASSOCIATION_COPY_NONATOMIC;\
            break;\
        } else {\
            NSArray *arr = [propertyAttributes componentsSeparatedByString:@","];\
            if (arr.count == 3) {\
                pro = OBJC_ASSOCIATION_ASSIGN;\
                break;\
            }\
        }\
    }\
    \
    objc_setAssociatedObject(self, NSSelectorFromString(propertyName), str, pro);\
}\
\
- (id)dynamicGet\
{\
    return objc_getAssociatedObject(self, _cmd);\
}\
\
- (void)dynamicSetPtr:(void *)ptr\
{\
    NSString *ivarName = getPropertyName(self, [NSObject class], _cmd);\
    NSValue *value = [NSValue valueWithPointer:ptr];\
    objc_setAssociatedObject(self,NSSelectorFromString(ivarName),value, OBJC_ASSOCIATION_ASSIGN);\
}\
\
- (void *)dynamicGetPtr\
{\
    NSValue *value = objc_getAssociatedObject(self, _cmd);\
    return value.pointerValue;\
}\
\
IESLiveDefineBaseDataDynamicGetterSetterMethod(char, charValue, ClassName)\
IESLiveDefineBaseDataDynamicGetterSetterMethod(uint8_t, unsignedCharValue, ClassName)\
IESLiveDefineBaseDataDynamicGetterSetterMethod(SInt32, intValue, ClassName)\
IESLiveDefineBaseDataDynamicGetterSetterMethod(UInt32, unsignedIntValue, ClassName)\
IESLiveDefineBaseDataDynamicGetterSetterMethod(short, shortValue, ClassName)\
IESLiveDefineBaseDataDynamicGetterSetterMethod(ushort, unsignedShortValue, ClassName)\
IESLiveDefineBaseDataDynamicGetterSetterMethod(BOOL, boolValue, ClassName)\
IESLiveDefineBaseDataDynamicGetterSetterMethod(SInt64, integerValue, ClassName)\
IESLiveDefineBaseDataDynamicGetterSetterMethod(UInt64, unsignedIntegerValue, ClassName)\
IESLiveDefineBaseDataDynamicGetterSetterMethod(double, doubleValue, ClassName)\
IESLiveDefineBaseDataDynamicGetterSetterMethod(Float32,floatValue,ClassName)\
IESLiveDefineStructDynamicGetterSetterMethod(CGRect)\
IESLiveDefineStructDynamicGetterSetterMethod(CGPoint)\
IESLiveDefineStructDynamicGetterSetterMethod(CGSize)\
IESLiveDefineStructDynamicGetterSetterMethod(UIEdgeInsets)\
IESLiveDefineStructDynamicGetterSetterMethod(NSRange)\
\
@end





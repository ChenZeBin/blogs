//
//  IESLiveDynamicModel.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/9.
//

#import "IESLiveDynamicModelDefine.h"
#import <UIKit/UIKit.h>

IESLiveImplDynamicModelClass(IESLiveDynamicModel)
IESLiveImplDynamicModelClass(IESLiveDynamicMTLModel)

//@implementation IESLiveDynamicModel
//@synthesize DynamicModel_propertyNamePtrMap;
//
//- (instancetype)init
//{
//    if (self = [super init]) {
//        self.DynamicModel_propertyNamePtrMap = [NSMutableDictionary dictionary];
//    }
//
//    return self;
//}
//
//+ (BOOL)resolveInstanceMethod:(SEL)selector
//{
//    NSDictionary *propertyDic = getPropertiesList([self class],[IESLiveDynamicModel class]);
//    const char *cSelStr = sel_getName(selector);
//    size_t cSelStrLen = strlen(cSelStr);
//    BOOL isSetMethod = false;
//    if (cSelStrLen > kIESLiveSetMethodLenNotIncloudIvarName && cSelStr[0] == 's' &&  cSelStr[1] == 'e' && cSelStr[2] == 't' ) {
//        isSetMethod = true;
//    }
//    if (isSetMethod) {
//        char *cPropertyNameCapital = (char *)malloc((cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1)*sizeof(char));
//        memset(cPropertyNameCapital, '\0', cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1);
//        strncpy(cPropertyNameCapital, cSelStr + kIESLiveSetMethodLen, cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName);
//        NSString *propertyNameCapital = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
//        cPropertyNameCapital[0] = tolower(cPropertyNameCapital[0]);
//        NSString *propertyName = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
//        free(cPropertyNameCapital);
//        NSString *propertyAttributes = propertyDic[propertyName] ? : propertyDic[propertyNameCapital];
//        const char *cPropertyAttributes = [propertyAttributes cStringUsingEncoding:NSUTF8StringEncoding];
//        if (propertyAttributes == nil) {
//            return [super resolveInstanceMethod:selector];
//        } else {
//            if(strstr(cPropertyAttributes,kOCObjcCode)){
//                IESLiveAddMethod(dynamicSet:);
//            } else {
//                if (IESLiveEqual(kPointRefCode) || IESLiveEqual(kCharRefCode) || IESLiveEqual(kClassCode)) {
//                    IESLiveAddMethod(dynamicSetPtr:);
//                } else if (IESLiveEqual(kBoolCode)) {
//                    IESLiveAddMethod(dynamicSetBool:);
//                } else if (IESLiveEqual(kCharCode)) {
//                    IESLiveAddMethod(dynamicSetChar:);
//                } else if (IESLiveEqual(kUnsignedCharCode)) {
//                    IESLiveAddMethod(dynamicSetUChar:)
//                } else if (IESLiveEqual(kShortCode)) {
//                    IESLiveAddMethod(dynamicSetShort:);
//                } else if (IESLiveEqual(kUnsignedShortCode)) {
//                    IESLiveAddMethod(dynamicSetUChar:)
//                } else if (IESLiveEqual(kSInt32Code) || IESLiveEqual(k32LongCode)) {
//                    IESLiveAddMethod(dynamicSetSInt32:);
//                } else if (IESLiveEqual(kUInt32Code) || IESLiveEqual(k32ULongCode)) {
//                    IESLiveAddMethod(dynamicSetUInt32:)
//                } else if (IESLiveEqual(kSInt64Code)) {
//                    IESLiveAddMethod(dynamicSetSInt64:);
//                } else if (IESLiveEqual(kUInt64Code)) {
//                    IESLiveAddMethod(dynamicSetUInt64:);
//                } else if (IESLiveEqual(kFloatCode)) {
//                    IESLiveAddMethod(dynamicSetFloat:);
//                } else if (IESLiveEqual(kDoubleCode)) {
//                    IESLiveAddMethod(dynamicSetDouble:);
//                } else {
//                    return [super resolveInstanceMethod:selector];
//                }
//            }
//            return YES;
//        }
//    } else {
//        NSString *selStr = NSStringFromSelector(selector);
//        NSString *propertyAttributes = propertyDic[selStr];
//        const char *cPropertyAttributes = [propertyAttributes cStringUsingEncoding:NSUTF8StringEncoding];
//        if (propertyAttributes == nil) {
//            return [super resolveInstanceMethod:selector];
//        } else {
//            if(strstr(cPropertyAttributes,kOCObjcCode)){
//                IESLiveAddMethod(dynamicGet);
//            } else {
//                if (IESLiveEqual(kPointRefCode) || IESLiveEqual(kCharRefCode) || IESLiveEqual(kClassCode)) {
//                    IESLiveAddMethod(dynamicGetPtr);
//                } else if (IESLiveEqual(kBoolCode)) {
//                    IESLiveAddMethod(dynamicGetBool);
//                } else if (IESLiveEqual(kCharCode)) {
//                    IESLiveAddMethod(dynamicGetChar);
//                } else if (IESLiveEqual(kUnsignedCharCode)) {
//                    IESLiveAddMethod(dynamicGetUChar)
//                } else if (IESLiveEqual(kShortCode)) {
//                    IESLiveAddMethod(dynamicGetShort);
//                } else if (IESLiveEqual(kUnsignedShortCode)) {
//                    IESLiveAddMethod(dynamicGetUChar)
//                } else if (IESLiveEqual(kSInt32Code) || IESLiveEqual(k32LongCode)) {
//                    IESLiveAddMethod(dynamicGetSInt32);
//                } else if (IESLiveEqual(kUInt32Code) || IESLiveEqual(k32ULongCode)) {
//                    IESLiveAddMethod(dynamicGetUInt32)
//                } else if (IESLiveEqual(kSInt64Code)) {
//                    IESLiveAddMethod(dynamicGetSInt64);
//                } else if (IESLiveEqual(kUInt64Code)) {
//                    IESLiveAddMethod(dynamicGetUInt64);
//                } else if (IESLiveEqual(kFloatCode)) {
//                    IESLiveAddMethod(dynamicGetFloat);
//                } else if (IESLiveEqual(kDoubleCode)) {
//                    IESLiveAddMethod(dynamicGetDouble);
//                } else {
//                    return [super resolveInstanceMethod:selector];
//                }
//            }
//            return YES;
//        }
//    }
//}
//
//
//+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
//{
//
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
//
//    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
//
//    //match: 所有匹配到的字符,根据() 包含级
//
//    NSMutableArray *array = [NSMutableArray array];
//
//    for (NSTextCheckingResult *match in matches) {
//
//        for (int i = 0; i < [match numberOfRanges]; i++) {
//            //以正则中的(),划分成不同的匹配部分
//            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
//
//            [array addObject:component];
//
//        }
//
//    }
//
//    return array;
//}
//
//- (void)dynamicSet:(id)str
//{
//    const char *cSelStr = sel_getName(_cmd);
//    size_t cSelStrLen = strlen(cSelStr);
//    char *cPropertyNameCapital = (char *)malloc((cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1)*sizeof(char));
//    memset(cPropertyNameCapital, '\0', cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1);
//    strncpy(cPropertyNameCapital, cSelStr + kIESLiveSetMethodLen, cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName);
//    NSString *propertyNameCapital = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
//    cPropertyNameCapital[0] = tolower(cPropertyNameCapital[0]);
//    NSString *propertyName = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
//    NSDictionary *propertyDic = getPropertiesList([self class], [IESLiveDynamicModel class]);
//    NSString *propertyAttributes = propertyDic[propertyName] ? : propertyDic[propertyNameCapital];
//    const char *cPropertyAttributes = [propertyAttributes cStringUsingEncoding:NSUTF8StringEncoding];
//    if (propertyAttributes == nil) {
//        return;
//    }
//    size_t propertyLen =  strlen(cPropertyAttributes);
//    objc_AssociationPolicy pro = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
//    for(int i = 0; i < propertyLen; i++) {
//        while (i < propertyLen ) {
//            if(cPropertyAttributes[i] == ','){
//                i++;
//                break;
//            }
//            i++;
//        }
//        if (cPropertyAttributes[i] == 'C') {
//            pro = OBJC_ASSOCIATION_COPY_NONATOMIC;
//            break;
//        }
//    }
//    objc_setAssociatedObject(self, NSSelectorFromString(propertyDic[propertyName] ? propertyName : propertyNameCapital), str, pro);
//    free(cPropertyNameCapital);
//}
//
//- (id)dynamicGet
//{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)dynamicSetChar:(char)number
//{
//    IESLiveCacheBasicDataTypeIVar([IESLiveDynamicModel class]);
//}
//
//- (char)dynamicGetChar
//{
//    return [IESLiveGetCacheBasicDataTypeIVar charValue];
//}
//
//
//- (void)dynamicSetUChar:(unsigned char)number
//{
//    IESLiveCacheBasicDataTypeIVar([IESLiveDynamicModel class]);
//}
//
//- (char)dynamicGetUChar
//{
//    return [IESLiveGetCacheBasicDataTypeIVar unsignedCharValue];
//}
//
//- (void)dynamicSetSInt32:(SInt32)number
//{
//    IESLiveCacheBasicDataTypeIVar([IESLiveDynamicModel class]);
//}
//
//- (SInt32)dynamicGetSInt32
//{
//    return [IESLiveGetCacheBasicDataTypeIVar intValue];
//}
//
//- (void)dynamicSetUInt32:(SInt32)number
//{
//    IESLiveCacheBasicDataTypeIVar([IESLiveDynamicModel class]);
//}
//
//- (SInt32)dynamicGetUInt32
//{
//    return [IESLiveGetCacheBasicDataTypeIVar unsignedIntValue];
//}
//
//- (void)dynamicSetShort:(short)number
//{
//    IESLiveCacheBasicDataTypeIVar([IESLiveDynamicModel class]);
//}
//
//- (short)dynamicGetShort
//{
//    return [IESLiveGetCacheBasicDataTypeIVar shortValue];
//}
//
//- (void)dynamicSetBool:(BOOL)number
//{
//    IESLiveCacheBasicDataTypeIVar([IESLiveDynamicModel class]);
//}
//
//- (BOOL)dynamicGetBool
//{
//    return [IESLiveGetCacheBasicDataTypeIVar boolValue];
//}
//
//- (void)dynamicSetSInt64:(SInt64)number
//{
//    IESLiveCacheBasicDataTypeIVar([IESLiveDynamicModel class]);
//}
//
//- (SInt64)dynamicGetSInt64
//{
//    return [IESLiveGetCacheBasicDataTypeIVar integerValue];
//}
//
//- (void)dynamicSetUInt64:(UInt64)number
//{
//    IESLiveCacheBasicDataTypeIVar([IESLiveDynamicModel class]);
//}
//
//- (UInt64)dynamicGetUInt64
//{
//    return [IESLiveGetCacheBasicDataTypeIVar unsignedIntegerValue];;
//}
//
//- (void)dynamicSetDouble:(double)number
//{
//    IESLiveCacheBasicDataTypeIVar([IESLiveDynamicModel class]);
//}
//
//- (double)dynamicGetDouble
//{
//    return [IESLiveGetCacheBasicDataTypeIVar doubleValue];
//}
//
//- (void)dynamicSetFloat:(Float32)number
//{
//    IESLiveCacheBasicDataTypeIVar([IESLiveDynamicModel class]);
//}
//
//- (Float32)dynamicGetFloat
//{
//    return [IESLiveGetCacheBasicDataTypeIVar floatValue];
//}
//
//- (void)dynamicSetPtr:(void *)ptr
//{
//    NSString *ivarName = getPropertyName(self, [NSObject class], _cmd);
//    NSValue *value = [NSValue valueWithPointer:ptr];
//    [self.DynamicModel_propertyNamePtrMap setValue:ivarName forKey:ivarName];
//    objc_setAssociatedObject(self,(__bridge const void * _Nonnull)(ivarName),value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (void *)dynamicGetPtr
//{
//    NSString *ivarName = self.DynamicModel_propertyNamePtrMap[NSStringFromSelector(_cmd)];
//    NSValue *value = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(ivarName));
//    return value.pointerValue;
//}
//
//@end

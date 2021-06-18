//
//  IESLiveDynamicModelUtil.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/9.
//

#import "IESLiveDynamicModelUtil.h"

char * const kPointRefCode = "^";
char * const kOCObjcCode = "@";
char * const kBoolCode = @encode(bool); // B
char * const kCharCode = @encode(char); // c
char * const kUnsignedCharCode = @encode(unsigned char); // C
char * const kShortCode = @encode(short); // s
char * const kUnsignedShortCode = @encode(unsigned short); // S
char * const kSInt32Code = @encode(SInt32); // int、long i
char * const kUInt32Code = @encode(UInt32); // I
char * const kSInt64Code = @encode(SInt64); // long long q
char * const kUInt64Code = @encode(UInt64); // Q
char * const k32LongCode = @encode(UInt64); // l 32位下的long
char * const k32ULongCode = @encode(UInt64); // L 32位下的unsigned long
char * const kFloatCode = @encode(float); // f
char * const kDoubleCode = @encode(double); // d
char * const kCharRefCode = @encode(char *); // * char * 拥有自己的编码 *。这在概念上是很好理解的，因为 C 的字符串被认为是一个实体，而不是指针。
char * const kClassCode = @encode(Class); // #

const int kIESLiveSetMethodLenNotIncloudIvarName = 4;
const int kIESLiveSetMethodLen = 3;
void * const kPropertiesListKey = nil;

/// 获取属性列表
NSDictionary *getPropertiesList(Class cls, Class BaseCls)
{
    // 先直接读缓存
    NSDictionary *propertiesDic = objc_getAssociatedObject(cls, &kPropertiesListKey);
    
    if(propertiesDic == nil) {
        NSMutableDictionary *dicTemp = [NSMutableDictionary new];
        // 遍历子类到父类的所有属性
        while (![NSStringFromClass(cls) isEqualToString:NSStringFromClass(BaseCls)]) {
            unsigned int count;
            objc_property_t *properties = class_copyPropertyList(cls, &count);
            for (int i = 0; i < count; i++) {
                objc_property_t property = properties[i];
                const char *pro = property_getAttributes(property);
                const char *cName = property_getName(property);
                NSString *key = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];;
                NSString *value = [NSString stringWithCString:pro encoding:NSUTF8StringEncoding];;
                [dicTemp setObject:value forKey:key];
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
NSString *getPropertyName(id<IESLiveDynamicModel> mSelf,Class baseCls, SEL selector)
{
    const char *cSelStr = sel_getName(selector);
    size_t cSelStrLen = strlen(cSelStr);
    char *cPropertyNameCapital = (char *)malloc((cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1)*sizeof(char));
    memset(cPropertyNameCapital, '\0', cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName +1);
    strncpy(cPropertyNameCapital, cSelStr + kIESLiveSetMethodLen, cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName);
    NSString *propertyNameCapital = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
    cPropertyNameCapital[0] = tolower(cPropertyNameCapital[0]);
    NSString *propertyName = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
    NSDictionary *propertyDic = getPropertiesList([mSelf class],baseCls);
    free(cPropertyNameCapital);
    if (propertyDic[propertyName]) {
        return propertyName;
    } else if (propertyDic[propertyNameCapital]) { // 属性名首字母是大写，则命中这个分支逻辑
        return propertyNameCapital;
    }
    return nil;
}

/// 缓存基础数据类型的值
void cacheBasicDataTypeIVar(id<IESLiveDynamicModel> mSelf,Class baseCls, SEL selector, NSNumber * value)
{
    NSString *ivarName = getPropertyName(mSelf, baseCls, selector);
    // 使用一个全局的map来存objc_setAssociatedObject的key(地址)
    [mSelf.DynamicModel_propertyNamePtrMap setObject:ivarName forKey:ivarName];
    objc_setAssociatedObject(mSelf,(__bridge const void * _Nonnull)(ivarName),value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 从缓存中获取基础数据类型的值
NSNumber * getCacheBasicDataTypeIVar(id<IESLiveDynamicModel> mSelf, SEL selector)
{
    NSString *ivarName = mSelf.DynamicModel_propertyNamePtrMap[NSStringFromSelector(selector)];
    NSNumber *value = objc_getAssociatedObject(mSelf, (__bridge const void * _Nonnull)(ivarName));
    return value;
}


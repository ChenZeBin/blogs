//
//  IESLiveDynamicModelUtil.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/9.
//

#import "IESLiveDynamicModelUtil.h"

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
    NSLog(@"czb__cache_name:%p,value:%@",(__bridge const void * _Nonnull)(ivarName),value);
}

/// 从缓存中获取基础数据类型的值
NSNumber * getCacheBasicDataTypeIVar(id<IESLiveDynamicModel> mSelf, SEL selector)
{
    NSString *ivarName = mSelf.DynamicModel_propertyNamePtrMap[NSStringFromSelector(selector)];
    NSNumber *value = objc_getAssociatedObject(mSelf, (__bridge const void * _Nonnull)(ivarName));
    NSLog(@"czb__get_name:%p,value:%@",(__bridge const void * _Nonnull)(ivarName),value);
    return value;
}


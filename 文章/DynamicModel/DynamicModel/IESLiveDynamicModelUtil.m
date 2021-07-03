//
//  IESLiveDynamicModelUtil.m
//  DynamicModel
//
//  Created by ChenZeBin on 2021/6/9.
//

#import "IESLiveDynamicModelUtil.h"
#import <UIKit/UIKit.h>

/// 获取属性的Attributes
void getPropertyAttributes(const char *cSelStr, size_t cSelStrLen, NSDictionary *propertiesDic, NSString **propertyAttributes, NSString **propertyName)
{
    char *cPropertyNameCapital = (char *)malloc((cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1)*sizeof(char));
    memset(cPropertyNameCapital, '\0', cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1);
    strncpy(cPropertyNameCapital, cSelStr + kIESLiveSetMethodLen, cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName);
    cPropertyNameCapital[0] = tolower(cPropertyNameCapital[0]);
    
    *propertyName = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
    *propertyAttributes = propertiesDic[*propertyName];
    if (!*propertyAttributes) {
        cPropertyNameCapital[0] = toupper(cPropertyNameCapital[0]);
        *propertyName = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
        *propertyAttributes = propertiesDic[*propertyName];
    }
    free(cPropertyNameCapital);
}

/// 获取属性列表
NSDictionary *getPropertiesList(Class cls, Class BaseCls)
{
    // 先直接读缓存
    const void *associatedkey = (__bridge const void *)(cls);
    NSDictionary *propertiesDic = objc_getAssociatedObject(cls, associatedkey);
    
    if(propertiesDic == nil) {
        NSMutableDictionary *dicTemp = [NSMutableDictionary new];
        // 遍历子类到父类的所有属性
        Class curCls = cls;
        while (![NSStringFromClass(curCls) isEqualToString:NSStringFromClass(BaseCls)]) {
            unsigned int count;
            objc_property_t *properties = class_copyPropertyList(curCls, &count);
            for (int i = 0; i < count; i++) {
                objc_property_t property = properties[i];
                const char *pro = property_getAttributes(property);
                const char *cName = property_getName(property);
                NSString *key = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];;
                NSString *value = [NSString stringWithCString:pro encoding:NSUTF8StringEncoding];;
                [dicTemp setValue:value forKey:key];
            }
            free(properties);
            curCls = [curCls superclass];
        }
        propertiesDic = [dicTemp copy];
        
        // 提升效率
        objc_setAssociatedObject(cls, associatedkey, propertiesDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return propertiesDic;
}

/// 获取属性名
NSString *getPropertyName(id mSelf,Class baseCls, SEL selector)
{
    const char *cSelStr = sel_getName(selector);
    size_t cSelStrLen = strlen(cSelStr);
    char *cPropertyNameCapital = (char *)malloc((cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName + 1)*sizeof(char));
    memset(cPropertyNameCapital, '\0', cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName +1);
    strncpy(cPropertyNameCapital, cSelStr + kIESLiveSetMethodLen, cSelStrLen - kIESLiveSetMethodLenNotIncloudIvarName);
    cPropertyNameCapital[0] = tolower(cPropertyNameCapital[0]);
    NSString *propertyName = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
    NSDictionary *propertyDic = getPropertiesList([mSelf class],baseCls);
    free(cPropertyNameCapital);
    if (propertyDic[propertyName]) {
        return propertyName;
    } else {
        // 属性名首字母是大写，则命中这个分支逻辑
        cPropertyNameCapital[0] = toupper(cPropertyNameCapital[0]);
        propertyName = [[NSString alloc] initWithCString:cPropertyNameCapital encoding:NSUTF8StringEncoding];
        if (propertyDic[propertyName]) {
            return propertyName;
        }
    }
    
    return nil;
}

/// 缓存基础数据类型的值
void cacheBasicDataTypeIVar(id mSelf,Class baseCls, SEL selector, NSNumber * value)
{
    NSString *ivarName = getPropertyName(mSelf, baseCls, selector);
    objc_setAssociatedObject(mSelf,NSSelectorFromString(ivarName),value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}


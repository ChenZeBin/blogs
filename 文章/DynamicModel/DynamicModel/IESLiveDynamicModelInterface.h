//
//  IESLiveDynamicModelInterface.h
//  DynamicModel
//
//  Created by bytedance on 2021/6/28.
//

#ifndef IESLiveDynamicModelInterface_h
#define IESLiveDynamicModelInterface_h

#import "IESLiveDynamicModelUtil.h"

/// .h中调用这个宏，声明类
#define IESLiveDefineDynamicModelClass(ClassName, InheritClass) _IESLiveDefineDynamicModelClass(ClassName, InheritClass)
/// .m中调用这个宏，实现类
#define IESLiveImplDynamicModelClass(ClassName) _IESLiveImplDynamicModelClass(ClassName)

#endif /* IESLiveDynamicModelInterface_h */

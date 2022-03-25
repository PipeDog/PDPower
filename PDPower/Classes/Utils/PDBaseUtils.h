//
//  PDBaseUtils.h
//  PDPower
//
//  Created by liang on 2022/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 判断一个类对象是否是另一个类对象的父类
/// @param superclass 父类类对象
/// @param subclass 子类类对象
/// @return YES superclass 是 subclass 的父类，NO superclass 不是 subclass 的父类
FOUNDATION_EXPORT BOOL
class_isSuperclass(Class superclass, Class subclass);

/// 交互一个类的实例方法
/// @param aClass 类对象
/// @param sourceSel 原始方法
/// @param targetSel 目标方法
FOUNDATION_EXPORT void
class_exchangeInstanceMethod(Class aClass, SEL sourceSel, SEL targetSel);

/// 交互一个类的类方法
/// @param aClass 类对象
/// @param sourceSel 原始方法
/// @param targetSel 目标方法
FOUNDATION_EXPORT void
class_exchangeClassMethod(Class aClass, SEL sourceSel, SEL targetSel);


NS_ASSUME_NONNULL_END

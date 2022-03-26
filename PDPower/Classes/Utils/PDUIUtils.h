//
//  PDUIUtils.h
//  PDPower
//
//  Created by liang on 2022/3/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 获取 responder 所直接依附的 ViewController 对象，这个 ViewController 有可能做为 ChildViewController 的方式被使用
/// @param responder UI 响应者，可能是 UIView、UIViewController 及其子类，也可能是自定义的 Component
UIKIT_EXTERN UIViewController * _Nullable PDGetViewController(UIResponder *responder);

/// 获取 responder 最终依附的 ViewController 对象，这个 ViewController 对象是被当作一个独立页面被使用的
/// @param responder UI 响应者，可能是 UIView、UIViewController 及其子类，也可能是自定义的 Component
UIKIT_EXTERN UIViewController * _Nullable PDGetRootViewController(UIResponder *responder);

/// 获取给定响应者的响应者链，并以数组的方式返回
UIKIT_EXTERN NSArray<UIResponder *> *PDObtainResponderChain(UIResponder *responder);

NS_ASSUME_NONNULL_END

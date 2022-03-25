//
//  PDUIUtils.h
//  PDPower
//
//  Created by liang on 2022/3/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 获取 responder 所依附的 ViewController 对象
/// @param responder UI 响应者，可能是 UIView、UIViewController 及其子类，也可能是自定义的 Component
UIKIT_EXTERN UIViewController * _Nullable PDGetViewController(UIResponder *responder);

NS_ASSUME_NONNULL_END

//
//  PDComponent.h
//  PDPower
//
//  Created by liang on 2022/3/26.
//

#import <UIKit/UIKit.h>
#import "PDViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 抽象组件，你可以将包含复杂业务的 ViewController 拆分成多个 Component 来进行解耦的工作
@interface PDComponent : UIResponder

/// 组件所依赖的 ViewController 对象
@property (nonatomic, weak, readonly) UIViewController *controller;
/// 组件中所绑定的容器视图，你可以像使用 ViewController 的 view 属性一样使用它
@property (nonatomic, strong, readonly) UIView *view;

- (instancetype)init NS_UNAVAILABLE;

/// 指定初始化方法
/// @param controller 组件所依赖的 ViewController 对象
- (instancetype)initWithController:(UIViewController *)controller;

/// 根据给定 Class 获取 ViewModel 对象
- (PDViewModel *)getViewModel:(Class)viewModelClass;

@end

NS_ASSUME_NONNULL_END

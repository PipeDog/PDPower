//
//  PDComponent.h
//  PDPower
//
//  Created by liang on 2022/3/26.
//

#import <UIKit/UIKit.h>
#import "PDViewModel.h"
#import "PDLifecycleObserver.h"

NS_ASSUME_NONNULL_BEGIN

/// 抽象组件，你可以将包含复杂业务的 ViewController 拆分成多个 Component 来进行解
/// 耦的工作，同时避免了 addChildViewController: 方式所带来的生命周期差异问题，Component
/// 的生命周期与所依赖的 ViewController 完全相同，你可以使用 <PDLifecycleObserver> 协议所提供
/// 的方法来进行相关操作，要注意，生命周期只有在 Component 被附加到目标 ViewController
/// 后才会生效
@interface PDComponent : UIResponder <PDLifecycleObserver>

/// Component 的容器 ViewController
@property (nonatomic, weak, readonly) UIViewController *attachedController;
/// 组件中所绑定的容器视图，你可以像使用 ViewController 的 view 属性一样使用它
@property (nonatomic, strong, readonly) UIView *view;

/// 根据给定 Class 获取 ViewModel 对象
- (PDViewModel *)getViewModel:(Class)viewModelClass;

/// 根据给定 Class 获取依赖的 ViewController 所共享的 ViewModel 对象
- (PDViewModel *)getSharedViewModelFromAttachedController:(Class)viewModelClass;

/// Component 将要被附加到 ViewController
- (void)willAttachToController:(UIViewController *)newController;
/// Component 已经被附加到 ViewController，一般来说，你可以使用这个方法来代替 - [UIViewController viewDidLoad]
- (void)didAttachToController;
/// Component 将要从 ViewController 上剥离
- (void)willDetachFromController:(UIViewController *)oldController;
/// Component 已经从 ViewController 上剥离
- (void)didDetachFromController;

@end

NS_ASSUME_NONNULL_END

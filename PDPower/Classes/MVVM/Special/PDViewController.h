//
//  PDViewController.h
//  PDPower
//
//  Created by liang on 2022/3/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PDComponent, PDViewModel;

/// ViewController 的简单扩展，提供了添加 Component 的便捷方法
@interface PDViewController : UIViewController

/// 添加 Component，并对 Component 绑定的 view 进行约束布局
- (void)attachComponent:(PDComponent *)component;
/// 移除 Component，并取消约束布局
- (void)detachComponent:(PDComponent *)component;

/// 获取 ViewModel 对象
- (__kindof PDViewModel *)getViewModel:(Class)viewModelClass;

@end

NS_ASSUME_NONNULL_END

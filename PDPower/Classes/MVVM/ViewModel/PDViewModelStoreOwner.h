//
//  PDViewModelStoreOwner.h
//  PDPower
//
//  Created by liang on 2022/3/23.
//

#import <UIKit/UIKit.h>
#import "PDViewModelStore.h"

NS_ASSUME_NONNULL_BEGIN

/// ViewModel 存储器持有者协议
@protocol PDViewModelStoreOwner <NSObject>

/// 获取 ViewModel 存储器
/// @return 获取到的 ViewModel 存储器对象
- (PDViewModelStore *)getViewModelStore;

@end


/// 通过对 UIResponder 的扩展，默认实现 PDViewModelStoreOwner 协议中的方法，让这套 MVVM 框架同时适配 UIViewController、UIView 以及自定义 Component 等不同拆分粒度
@interface UIResponder () <PDViewModelStoreOwner>

/// 获取在当前所在页面的共享 ViewModelStoreOwner，如果你需要在某个页面的各个粒度层级之间共享 ViewModel 或其中的数据，你会用到这个方法，示例如下：
/// @eg:
///     ```
///     UIResponder<PDViewModelStoreOwner> *sharedStoreOwner = [self getSharedViewModelStoreOwner];
///     PDViewModelProvider *provider = [[PDViewModelProvider alloc] initWithStoreOwner:sharedStoreOwner];
///     PDSharedXXXViewModel *viewModel = [provider getViewModel:[PDSharedXXXViewModel class]];
///     ```
/// @return 当前所在页面的共享 ViewModelStoreOwner，通常情况下这会是一个 UIViewController 实例
- (UIResponder<PDViewModelStoreOwner> *)getSharedViewModelStoreOwner;

@end

NS_ASSUME_NONNULL_END

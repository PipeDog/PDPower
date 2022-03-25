//
//  PDViewModelProvider.h
//  PDPower
//
//  Created by liang on 2022/3/23.
//

#import <UIKit/UIKit.h>
#import "PDViewModel.h"
#import "PDViewModelStoreOwner.h"

NS_ASSUME_NONNULL_BEGIN

/// ViewModel 提供器，你必须通过这个类来获取 ViewModel 对象，才能够在不同粒度层级之间进行 ViewModel 的传递共享
@interface PDViewModelProvider : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// 指定初始化方法
/// @param storeOwner ViewModel 存储器持有者，一般是 UIViewController、UIView 或其他自定义的 Component
/// @return PDViewModelProvider 对象
- (instancetype)initWithStoreOwner:(UIResponder<PDViewModelStoreOwner> *)storeOwner;

/// 获取 ViewModel 对象
/// @param viewModelClass ViewModel 的 Class
/// @return 你需要的 ViewModel 对象
- (__kindof PDViewModel *)getViewModel:(Class)viewModelClass;

@end


/// 快速获取 PDViewModelProvider 实例的扩展
@interface UIResponder (PDViewModelProvider)

/// 获取当前颗粒层级的 ViewModelProvider
- (PDViewModelProvider *)getViewModelProvider;

/// 获取当前页面共享的 ViewModelProvider
- (PDViewModelProvider *)getSharedViewModelProvider;

@end

NS_ASSUME_NONNULL_END

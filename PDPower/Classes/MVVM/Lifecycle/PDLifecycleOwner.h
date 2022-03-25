//
//  PDLifecycleOwner.h
//  PDPower
//
//  Created by liang on 2022/3/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PDLifecycle;

/// 生命周期拥有者协议，这里的生命周期是指所在 ViewController 的生命周期
@protocol PDLifecycleOwner <NSObject>

/// 获取生命周期实例
- (PDLifecycle *)getLifecycle;

@end


/// 对 UIResponder 的扩展，默认实现 PDLifecycleOwner 协议中的方法
@interface UIResponder () <PDLifecycleOwner>

@end

NS_ASSUME_NONNULL_END

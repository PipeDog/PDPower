//
//  PDLifecycle.h
//  PDPower
//
//  Created by liang on 2022/3/24.
//

#import <UIKit/UIKit.h>
#import "PDLifecycleDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PDLifecycleOwner, PDLifecycleObserver;

/// 生命周期
@interface PDLifecycle : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// 指定初始化方法
/// @param lifecycleOwner 生命周期拥有者
/// @return PDLifecycle 对象
- (instancetype)initWithLifecycleOwner:(UIResponder<PDLifecycleOwner> *)lifecycleOwner;

/// 获取当前生命周期状态
- (PDLifecycleState)getCurrentState;

/// 更新当前生命周期状态
- (void)setCurrentState:(PDLifecycleState)currentState;

/// 注册生命周期监听者
/// @param observer 监听者对象，注意这个对象并不会被强引用
- (void)addObserver:(id<PDLifecycleObserver>)observer;

/// 移除生命周期监听者
- (void)removeObserver:(id<PDLifecycleObserver>)observer;

/// 移除所有生命周期监听者
- (void)removeAllObservers;

@end

NS_ASSUME_NONNULL_END

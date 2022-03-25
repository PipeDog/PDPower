//
//  PDLifecycleObserver.h
//  PDPower
//
//  Created by liang on 2022/3/24.
//

#import <Foundation/Foundation.h>
#import "PDLifecycleDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PDLifecycleOwner;

/// 生命周期监听者协议，根据需求选择方法进行实现
@protocol PDLifecycleObserver <NSObject>

@optional
/// 生命周期切换统一回调，如果监听者实现了这一方法，则其他方法将不会被调用
/// @param lifecycleOwner 生命周期持有者，一般是 UIViewConotroller 的子类实例
/// @param state 生命周期当前状态
- (void)lifecycleOwner:(id<PDLifecycleOwner>)lifecycleOwner onStateChanged:(PDLifecycleState)state;

/// 对应 - [UIViewController init]
- (void)onPageCreate:(id<PDLifecycleOwner>)lifecycleOwner;
/// 对应 - [UIViewController viewDidLoad]
- (void)onPageDidLoad:(id<PDLifecycleOwner>)lifecycleOwner;
/// 对应 - [UIViewController viewWillAppear]
- (void)onPageWillAppear:(id<PDLifecycleOwner>)lifecycleOwner;
/// 对应 - [UIViewController viewDidAppear]
- (void)onPageDidAppear:(id<PDLifecycleOwner>)lifecycleOwner;
/// 对应 - [UIViewController viewWillDisappear]
- (void)onPageWillDisappear:(id<PDLifecycleOwner>)lifecycleOwner;
/// 对应 - [UIViewController viewDidDisappear]
- (void)onPageDidDisappear:(id<PDLifecycleOwner>)lifecycleOwner;

@end

NS_ASSUME_NONNULL_END

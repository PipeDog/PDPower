//
//  PDLiveData.h
//  PDPower
//
//  Created by liang on 2022/3/25.
//
//  在 LiveData 模块中并没有实现 Jetpack 中提供的数据修改及数据切换切换功能（Transformations），
//  LiveData 被设计初衷是为了解决 MVVM 的数据更新流转问题，而数据通常都是由 ViewModel 对外提供的，
//  个人认为，ViewModel 做为数据的提供方，对外开放的数据应该是经过处理之后的直接可用数据，所以数据修
//  改及数据切换等功能应该在 ViewModel 内部完成，为了防止功能乱用，因此将 Jetpack 中
//  Transformations.java 提供的 map（数据修改） 及 switchMap（数据切换）在这里移除
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PDLiveData;
@protocol PDLifecycleOwner;

/// LiveData 是一个数据持有者类，可以在给定的生命周期内观察到数据的更新，不要直接使用 PDLiveData，这被做为一个抽象类
@interface PDLiveData<ValueType> : NSObject

/// 添加永久监听者，不需要关心生命周期，只要绑定的 Value 发生变化，就会通知给 observer
- (void)observeForever:(void (^)(ValueType _Nullable newValue))observer;

/// 添加与生命周期绑定的监听者，当生命周期处于活跃状态时才会将 Value 的变化通知到 observer，如果
/// 处于非活跃状态，则会等到生命周期切换到活跃状态后将 Value 的变化通知到 observer，需要注意的是，
/// 当生命周期处于非活跃状态时，数据如果发生多次更新，只会保留最新的一次，中间的数据将会被丢弃
/// @param observer 监听者
/// @param lifecycleOwner 生命周期的拥有者，即 UIViewController 实例
- (void)observe:(void (^)(ValueType _Nullable newValue))observer withLifecycleOwner:(UIResponder<PDLifecycleOwner> *)lifecycleOwner;

/// 移除监听者
- (void)removeObserver:(void (^)(ValueType _Nullable newValue))observer;

/// 移除生命周期所绑定的所有观察者
- (void)removeObservers:(UIResponder<PDLifecycleOwner> *)lifecycleOwner;

/// 获取当前数据的版本号
- (NSInteger)getVersion;

/// 如果这个 LiveData 有活动的观察者，则返回 YES
- (BOOL)hasActiveObservers;

@end

NS_ASSUME_NONNULL_END

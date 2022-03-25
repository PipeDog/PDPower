//
//  PDLiveData.h
//  PDPower
//
//  Created by liang on 2022/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PDLiveData;
@protocol PDLifecycleOwner;

/// LiveData 的监听者协议
@protocol PDLiveDataObserver <NSObject>

/// LiveData 绑定数据更新回调
/// @param liveData LiveData 实例，你可以利用这一变量来进行区分具体是哪个数据发生了变化
/// @param newValue 数据的最新值
- (void)liveData:(PDLiveData *)liveData onChanged:(id)newValue;

@end

/// LiveData 是一个数据持有者类，可以在给定的生命周期内观察到
@interface PDLiveData<ValueType> : NSObject

/// 添加永久监听者，不需要关心生命周期，只要绑定的 Value 发生变化，就会通知给 observer
- (void)observeForever:(id<PDLiveDataObserver>)observer;

/// 添加与生命周期绑定的监听者，当生命周期处于活跃状态时才会将 Value 的变化通知到 observer，如果
/// 处于非活跃状态，则会等到生命周期切换到活跃状态后将 Value 的变化通知到 observer，需要注意的是，
/// 当生命周期处于非活跃状态时，数据如果发生多次更新，只会保留最新的一次，中间的数据将会被丢弃
/// @param observer 监听者
/// @param lifecycleOwner 生命周期的拥有者，即 UIViewController 实例
- (void)observe:(id<PDLiveDataObserver>)observer withLifecycleOwner:(UIResponder<PDLifecycleOwner> *)lifecycleOwner;

/// 移除监听者
- (void)removeObserver:(id<PDLiveDataObserver>)observer;

/// 移除生命周期所绑定的所有观察者
- (void)removeObservers:(UIResponder<PDLifecycleOwner> *)lifecycleOwner;

/// 当生命周期处于非活跃状态时，等待回复到活跃状态后更新数据，否则立即更新数据
- (void)setValue:(ValueType)value;

/// 获取当前数据的值
- (ValueType)getValue;

@end

NS_ASSUME_NONNULL_END

//
//  PDMediatorLiveData.h
//  PDPower
//
//  Created by liang on 2022/3/25.
//

#import "PDMutableLiveData.h"

NS_ASSUME_NONNULL_BEGIN

/// 允许合并多个 LiveData，任何原始的 LiveData 源对象发生数据更新，都会触发 PDMutableLiveData 的观察回调
@interface PDMediatorLiveData<ValueType> : PDMutableLiveData<ValueType>

/// 开始监听给定的 LiveData，观察者将在 LiveData 的值被改变时调用
- (void)addSource:(PDLiveData<ValueType> *)source observer:(id<PDLiveDataObserver>)observer;

/// 停止监听 LiveData
- (void)removeSource:(PDLiveData<ValueType> *)source;

@end

NS_ASSUME_NONNULL_END

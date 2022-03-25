//
//  PDMediatorLiveData.h
//  PDPower
//
//  Created by liang on 2022/3/25.
//

#import "PDLiveData.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDMediatorLiveData<ValueType> : PDLiveData<ValueType>

- (void)addSource:(PDLiveData<ValueType> *)source observer:(id<PDLiveDataObserver>)observer;
- (void)removeSource:(PDLiveData<ValueType> *)source;

@end

NS_ASSUME_NONNULL_END

//
//  PDMutableLiveData.h
//  PDPower
//
//  Created by liang on 2022/3/25.
//

#import "PDLiveData.h"

NS_ASSUME_NONNULL_BEGIN

/// PDLiveData 的具体实现类，使用这个类来进行基础的数据更新监听
@interface PDMutableLiveData<ValueType> : PDLiveData<ValueType>

/// 当生命周期处于非活跃状态时，等待回复到活跃状态后更新数据，否则立即更新数据
- (void)setValue:(ValueType _Nullable)value;

/// 获取当前数据的值
- (ValueType _Nullable)getValue;

@end

NS_ASSUME_NONNULL_END

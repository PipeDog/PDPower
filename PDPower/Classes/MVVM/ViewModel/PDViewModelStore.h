//
//  PDViewModelStore.h
//  PDPower
//
//  Created by liang on 2022/3/23.
//

#import <Foundation/Foundation.h>
#import "PDViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// ViewModel 的存储器，这里只负责 ViewModel 的存取，不涉及任何其他的动作
@interface PDViewModelStore : NSObject

/// 通过唯一标识获取 ViewModel 对象
- (PDViewModel * _Nullable)viewModelForKey:(NSString *)key;

/// 通过唯一标识进行 PDViewModel 的存储
- (void)setViewModel:(PDViewModel * _Nullable)viewModel forKey:(NSString *)key;

/// 清空所有意境存储的 ViewModel 对象
- (void)removeAllViewModels;

@end


/// 功能扩展，这里提供了语法糖，可以使你像使用 NSDictionary 一样去进行操作
@interface PDViewModelStore (Subscript)

/// 通过下标的方式使用唯一标识来进行 ViewModel 对象的获取
- (PDViewModel * _Nullable)objectForKeyedSubscript:(NSString *)key;

/// 通过下标的方式使用唯一标识进行 PDViewModel 的存储
- (void)setObject:(PDViewModel * _Nullable)obj forKeyedSubscript:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

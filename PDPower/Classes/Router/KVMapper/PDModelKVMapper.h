//
//  PDModelKVMapper.h
//  PDModelKVMapper
//
//  Created by liang on 2020/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// @brief 给指定 model 设置属性的值
/// @param model 需要被最终赋值的 model
/// @param pairs 键值集合 map
FOUNDATION_EXPORT void PDModelSetValuesForProperties(id model, NSDictionary<NSString *, id> *pairs);

typedef NSString * PDModelDataSourceName;   ///< 数据源中 key 名称
typedef NSString * PDModelPropertyName;     ///< model 属性名称

/// @protocol PDModelKVMapProtocol
/// @brief KV 映射协议
@protocol PDModelKVMapProtocol <NSObject>

@optional
/// @brief 获取自定义属性映射表
/// @return 自定义属性映射表，Key - 数据源中的 Key，Value - 目标属性名称
/// @eg:
///  + (NSDictionary *)modelCustomPropertyNameMapper {
///      return @{@"n": @"name",
///               @"p": @"page",
///               @"h": @"height"};
///  }
///
+ (NSDictionary<PDModelDataSourceName, PDModelPropertyName> *)modelCustomPropertyNameMapper;

@end

/// @class PDModelKVMapper
/// @brief 键值对映射器
@interface PDModelKVMapper : NSObject

/// @brief 全局单例
@property (class, strong, readonly) PDModelKVMapper *defaultMapper;

/// @brief 映射键值集合指指定 model
/// @param pairs 键值集合 map
/// @param model 需要被最终赋值的 model
- (void)mapKeyValuePairs:(NSDictionary<NSString *, id> *)pairs toModel:(id)model;

@end

NS_ASSUME_NONNULL_END

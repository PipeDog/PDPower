//
//  PDRouterUtils.h
//  PDPower
//
//  Created by liang on 2022/3/29.
//

#import <UIKit/UIKit.h>
#import "PDRouteNodeValidation.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDRouterUtils : NSObject

/// 通过 <PDRouteNodeValidation> 协议验证路由节点是否有效，并返回结果
/// @param node 路由节点，一般是 UIViewController 类型的实例
/// @param pagepath 该节点对应的路径地址，即 `- [PDRouter openURL:params:]` 方法中传递的第一个参数
/// @param params 路由参数，即 `- [PDRouter openURL:params:]` 方法中传递的第二个参数
/// @return 如果有效则直接跳转到该节点，如果无效，则通过协议约定的方法 `- forwardRouteAction: params:`
///         进行路由转发，重定向到最终的目标节点
+ (BOOL)validateRouteWithNode:(id)node pagepath:(NSString *)pagepath params:(NSDictionary * _Nullable)params;

/// 解析输入的路径及参数，返回解析结果
/// @param urlString 待处理路径
/// @param params 待处理参数
/// @param outParams 解析后的输出参数
/// @return 解析后返回的标准路径
+ (NSString *)parseURL:(NSString *)urlString params:(NSDictionary * _Nullable)params to:(NSDictionary * _Nullable * _Nullable)outParams;

@end

NS_ASSUME_NONNULL_END

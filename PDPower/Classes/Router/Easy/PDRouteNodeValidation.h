//
//  PDRouteNodeValidation.h
//  PDPower
//
//  Created by liang on 2022/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 路由节点验证协议，一般由 ViewController 遵守并实现此协议，在 plugin 中被调用
@protocol PDRouteNodeValidation <NSObject>

/// 是否允许跳转至当前节点
/// @param params 路由参数
/// @return 如果返回 YES，则允许跳转；如果返回 NO，则禁止跳转到此节点
- (BOOL)canRouteWithParams:(NSDictionary *)params;

@optional
/// 转发路由动作，如果 `- canRouteWithParams:` 返回 NO，则进行的路由转发处理，当然你
/// 也可以在这里什么都不做，如：一个页面仅支持登录状态进入，那么在
/// `- forwardRouteAction: params:` 方法中应该实现跳转至登录页的代码
- (void)forwardRouteAction:(NSString *)url params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END

//
//  PDRouter.h
//  PDRouter
//
//  Created by liang on 2018/7/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 路由代理协议
@protocol PDRouterDelegate <NSObject>

@optional
/// 执行 `- openURL:params:` 方法完成
- (void)didFinishOpenURL:(NSString *)urlString params:(NSDictionary * _Nullable)params;
/// 执行 `- openURL:params:` 方法失败
- (void)didFailOpenURL:(NSString *)urlString params:(NSDictionary * _Nullable)params;

@end

/// 路由入口类
@interface PDRouter : NSObject

/// 路由全局单例
@property (class, strong, readonly) PDRouter *globalRouter;

/// 如果需要使用路由进行页面间的跳转，你需要设置这一属性
@property (nonatomic, weak) __kindof UINavigationController *navigationController;
/// 路由代理协议实例
@property (nonatomic, weak) id<PDRouterDelegate> delegate;

/// 注册动作表，维护路径 - 动作的映射关系
- (void)inject:(NSString *)urlString eventHandler:(void (^)(NSDictionary * _Nullable params))eventHandler;
/// 执行路径关联的动作
- (BOOL)openURL:(NSString *)urlString params:(NSDictionary * _Nullable)params;

@end

NS_ASSUME_NONNULL_END

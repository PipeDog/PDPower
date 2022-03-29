//
//  PDRouterPlugin.h
//  PDRouter
//
//  Created by liang on 2019/5/29.
//  Copyright © 2019 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDRouter.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    const char *pluginname;
    const char *classname;
} PDRouterPluginName;

/* Export plugin */
#define __PD_EXPORT_PLUGIN_EXT(pluginname, classname) \
__attribute__((used, section("__DATA , pd_exp_plugin"))) \
static const PDRouterPluginName __pd_exp_plugin_##pluginname##__ = {#pluginname, #classname};

#define PD_EXPORT_PLUGIN(pluginname, classname) __PD_EXPORT_PLUGIN_EXT(pluginname, classname)

typedef NSInteger PDRouterPluginPriority;

/// 路由插件抽象类，你需要继承这个类来实现相关的功能
@interface PDRouterPlugin : NSObject

/// 设置给 PDRouter 的 navigationController，将会被同步到这一属性
@property (nonatomic, weak, nullable) __kindof UINavigationController *navigationController;
/// 导出插件时设置的插件名称
@property (nonatomic, copy, nullable) NSString *name;
/// PDRouter 实例
@property (nonatomic, weak) PDRouter *router;

/// 插件优先级，最终会按照插件的优先级来进行功能的执行
- (PDRouterPluginPriority)priority;

/// 插件被加载时的回调
- (void)load;

/// 执行某一路径对应的动作
/// @param urlString 路径地址
/// @param params 路由参数
/// @return 执行结果，如果执行成功返回 YES，则不会再继续执行其他插件，否则继续执行其他插件中的这一方法
- (BOOL)openURL:(NSString *)urlString params:(NSDictionary * _Nullable)params;

@end

NS_ASSUME_NONNULL_END

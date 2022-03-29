//
//  PDPageRouterPlugin.h
//  PDPower_Example
//
//  Created by liang on 2022/3/29.
//  Copyright © 2022 liang. All rights reserved.
//

#import <PDPower/PDPower.h>

NS_ASSUME_NONNULL_BEGIN

/// 导出页面跳转路由插件
PD_EXPORT_PLUGIN(PageRouterPlugin, PDPageRouterPlugin)

@interface PDPageRouterPlugin : PDSpecialRouterPlugin

@end

NS_ASSUME_NONNULL_END

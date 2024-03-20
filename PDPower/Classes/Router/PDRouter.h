//
//  PDRouter.h
//  PDPower
//
//  Created by liang on 2024/3/19.
//

#import <Foundation/Foundation.h>
#import "PDRouterInterceptor.h"
#import "PDRouterPageRegistry.h"

NS_ASSUME_NONNULL_BEGIN

/**
 使用 `PD_EXPORT_PAGE` 宏来导出页面信息，例如：

 ```
 PD_EXPORT_PAGE("pipedog://open/page/intro", PDIntroViewController)
 
 @interface PDIntroViewController : UIViewController
 @property (nonatomic, copy) NSString *name;
 @property (nonatomic, assign) NSInteger age;
 @end
 ```
 
 然后可以使用注册的 `pagepath` 作为参数进行页面跳转（会自动将 `parameters` 中的值赋给目标页面的属性），例如：
 
 ```
 [[PDRouter globalRouter] openURL:@"pipedog://open/page/intro" parameters:@{@"name": @"xiao", @"age": @20}];
 ```
 */
#define PD_EXPORT_PAGE(pagePath, className) __PD_EXPORT_PAGE_EXT(pagePath, className)

/**
 `PDRouter` 类是路由框架的入口类，负责管理和调度路由请求
 */
@interface PDRouter : NSObject

/**
 获取全局路由单例对象
 */
@property (class, strong, readonly) PDRouter *globalRouter;

/**
 导航控制器，用于页面跳转
 */
@property (nonatomic, strong) UINavigationController *navigator;

/**
 添加一个拦截器到路由框架中

 @param interceptor 要添加的拦截器
 */
- (void)addInterceptor:(id<PDRouterInterceptor>)interceptor;

/**
 打开一个 URL 对应的路由

 @param urlString 要打开的 URL 字符串
 @param parameters 传递给目标页面的参数
 @return 如果路由处理成功返回 YES，否则返回 NO
 */
- (BOOL)openURL:(NSString *)urlString parameters:(NSDictionary * _Nullable)parameters;

@end

NS_ASSUME_NONNULL_END

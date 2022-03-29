//
//  PDSpecialRouterPlugin.h
//  PDPower
//
//  Created by liang on 2022/3/29.
//

#import "PDRouterPlugin.h"
#import "PDPowerDefine.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    const char *pagepath;
    const char *classname;
} PDRoutePageName;

#define __PD_EXPORT_PAGE_EXT(pagepath, classname) \
__attribute__((used, section("__DATA , pd_exp_page"))) \
static const PDRoutePageName __pd_exp_page_##classname##__ = {pagepath, #classname};

/// 导出页面信息，@eg:
///
/// PD_EXPORT_PAGE(pipedog://open/page/intro, PDIntroViewController)
/// @interface PDIntroViewController : UIViewController
///
/// @property (nonatomic, copy) NSString *name;
/// @property (nonatomic, assign) NSInteger age;
///
/// @end
///
/// 然后你可以使用注册的 pagepath 做为参数来进行页面跳转，@eg:
/// [[PDRouter globalRouter] openURL:@"pipedog://open/page/intro" params:@{@"name": @"xiao", @"age": @20}];
/// 
#define PD_EXPORT_PAGE(pagepath, classname) __PD_EXPORT_PAGE_EXT(pagepath, classname)

/// 页面转场模式定义
typedef NS_OPTIONS(NSInteger, PDSkip2PageMode) {
    PDSkip2PageModeTransitionMask = 0xFF, ///< 转场模式掩码
    PDSkip2PageModeTransitionPush = 1, ///< Push
    PDSkip2PageModeTransitionPresent = 2, ///< Present
    
    PDSkip2PageModeAnimatedMask = 0xFF00, ///< 转场动画掩码
    PDSkip2PageModeAnimatedRequired = 1 << 8, ///< 需要动画
    PDSkip2PageModeAnimatedForbidden = 1 << 9, ///< 不需要动画
};

/// 内嵌定制能力插件，如果需要你可以对这个类进行继承，并通过 `PD_EXPORT_PLUGIN(pluginname, classname)`
/// 来进行插件信息注册，插件注册后你可以通过 `PD_EXPORT_PAGE(pagepath, classname)` 这个宏来进行页面信息
/// 的导出，然后你就可以在 `- [PDRouter openURL:params:]` 方法中将声明的 pagepath 做为参数来进行页面的
/// 跳转了，为了保证 PDRouter 是干净、简单的，因此在这里抽象了一个通用功能插件，如果你只是需要通过路由来进行
/// 页面间的切换，这应该已经满足了你的大部分需求
@interface PDSpecialRouterPlugin : PDRouterPlugin

/// 根据页面路径及参数返回转场模式
/// @param pagepath 页面路径
/// @param params 路由参数
/// @return 指定页面转场模式
- (PDSkip2PageMode)getSkip2PageMode:(NSString *)pagepath withParams:(NSDictionary *)params PD_REQUIRED_OVERRIDE;

@end

NS_ASSUME_NONNULL_END

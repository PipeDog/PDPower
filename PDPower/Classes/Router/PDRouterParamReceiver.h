//
//  PDRouterParamReceiver.h
//  PDPower
//
//  Created by liang on 2024/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 `PDRouterAutoParamReceiver` 协议允许视图控制器自动接收并将路由参数映射到其属性中

 实现此协议的视图控制器可以自动将路由参数赋值给其对应的属性。例如：

 @code
 PD_EXPORT_PAGE("pipedog://open/page/intro", PDIntroViewController)

 @interface PDIntroViewController : UIViewController <PDRouterAutoParamReceiver>
 @property (nonatomic, copy) NSString *name;
 @property (nonatomic, assign) NSInteger age;
 @end
 @endcode

 使用注册的 `pagepath` 进行页面跳转时，会自动将 `parameters` 中的值赋给目标页面的属性：

 @code
 [[PDRouter globalRouter] openURL:@"pipedog://open/page/intro" parameters:@{@"name": @"Tom", @"age": @20}];
 @endcode

 此时，`PDIntroViewController` 的 `name` 属性将被设置为 "Tom"，`age` 属性将被设置为 20
 */
@protocol PDRouterAutoParamReceiver <NSObject>

@end


/**
 `PDRouterManualParamReceiver` 协议允许视图控制器手动接收路由参数

 实现此协议的视图控制器需要通过实现 `onRouterParameters:` 方法来手动处理路由参数
 */
@protocol PDRouterManualParamReceiver <NSObject>

/**
 接收并处理从路由传递过来的参数

 @param parameters 从路由传递过来的参数字典
 */
- (void)onRouterParameters:(NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END

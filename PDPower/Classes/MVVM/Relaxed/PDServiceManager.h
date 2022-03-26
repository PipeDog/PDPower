//
//  PDServiceManager.h
//  PDPower
//
//  Created by liang on 2022/3/26.
//

#import <Foundation/Foundation.h>
#import "PDBizService.h"

NS_ASSUME_NONNULL_BEGIN

/// Service 管理器
@interface PDServiceManager : NSObject

@property (class, strong, readonly) PDServiceManager *defaultManager;

/// 注册 Service 的实现类
- (void)registerClass:(Class)aClass forType:(Protocol *)aProtocol;

/// 撤销 Service 的实现类
- (void)unregisterClassForType:(Protocol *)aProtocol;

/// 注册 Service 的实现类实例
- (void)addService:(id)service forType:(Protocol *)aProtocol;

/// 删除 Service 的实现类实例
- (void)removeServiceForType:(Protocol *)aProtocol;

/// 获取 Service 的实现类实例
- (id<PDBizService> _Nullable)serviceForType:(Protocol *)aProtocol;

/// 判断是否已经注册 Service 的实现类或实现类实例
- (BOOL)containsType:(Protocol *)aProtocol;

/// 移除所有 Service 注册信息
- (void)removeAllServices;

@end

NS_ASSUME_NONNULL_END

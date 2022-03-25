//
//  PDServiceManager.h
//  PDPower
//
//  Created by liang on 2022/3/26.
//

#import <Foundation/Foundation.h>
#import "PDBizService.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDServiceManager : NSObject

@property (class, strong, readonly) PDServiceManager *defaultManager;

- (void)registerClass:(Class)aClass forType:(Protocol *)aProtocol;
- (void)unregisterClassForType:(Protocol *)aProtocol;

- (void)addService:(id)service forType:(Protocol *)aProtocol;
- (void)removeServiceForType:(Protocol *)aProtocol;

- (id<PDBizService> _Nullable)serviceForType:(Protocol *)aProtocol;

- (BOOL)containsType:(Protocol *)aProtocol;
- (void)removeAllServices;

@end

NS_ASSUME_NONNULL_END

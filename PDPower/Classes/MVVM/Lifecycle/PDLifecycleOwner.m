//
//  PDLifecycleOwner.m
//  PDPower
//
//  Created by liang on 2022/3/24.
//

#import "PDLifecycleOwner.h"
#import "PDLifecycle.h"
#import "PDUIUtils.h"
#import <objc/runtime.h>

@implementation UIResponder (PDLifecycleOwner)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (PDLifecycle *)getLifecycle {
    UIViewController *viewController = PDGetViewController(self);
    if (!viewController) {
        [[NSException exceptionWithName:@"PDLifecycleOwnerException"
                                 reason:@"Can not find `UIViewConotroller` instance as `LifecycleOwner`!"
                               userInfo:nil] raise];
    }
    
    PDLifecycle *lifecycle = objc_getAssociatedObject(viewController, _cmd);
    if (!lifecycle) {
        lifecycle = [[PDLifecycle alloc] initWithLifecycleOwner:viewController];
        objc_setAssociatedObject(viewController, _cmd, lifecycle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return lifecycle;
}

#pragma clang diagnostic pop

@end

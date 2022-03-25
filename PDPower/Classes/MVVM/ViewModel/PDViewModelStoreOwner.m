//
//  PDViewModelStoreOwner.m
//  PDPower
//
//  Created by liang on 2022/3/23.
//

#import "PDViewModelStoreOwner.h"
#import "PDUIUtils.h"
#import <objc/runtime.h>

@implementation UIResponder (PDViewModelStoreOwner)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (PDViewModelStore *)getViewModelStore {
    PDViewModelStore *viewModelStore = objc_getAssociatedObject(self, _cmd);
    if (!viewModelStore) {
        viewModelStore = [[PDViewModelStore alloc] init];
        objc_setAssociatedObject(self, _cmd, viewModelStore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return viewModelStore;
}

- (UIResponder<PDViewModelStoreOwner> *)getSharedViewModelStoreOwner {
    UIViewController *viewController = PDGetRootViewController(self);
    if (!viewController) {
        [[NSException exceptionWithName:@"PDViewModelStoreOwnerException"
                                 reason:@"Can not find `UIViewConotroller` instance as `SharedViewModelStoreOwner`!"
                               userInfo:nil] raise];
    }
    return viewController;
}

#pragma clang diagnostic pop

@end

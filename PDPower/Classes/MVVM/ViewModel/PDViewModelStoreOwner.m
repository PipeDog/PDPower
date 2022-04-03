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

#pragma mark - PDViewModelStoreOwner Methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (BOOL)isSharedViewModelStoreOwner {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setSharedViewModelStoreOwner:(BOOL)sharedViewModelStoreOwner {
    objc_setAssociatedObject(self, @selector(isSharedViewModelStoreOwner), @(sharedViewModelStoreOwner), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PDViewModelStore *)getViewModelStore {
    PDViewModelStore *viewModelStore = objc_getAssociatedObject(self, _cmd);
    if (!viewModelStore) {
        viewModelStore = [[PDViewModelStore alloc] init];
        objc_setAssociatedObject(self, _cmd, viewModelStore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return viewModelStore;
}

- (UIResponder<PDViewModelStoreOwner> *)getSharedViewModelStoreOwner {
    UIResponder *sharedViewModelStoreOwner = [UIResponder _getSharedViewModelStoreOwnerNode:self];
    if (!sharedViewModelStoreOwner) {
        [[NSException exceptionWithName:@"PDViewModelStoreOwnerException"
                                 reason:@"Can not find `sharedViewModelStoreOwner` instance!"
                               userInfo:nil] raise];
    }
    return sharedViewModelStoreOwner;
}

#pragma clang diagnostic pop

#pragma mark - Private Methods

+ (UIResponder *)_getSharedViewModelStoreOwnerNode:(UIResponder *)responder {
    UIResponder *oldResponder = responder;
    
    // Find tag by property `isSharedViewModelStoreOwner`
    while (responder.nextResponder) {
        if (responder.isSharedViewModelStoreOwner) {
            return responder;
        }
        responder = responder.nextResponder;
    }
    
    // Find UIViewController
    if (!responder) {
        responder = PDGetViewController(oldResponder);
    }
    
    return responder;
}

@end

//
//  PDViewModelProvider.m
//  PDPower
//
//  Created by liang on 2022/3/23.
//

#import "PDViewModelProvider.h"
#import "PDViewModelStoreOwner.h"
#import "PDBaseUtils.h"
#import <objc/runtime.h>

@interface PDViewModelProvider ()

@property (nonatomic, weak) UIResponder<PDViewModelStoreOwner> *viewModelStoreOwner;
@property (nonatomic, strong) PDViewModelStore *viewModelStore;

@end

@implementation PDViewModelProvider

- (instancetype)initWithStoreOwner:(UIResponder<PDViewModelStoreOwner> *)storeOwner {
    if (!storeOwner) {
        [[NSException exceptionWithName:@"PDViewModelProviderException"
                                 reason:@"The argument `storeOwner` can not be nil!"
                               userInfo:nil] raise];
    }
    
    self = [super init];
    if (self) {
        _viewModelStoreOwner = storeOwner;
        _viewModelStore = [storeOwner getViewModelStore];
    }
    return self;
}

- (__kindof PDViewModel *)getViewModel:(Class)viewModelClass {
    if (!viewModelClass || !class_isSuperclass([PDViewModel class], viewModelClass)) {
        NSAssert(NO, @"Invalid argument `viewModelClass`, check it!");
        return nil;
    }
        
    NSString *key = [self formatKeyWithViewModelClass:viewModelClass];
    PDViewModel *viewModel = self.viewModelStore[key];
    if (viewModel) {
        return viewModel;
    }
    
    viewModel = [[viewModelClass alloc] init];
    self.viewModelStore[key] = viewModel;
    return viewModel;
}

#pragma mark - Private Methods
- (NSString *)formatKeyWithViewModelClass:(Class)viewModelClass {
    return [NSString stringWithFormat:@"PDViewModelProvider::%@", viewModelClass];
}

@end

@implementation UIResponder (PDViewModelProvider)

- (PDViewModelProvider *)getViewModelProvider {
    PDViewModelProvider *viewModelProvider = objc_getAssociatedObject(self, _cmd);
    if (!viewModelProvider) {
        viewModelProvider = [[PDViewModelProvider alloc] initWithStoreOwner:self];
        objc_setAssociatedObject(self, _cmd, viewModelProvider, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return viewModelProvider;
}

- (PDViewModelProvider *)getSharedViewModelProvider {
    PDViewModelProvider *viewModelProvider = objc_getAssociatedObject(self, _cmd);
    if (!viewModelProvider) {
        UIResponder<PDViewModelStoreOwner> *storeOwner = [self getSharedViewModelStoreOwner];
        viewModelProvider = [[PDViewModelProvider alloc] initWithStoreOwner:storeOwner];
        objc_setAssociatedObject(self, _cmd, viewModelProvider, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return viewModelProvider;
}

@end

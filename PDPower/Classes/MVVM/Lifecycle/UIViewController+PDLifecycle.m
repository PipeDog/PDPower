//
//  UIViewController+PDLifecycle.m
//  PDPower
//
//  Created by liang on 2022/3/24.
//

#import "UIViewController+PDLifecycle.h"
#import "PDBaseUtils.h"
#import "PDLifecycleOwner.h"
#import "PDLifecycle.h"

@implementation UIViewController (PDLifecycle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        class_exchangeInstanceMethod(self,
                                     @selector(init),
                                     @selector(pd_init));
        class_exchangeInstanceMethod(self,
                                     @selector(viewDidLoad),
                                     @selector(pd_viewDidLoad));
        class_exchangeInstanceMethod(self,
                                     @selector(viewWillAppear:),
                                     @selector(pd_viewWillAppear:));
        class_exchangeInstanceMethod(self,
                                     @selector(viewDidAppear:),
                                     @selector(pd_viewDidAppear:));
        class_exchangeInstanceMethod(self,
                                     @selector(viewWillDisappear:),
                                     @selector(pd_viewWillDisappear:));
        class_exchangeInstanceMethod(self,
                                     @selector(viewDidDisappear:),
                                     @selector(pd_viewDidDisappear:));
        class_exchangeInstanceMethod(self,
                                     NSSelectorFromString(@"dealloc"),
                                     @selector(pd_dealloc));
    });
}

#pragma mark - Lifecycle Methods
- (instancetype)pd_init {
    UIViewController *_self = [self pd_init];
    [_self pd_setCurrentState:PDLifecycleStatePageCreate];
    return _self;
}

- (void)pd_viewDidLoad {
    [self pd_viewDidLoad];
    [self pd_setCurrentState:PDLifecycleStatePageDidLoad];
}

- (void)pd_viewWillAppear:(BOOL)animated {
    [self pd_viewWillAppear:animated];
    [self pd_setCurrentState:PDLifecycleStatePageWillAppear];
}

- (void)pd_viewDidAppear:(BOOL)animated {
    [self pd_viewDidAppear:animated];
    [self pd_setCurrentState:PDLifecycleStatePageDidAppear];
}

- (void)pd_viewWillDisappear:(BOOL)animated {
    [self pd_setCurrentState:PDLifecycleStatePageWillDisappear];
    [self pd_viewWillDisappear:animated];
}

- (void)pd_viewDidDisappear:(BOOL)animated {
    [self pd_setCurrentState:PDLifecycleStatePageDidDisappear];
    [self pd_viewDidDisappear:animated];
}

- (void)pd_dealloc {
    [self pd_setCurrentState:PDLifecycleStatePageDealloc];
    [self pd_dealloc];
}

#pragma mark - Private Methods
- (void)pd_setCurrentState:(PDLifecycleState)state {
    PDLifecycle *lifecycle = [self getLifecycle];
    [lifecycle setCurrentState:state];
}

@end

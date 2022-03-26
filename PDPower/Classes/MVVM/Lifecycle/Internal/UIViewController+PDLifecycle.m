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
    
    // 这里将 block 中的两个方法包装起来，并将他们推迟到下一次 runLoop 进行执行，主要是
    // 因为 runLoop 的因素，导致方法的执行顺序不符合预期，在不进行干涉的情况下，block 中
    // 的两个方法是在本次 runLoop 中执行的，而 - init 方法则是在下一次 runLoop 中执行
    // （你可以通过打印日志或断点的方式去进行确认，来确保我所描述的真实性），为了消除 runLoop
    // 带来的影响，这里将 block 中的方法推迟到了下一次 runLoop 执行，并且因为 runLoop
    // 采用来链表来进行任务的管理，而 - init 方法是做为任务节点先被提交的，所以可以保证
    // - init 方法一定在 block 中的方法执行之后才会被执行
    
    [self pd_executeBlockOnMainThread:^{
        [_self pd_observeAppState];
        [_self pd_setCurrentState:PDLifecycleStatePageCreate];
    }];
    
    return _self;
}

- (void)pd_viewDidLoad {
    // 原因同 - pd_init 方法所描述的，也是为了消除 runLoop 对这两个方法的影响
    [self pd_executeBlockOnMainThread:^{
        [self pd_viewDidLoad];
        [self pd_setCurrentState:PDLifecycleStatePageDidLoad];
    }];
}

- (void)pd_viewWillAppear:(BOOL)animated {
    // 为了保证 viewDidLoad 与 viewWillAppear: 两个方法的执行顺序，因此这里将
    // viewWillAppear: 的执行也推迟到了下一次 runLoop，以此来保证 viewWillAppear:
    // 一定在 viewDidLoad 方法之后执行
    [self pd_executeBlockOnMainThread:^{
        [self pd_viewWillAppear:animated];
        [self pd_setCurrentState:PDLifecycleStatePageWillAppear];
    }];
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
    [self pd_cancelObserveAppState];
    [self pd_dealloc];
}

- (void)pd_observeAppState {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pd_applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pd_applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)pd_cancelObserveAppState {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pd_applicationDidBecomeActive:(NSNotification *)notification {
    PDLifecycleState state = [[self getLifecycle] getCurrentState];
    [self pd_setCurrentState:state];
}

- (void)pd_applicationWillResignActive:(NSNotification *)notification {
    PDLifecycleState state = [[self getLifecycle] getCurrentState];
    [self pd_setCurrentState:state];
}

#pragma mark - Private Methods
- (void)pd_setCurrentState:(PDLifecycleState)state {
    PDLifecycle *lifecycle = [self getLifecycle];
    [lifecycle setCurrentState:state];
}

- (void)pd_executeBlockOnMainThread:(dispatch_block_t)block {
    // 这里的主要目的并不是切换线程，而是为了让任务在下一次 runLoop 中执行
    [self performSelector:@selector(pd_executeBlock:)
                 onThread:[NSThread mainThread] withObject:[block copy] waitUntilDone:NO];
}

- (void)pd_executeBlock:(dispatch_block_t)block {
    if (block) block();
}

@end

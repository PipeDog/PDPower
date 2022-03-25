//
//  PDLifecycle.m
//  PDPower
//
//  Created by liang on 2022/3/24.
//

#import "PDLifecycle.h"
#import "PDLifecycleObserver.h"
#import "PDUIUtils.h"

@interface PDLifecycle ()

@property (nonatomic, weak) UIResponder<PDLifecycleOwner> *lifecycleOwner;
@property (nonatomic, strong) NSHashTable<id<PDLifecycleObserver>> *observerTable;
@property (nonatomic, assign) PDLifecycleState currentState;

@end

@implementation PDLifecycle

- (instancetype)initWithLifecycleOwner:(UIResponder<PDLifecycleOwner> *)lifecycleOwner {
    self = [super init];
    if (self) {
        UIViewController *realLifecycleOwner = PDGetRootViewController(lifecycleOwner);
        if (!realLifecycleOwner) {
            [[NSException exceptionWithName:@"PDLifecycleException"
                                     reason:@"Can not found `UIViewController` instance as `PDLifecycleOwner`!"
                                   userInfo:nil] raise];
        }
        
        _lifecycleOwner = (UIResponder<PDLifecycleOwner> *)realLifecycleOwner;
        _observerTable = [NSHashTable weakObjectsHashTable];
        _currentState = PDLifecycleStateUnknown;
    }
    return self;
}

- (PDLifecycleState)getCurrentState {
    return _currentState;
}

- (void)setCurrentState:(PDLifecycleState)currentState {
    _currentState = currentState;
    [self dispatchLifecycleState];
}

- (void)addObserver:(id<PDLifecycleObserver>)observer {
    [self.observerTable addObject:observer];
}

- (void)removeObserver:(id<PDLifecycleObserver>)observer {
    [self.observerTable removeObject:observer];
}

- (void)removeAllObservers {
    [self.observerTable removeAllObjects];
}

#pragma mark - Private Methods
- (void)dispatchLifecycleState {
    id<PDLifecycleOwner> lifecycleOwner = self.lifecycleOwner;
    PDLifecycleState currentState = self.currentState;
    NSArray<id<PDLifecycleObserver>> *observers = self.observerTable.allObjects;
    
    for (id<PDLifecycleObserver> observer in observers) {
        if ([observer respondsToSelector:@selector(lifecycleOwner:onStateChanged:)]) {
            [observer lifecycleOwner:lifecycleOwner onStateChanged:currentState];
            continue;
        }

        switch (currentState) {
            case PDLifecycleStatePageCreate: {
                if ([observer respondsToSelector:@selector(onPageCreate:)]) {
                    [observer onPageCreate:lifecycleOwner];
                }
            } break;
            case PDLifecycleStatePageDidLoad: {
                if ([observer respondsToSelector:@selector(onPageDidLoad:)]) {
                    [observer onPageDidLoad:lifecycleOwner];
                }
            } break;
            case PDLifecycleStatePageWillAppear: {
                if ([observer respondsToSelector:@selector(onPageWillAppear:)]) {
                    [observer onPageWillAppear:lifecycleOwner];
                }
            } break;
            case PDLifecycleStatePageDidAppear: {
                if ([observer respondsToSelector:@selector(onPageDidAppear:)]) {
                    [observer onPageDidAppear:lifecycleOwner];
                }
            } break;
            case PDLifecycleStatePageWillDisappear: {
                if ([observer respondsToSelector:@selector(onPageWillDisappear:)]) {
                    [observer onPageWillDisappear:lifecycleOwner];
                }
            } break;
            case PDLifecycleStatePageDidDisappear: {
                if ([observer respondsToSelector:@selector(onPageDidDisappear:)]) {
                    [observer onPageDidDisappear:lifecycleOwner];
                }
            } break;
            default: break;
        }
    }
}

@end

BOOL PDLifecycleIsActive(PDLifecycleState state) {
    switch (state) {
        case PDLifecycleStatePageCreate:
        case PDLifecycleStatePageDidLoad:
        case PDLifecycleStatePageWillAppear:
        case PDLifecycleStatePageDidAppear:
        case PDLifecycleStatePageWillDisappear: {
            return YES;
        }
        case PDLifecycleStatePageDidDisappear:
        default: {
            return NO;
        }
    }
}

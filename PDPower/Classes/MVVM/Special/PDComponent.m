//
//  PDComponent.m
//  PDPower
//
//  Created by liang on 2022/3/26.
//

#import "PDComponent.h"
#import "PDViewModelProvider.h"
#import "PDLifecycleOwner.h"
#import "PDLifecycle.h"

@interface PDComponentView : UIView

@property (nonatomic, weak) PDComponent *component;

@end

@implementation PDComponentView

- (instancetype)initWithComponent:(PDComponent *)component {
    self = [super init];
    if (self) {
        _component = component;
    }
    return self;
}

- (UIResponder *)nextResponder {
    return self.component;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled ||
        self.isHidden ||
        self.alpha <= 0.01f ||
        ![self pointInside:point withEvent:event]) {
        return nil;
    }

    __block UIView *responder = nil;
    NSArray<UIView *> *subviews = [self.subviews copy];
    [subviews enumerateObjectsWithOptions:NSEnumerationReverse
                               usingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint convertPoint = [self convertPoint:point toView:obj];
        responder = [obj hitTest:convertPoint withEvent:event];
        if (responder) {
            *stop = YES;
        }
    }];

    return responder ?: nil;
}

@end

@interface PDComponent ()

@property (nonatomic, strong) PDComponentView *view;
@property (nonatomic, weak) UIViewController *attachedController;

@end

@implementation PDComponent

- (instancetype)init {
    self = [super init];
    if (self) {
        _view = [[PDComponentView alloc] initWithComponent:self];
        _view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (__kindof PDViewModel *)getViewModel:(Class)viewModelClass {
    PDViewModelProvider *viewModelProvider = [self getViewModelProvider];
    return [viewModelProvider getViewModel:viewModelClass];
}

- (__kindof PDViewModel *)getSharedViewModelFromAttachedController:(Class)viewModelClass {
    PDViewModelProvider *viewModelProvider = [self.attachedController getViewModelProvider];
    return [viewModelProvider getViewModel:viewModelClass];
}

- (void)willAttachToController:(UIViewController *)newController {
    self.attachedController = newController;
    [[self.attachedController getLifecycle] addObserver:self];
}

- (void)didAttachToController {
    
}

- (void)willDetachFromController:(UIViewController *)oldController {
    
}

- (void)didDetachFromController {
    [[self.attachedController getLifecycle] removeObserver:self];
    self.attachedController = nil;
}

#pragma mark - Override Methods
- (UIResponder *)nextResponder {
    return self.attachedController.view;
}

@end

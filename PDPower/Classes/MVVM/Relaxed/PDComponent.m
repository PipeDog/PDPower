//
//  PDComponent.m
//  PDPower
//
//  Created by liang on 2022/3/26.
//

#import "PDComponent.h"
#import "PDViewModelProvider.h"

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

@end

@interface PDComponent ()

@property (nonatomic, strong) PDComponentView *view;

@end

@implementation PDComponent

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        _view = [[PDComponentView alloc] init];
        _view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (PDViewModel *)getViewModel:(Class)viewModelClass {
    PDViewModelProvider *viewModelProvider = [self.viewController getViewModelProvider];
    return [viewModelProvider getViewModel:viewModelClass];
}

#pragma mark - Override Methods
- (UIResponder *)nextResponder {
    return self.viewController;
}

@end
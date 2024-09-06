//
//  PDViewController.m
//  PDPower
//
//  Created by liang on 2022/3/26.
//

#import "PDViewController.h"
#import "PDComponent.h"
#import "PDViewModelProvider.h"

@interface PDViewController ()

@property (nonatomic, strong) NSMapTable<PDComponent *, NSArray *> *layoutMapTable;

@end

@implementation PDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)attachComponent:(PDComponent *)component {
    [component willAttachToController:self];
    
    component.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:component.view];
    
    NSArray *constraints = @[
        [component.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [component.view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
        [component.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [component.view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
    ];
    
    [NSLayoutConstraint activateConstraints:constraints];
    [self.layoutMapTable setObject:constraints forKey:component];
    
    [component didAttachToController];
}

- (void)detachComponent:(PDComponent *)component {
    [component willDetachFromController:self];
    
    component.view.translatesAutoresizingMaskIntoConstraints = YES;
    [component.view removeFromSuperview];
    
    NSArray *constraints = [self.layoutMapTable objectForKey:component];
    [NSLayoutConstraint deactivateConstraints:constraints];
    [self.layoutMapTable removeObjectForKey:component];
    
    [component didDetachFromController];
}

- (__kindof PDViewModel *)getViewModel:(Class)viewModelClass {
    PDViewModelProvider *viewModelProvider = [self getViewModelProvider];
    return [viewModelProvider getViewModel:viewModelClass];
}

#pragma mark - Getter Methods
- (NSMapTable<PDComponent *,NSArray *> *)layoutMapTable {
    if (!_layoutMapTable) {
        _layoutMapTable = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _layoutMapTable;
}

@end

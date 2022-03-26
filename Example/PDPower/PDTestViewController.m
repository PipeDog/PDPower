//
//  PDTestViewController.m
//  PDPower_Example
//
//  Created by liang on 2022/3/26.
//  Copyright © 2022 liang. All rights reserved.
//

#import "PDTestViewController.h"
#import "PDTestComponent.h"
#import "PDTestSharedViewModel.h"

@interface PDTestLifecycleObserver : NSObject <PDLifecycleObserver>

@end

@implementation PDTestLifecycleObserver

- (void)lifecycleOwner:(id<PDLifecycleOwner>)lifecycleOwner onStateChanged:(PDLifecycleState)state {
    NSLog(@"%s, state = %zd", __FUNCTION__, state);
}

@end

@interface PDTestViewController ()

@property (nonatomic, strong) PDTestComponent *component;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) PDTestLifecycleObserver *lifecycleObserver;

@end

@implementation PDTestViewController

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@">>>>> init 1111");
        _lifecycleObserver = [[PDTestLifecycleObserver alloc] init];
        [[self getLifecycle] addObserver:_lifecycleObserver];
        NSLog(@">>>>> init 2222");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"111: %s", __FUNCTION__);
    
    [self.view addSubview:self.button];

    self.component = [[PDTestComponent alloc] init];
    [self attachComponent:self.component];

    NSLog(@"222: %s", __FUNCTION__);

    PDViewModelProvider *viewModelProvider = [self getViewModelProvider];
    PDTestSharedViewModel *viewModel = [viewModelProvider getViewModel:[PDTestSharedViewModel class]];
    [viewModel doSomething];
    
    NSLog(@"333: %s", __FUNCTION__);
}

- (void)didClickControllerButton:(UIButton *)sender {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", PDObtainResponderChain(sender));
}

#pragma mark - Getter Methods
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(100, 200, 200, 50);
        _button.backgroundColor = [UIColor blueColor];
        [_button setTitle:@"Controller Button" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(didClickControllerButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end

//
//  PDTestComponent.m
//  PDPower_Example
//
//  Created by liang on 2022/3/26.
//  Copyright © 2022 liang. All rights reserved.
//

#import "PDTestComponent.h"


@interface PDTestComponent ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation PDTestComponent

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.view addSubview:self.button];
        self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.25f];
    }
    return self;
}

- (void)didAttachToController {
    
}

- (void)onPageWillAppear:(id<PDLifecycleOwner>)lifecycleOwner {
    NSLog(@"%s", __FUNCTION__);
}

- (void)didClickButton:(UIButton *)sender {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", PDObtainResponderChain(sender));
}

#pragma mark - Getter Methods
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(100, 100, 200, 50);
        _button.backgroundColor = [UIColor brownColor];
        [_button setTitle:@"Component Button" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end

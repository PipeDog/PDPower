//
//  PDTestViewController.m
//  PDPower_Example
//
//  Created by liang on 2022/3/26.
//  Copyright © 2022 liang. All rights reserved.
//

#import "PDTestViewController.h"
#import "PDTestComponent.h"

@interface PDTestViewController ()

@property (nonatomic, strong) PDTestComponent *component;
@property (nonatomic, strong) UIButton *button;

@end

@implementation PDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.button];

    self.component = [[PDTestComponent alloc] initWithController:self];
    [self addComponent:self.component];    
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

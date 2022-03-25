//
//  PDComponentViewController.m
//  PDPower_Example
//
//  Created by liang on 2022/3/26.
//  Copyright © 2022 liang. All rights reserved.
//

#import "PDComponentViewController.h"
#import <PDPower/PDPower.h>
#import "PDTestSharedViewModel.h"

@interface PDComponentViewController ()

@end

@implementation PDComponentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PDViewModelProvider *viewModelProvider = [self getSharedViewModelProvider];
    PDTestSharedViewModel *viewModel = [viewModelProvider viewModelByClass:[PDTestSharedViewModel class]];
    [viewModel doSomething];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  PDViewController.m
//  PDPower
//
//  Created by liang on 03/23/2022.
//  Copyright (c) 2022 liang. All rights reserved.
//

#import "PDMainViewController.h"
#import <PDPower/PDMediatorLiveData.h>
#import <PDPower/PDMutableLiveData.h>
#import <PDPower/PDViewModelProvider.h>
#import <PDPower/PDViewModel.h>
#import "PDComponentViewController.h"
#import "PDTestSharedViewModel.h"
#import "PDTestViewController.h"
#import <PDRouter.h>

@interface PDMainViewController ()

@property (nonatomic, strong) PDMediatorLiveData<NSString *> *mediatorLiveData;
@property (nonatomic, strong) PDMutableLiveData<NSString *> *liveData1;
@property (nonatomic, strong) PDMutableLiveData<NSString *> *liveData2;
@property (nonatomic, strong) PDMutableLiveData<NSString *> *liveData3;

@end

@implementation PDMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [PDRouter globalRouter].navigationController = self.navigationController;
        
    PDViewModelProvider *viewModelProvider = [self getViewModelProvider];
    PDTestSharedViewModel *viewModel = [viewModelProvider getViewModel:[PDTestSharedViewModel class]];
    [viewModel doSomething];

//    PDComponentViewController *componentVC = [[PDComponentViewController alloc] init];
//    [self addChildViewController:componentVC];
//    [self.view addSubview:componentVC.view];
    
    
    self.mediatorLiveData = [[PDMediatorLiveData alloc] init];
    self.liveData1 = [[PDMutableLiveData alloc] init];
    self.liveData2 = [[PDMutableLiveData alloc] init];
    self.liveData3 = [[PDMutableLiveData alloc] init];
    
    [self.mediatorLiveData addSource:self.liveData1 observer:^(NSString * _Nullable newValue) {
        NSLog(@"111 : newValue = %@", newValue);
    }];

    [self.mediatorLiveData addSource:self.liveData2 observer:^(NSString * _Nullable newValue) {
        NSLog(@"222 : newValue = %@", newValue);
    }];

    [self.mediatorLiveData addSource:self.liveData3 observer:^(NSString * _Nullable newValue) {
        NSLog(@"333 : newValue = %@", newValue);
    }];
        
    [self.mediatorLiveData observe:^(NSString * _Nullable newValue) {
        NSLog(@"mediator :: newValue = %@", newValue);
    } withLifecycleOwner:self];
    
    [self.liveData1 setValue:@"liveData1"];
    [self.liveData2 setValue:@"liveData2"];
    [self.liveData3 setValue:@"liveData3"];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self presentViewController:[UIViewController new] animated:YES completion:nil];
//    });
    
    UIResponder *responder = self.view;
    while (responder) {
        NSLog(@"responder class = %@", [responder class]);
        responder = [responder nextResponder];
    }
}

- (IBAction)didClickPush:(id)sender {
    [[PDRouter globalRouter] openURL:@"pipedog://open/page/test" params:@{@"name": @"xiao", @"age": @18}];
    
//    UIViewController *controller = [[PDTestViewController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

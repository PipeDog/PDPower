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

@interface PDMainViewController () <PDLiveDataObserver>

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
    
    PDViewModelProvider *viewModelProvider = [self getViewModelProvider];
    PDTestSharedViewModel *viewModel = [viewModelProvider getViewModel:[PDTestSharedViewModel class]];
    [viewModel doSomething];

    PDComponentViewController *componentVC = [[PDComponentViewController alloc] init];
    [self addChildViewController:componentVC];
    [self.view addSubview:componentVC.view];
    
    
    self.mediatorLiveData = [[PDMediatorLiveData alloc] init];
    self.liveData1 = [[PDMutableLiveData alloc] init];
    self.liveData2 = [[PDMutableLiveData alloc] init];
    self.liveData3 = [[PDMutableLiveData alloc] init];
    
//    [self.liveData1 observe:self withLifecycleOwner:self];
//    [self.liveData2 observe:self withLifecycleOwner:self];
//    [self.liveData3 observe:self withLifecycleOwner:self];

    [self.mediatorLiveData addSource:self.liveData1 observer:self];
//    [self.mediatorLiveData addSource:self.liveData2 observer:self];
//    [self.mediatorLiveData addSource:self.liveData3 observer:self];
    
    // 必须要先监听，否则
    [self.mediatorLiveData observe:self withLifecycleOwner:self];
    
    [self.liveData1 setValue:@"liveData1"];
    [self.liveData2 setValue:@"liveData2"];
    [self.liveData3 setValue:@"liveData3"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:[UIViewController new] animated:YES completion:nil];
    });
    
}

- (IBAction)didClickPush:(id)sender {
    UIViewController *controller = [[PDMainViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PDLiveDataObserver

- (void)liveData:(PDLiveData *)liveData onChanged:(id)newValue {
    if (liveData == self.liveData1) {
        NSLog(@"======================================");
        NSLog(@"newValue => %@", newValue);
        NSLog(@"self.liveData1 => %@", [self.liveData1 getValue]);
        NSLog(@"self.liveData2 => %@", [self.liveData2 getValue]);
        NSLog(@"self.liveData3 => %@", [self.liveData3 getValue]);
    }
}

@end

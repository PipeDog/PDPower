//
//  PDViewController.m
//  PDPower
//
//  Created by liang on 03/23/2022.
//  Copyright (c) 2022 liang. All rights reserved.
//

#import "PDMainViewController.h"

@interface PDMainViewController ()

@end

@implementation PDMainViewController

- (void)dealloc {
    NSLog(@">>>>> dealloc => %@", self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

@end

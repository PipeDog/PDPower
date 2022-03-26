//
//  PDTestSharedViewModel.m
//  PDPower_Example
//
//  Created by liang on 2022/3/26.
//  Copyright © 2022 liang. All rights reserved.
//

#import "PDTestSharedViewModel.h"

@implementation PDTestSharedViewModel

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)doSomething {
    NSLog(@"%s, %@", __FUNCTION__, self);
}

@end

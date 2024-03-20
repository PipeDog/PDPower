//
//  PDPageRouterPlugin.m
//  PDPower_Example
//
//  Created by liang on 2022/3/29.
//  Copyright © 2022 liang. All rights reserved.
//

#import "PDPageRouterInterceptor.h"

@implementation PDPageRouterInterceptor

- (BOOL)intercept:(id<PDRouterInterceptorChain>)chain {
    [chain proceed:chain.request];
    return YES;
}

@end

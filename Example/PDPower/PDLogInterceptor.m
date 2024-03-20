//
//  PDLogInterceptor.m
//  PDPower_Example
//
//  Created by liang on 2024/3/20.
//  Copyright © 2024 liang. All rights reserved.
//

#import "PDLogInterceptor.h"

@implementation PDLogInterceptor

- (BOOL)intercept:(id<PDRouterInterceptorChain>)chain {
    NSLog(@">>>>>> url: %@, params: %@.", chain.request.urlString, chain.request.parameters);
    return [chain proceed:chain.request];
}

@end

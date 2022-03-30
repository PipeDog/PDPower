//
//  PDPageRouterPlugin.m
//  PDPower_Example
//
//  Created by liang on 2022/3/29.
//  Copyright © 2022 liang. All rights reserved.
//

#import "PDPageRouterPlugin.h"

@implementation PDPageRouterPlugin

- (PDSkip2PageMode)getSkip2PageMode:(NSString *)pagepath withParams:(NSDictionary *)params {
    return PDSkip2PageModeTransitionPresent | PDSkip2PageModeAnimatedRequired;
}

@end

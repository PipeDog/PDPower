//
//  PDRouterRequest.m
//  PDPower
//
//  Created by liang on 2024/3/19.
//

#import "PDRouterRequest.h"

@implementation PDRouterRequest

- (instancetype)initWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters {
    self = [super init];
    if (self) {
        _urlString = [urlString copy];
        _parameters = [parameters copy];
    }
    return self;
}

@end

//
//  PDRouterUtils.m
//  PDPower
//
//  Created by liang on 2022/3/29.
//

#import "PDRouterUtils.h"

@implementation PDRouterUtils

+ (BOOL)validateRouteWithNode:(id)node pagepath:(NSString *)pagepath params:(NSDictionary *)params {    
    if (![node conformsToProtocol:@protocol(PDRouteNodeValidation)]) {
        return YES;
    }
    
    id<PDRouteNodeValidation> page = (id<PDRouteNodeValidation>)node;
    if (![page respondsToSelector:@selector(canRouteWithParams:)]) {
        return YES;
    }
    
    if ([page canRouteWithParams:params]) {
        return YES;
    }
    
    if ([page respondsToSelector:@selector(forwardRouteAction:params:)]) {
        [page forwardRouteAction:pagepath params:params];
    }
    
    return NO;
}

+ (NSString *)parseURL:(NSString *)urlString params:(NSDictionary *)params to:(NSDictionary * _Nullable __autoreleasing *)outParams {
    // 无效的参数
    if (!urlString.length) {
        if (outParams != nil) { *outParams = @{}; }
        return @"";
    }

    // 无效的 url 格式
    if (![self isValidURLFormat:urlString]) {
        if (outParams != nil) { *outParams = params; }
        return urlString;
    }
    
    // 有效的 url 格式
    NSURL *URL = [NSURL URLWithString:urlString];
    if (!URL) {
        URL = [NSURL URLWithString:[self encodeByURLQueryAllowedCharacterSet:urlString]];
    }

    NSString *fullPath = [self jointURLStringWithoutQueriesWithURL:URL];

    NSMutableDictionary *throwParams = [NSMutableDictionary dictionary];
    [throwParams addEntriesFromDictionary:params ?: @{}];
    [throwParams addEntriesFromDictionary:[self obtainQueryItems:URL]];
    if (outParams != nil) { *outParams = throwParams; }
    
    return fullPath;
}

// @eg:
//  input  :    scheme://www.test.com/%23/index?user=xiao&age=19
//  output :    scheme://www.test.com/#/index
+ (NSString *)jointURLStringWithoutQueriesWithURL:(NSURL *)URL {
    if (!URL || !URL.absoluteString.length) {
        return @"";
    }
    
    // scheme://host[:port] + path
    NSMutableString *noQueriesURLString = [NSMutableString string];
    [noQueriesURLString appendFormat:@"%@", URL.scheme ?: @""];
    [noQueriesURLString appendString:@"://"];
    [noQueriesURLString appendFormat:@"%@", URL.host ?: @""];

    if (URL.port) {
        [noQueriesURLString appendFormat:@":%lu", (unsigned long)[URL.port unsignedIntegerValue]];
    }

    [noQueriesURLString appendFormat:@"%@", URL.path ?: @""];
    return [noQueriesURLString copy];
}

+ (NSDictionary<NSString *, NSString *> *)obtainQueryItems:(NSURL *)URL {
    NSURLComponents *components = [NSURLComponents componentsWithString:URL.absoluteString];
    if (!components) {
        return @{};
    }
    
    NSArray<NSURLQueryItem *> *queryItems = components.queryItems;
    if (!queryItems.count) {
        return @{};
    }
    
    NSMutableDictionary<NSString *, id> *result = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *item in queryItems) {
        if (!item.name.length) {
            continue;
        }
        [result setValue:item.value forKey:item.name];
    }
    
    return [result copy];
}

+ (NSString *)encodeByURLQueryAllowedCharacterSet:(NSString *)urlString {
    if (!urlString.length) {
        return @"";
    }
    
    return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (BOOL)isValidURLFormat:(NSString *)urlString {
    if (!urlString.length) {
        return NO;
    }
    
    NSString *regex = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

@end

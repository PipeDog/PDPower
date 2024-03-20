//
//  PDAppDelegate.m
//  PDPower
//
//  Created by liang on 03/23/2022.
//  Copyright (c) 2022 liang. All rights reserved.
//

#import "PDAppDelegate.h"
#import <PDRouter.h>
#import "PDLogInterceptor.h"

@interface NSURL (_PDAdd)

@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *queryItems;

@end

@implementation NSURL (_PDAdd)

- (NSDictionary <NSString *, NSString *>*)queryItems {
    NSURLComponents *components = [NSURLComponents componentsWithString:self.absoluteString];
    if (!components) { return @{}; }
    
    NSArray<NSURLQueryItem *> *queryItems = components.queryItems;
    if (!queryItems.count) { return @{}; }
    
    NSMutableDictionary<NSString *, id> *queryDict = [NSMutableDictionary dictionary];
    
    for (NSURLQueryItem *item in queryItems) {
        if (!item.name.length/* || !item.value*/) continue;
        [queryDict setValue:item.value forKey:item.name];
    }
    return [queryDict copy];
}

@end

@interface NSString (_PDAdd)

- (NSString *)encodeWithURLQueryAllowedCharacterSet;
- (BOOL)isValidURL;

@end

@implementation NSString (_PDAdd)

- (NSString *)encodeWithURLQueryAllowedCharacterSet {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (BOOL)isValidURL {
    NSString *regex = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

@end

@implementation PDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[PDRouter globalRouter] addInterceptor:[[PDLogInterceptor alloc] init]];
    
    NSString *url = @"pdscheme://open/view/#/page?name=wangwang&age=24.5&url=https://www.baidu.com/#?inner1=value1&inner2=value2";
    BOOL isValidUrl = [url isValidURL];
    NSString *result = [url encodeWithURLQueryAllowedCharacterSet];
    NSURL *URL = [NSURL URLWithString:result];
    NSDictionary *items = [URL queryItems];
    
    NSLog(@"isValidUrl : %d, result = %@", isValidUrl, result);
    NSLog(@"URL : %@, items : %@", URL, items);
    NSLog(@"device version : %@", [UIDevice currentDevice].systemVersion);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

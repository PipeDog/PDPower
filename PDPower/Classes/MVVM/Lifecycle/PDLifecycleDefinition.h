//
//  PDLifecycleDefinition.h
//  Pods
//
//  Created by liang on 2022/3/24.
//

#ifndef PDLifecycleDefinition_h
#define PDLifecycleDefinition_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PDLifecycleState) {
    PDLifecycleStateUnknown = 0,
    PDLifecycleStatePageCreate = 1,
    PDLifecycleStatePageDidLoad = 2,
    PDLifecycleStatePageWillAppear = 3,
    PDLifecycleStatePageDidAppear = 4,
    PDLifecycleStatePageWillDisappear = 5,
    PDLifecycleStatePageDidDisappear = 6,
    PDLifecycleStatePageDealloc = 7,
};

FOUNDATION_EXPORT BOOL PDLifecycleIsActive(PDLifecycleState state);

#endif /* PDLifecycleDefinition_h */

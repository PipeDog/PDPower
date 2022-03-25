//
//  PDUIUtils.m
//  PDPower
//
//  Created by liang on 2022/3/24.
//

#import "PDUIUtils.h"

UIViewController *PDGetViewController(UIResponder *responder) {
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    }
    return nil;
}

UIViewController * PDGetRootViewController(UIResponder *responder) {
    UIViewController *controller = PDGetViewController(responder);
    if (!controller) {
        return nil;
    }
    
    while (controller.parentViewController) {
        controller = controller.parentViewController;
    }
    
    return controller;
}

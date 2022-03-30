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

NSArray<UIResponder *> *PDObtainResponderChain(UIResponder *responder) {
    NSMutableArray<UIResponder *> *chain = [NSMutableArray array];
    if (!responder) {
        return chain;
    }
    
    while (responder) {
        [chain addObject:responder];
        responder = [responder nextResponder];
    }
    
    return chain;
}

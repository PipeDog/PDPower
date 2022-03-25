//
//  PDBaseUtils.m
//  PDPower
//
//  Created by liang on 2022/3/23.
//

#import "PDBaseUtils.h"
#import <objc/runtime.h>

BOOL class_isSuperclass(Class superclass, Class subclass) {
    while (subclass != [NSObject class]) {
        if (subclass == superclass) {
            return YES;
        }
        subclass = class_getSuperclass(subclass);
    }
    return NO;
}

void class_exchangeInstanceMethod(Class cls, SEL sourceSel, SEL targetSel) {
    Method sourceMethod = class_getInstanceMethod(cls, sourceSel);
    Method targetMethod = class_getInstanceMethod(cls, targetSel);
    
    BOOL success = class_addMethod(cls, sourceSel,
                                   method_getImplementation(targetMethod),
                                   method_getTypeEncoding(targetMethod));
    if (success) {
        class_replaceMethod(cls, targetSel,
                            method_getImplementation(sourceMethod),
                            method_getTypeEncoding(sourceMethod));
    } else {
        method_exchangeImplementations(sourceMethod, targetMethod);
    }
}

void class_exchangeClassMethod(Class cls, SEL sourceSel, SEL targetSel) {
    Class metaClass = object_getClass(cls);
    class_exchangeInstanceMethod(metaClass, sourceSel, targetSel);
}

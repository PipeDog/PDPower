//
//  PDPowerDefine.h
//  Pods
//
//  Created by liang on 2022/3/28.
//

#ifndef PDPowerDefine_h
#define PDPowerDefine_h

/**
 * 提示子类必须调用父类方法，@eg:
 *
 * @interface PDAnimal : NSObject
 * - (void)eat PD_REQUIRED_INVOKE_SUPER;
 * @end
 *
 * @interface PDCat : PDAnimal
 * @end
 * @implementation PDCat
 * - (void)eat {
 *  [super eat];
 * }
 * @end
 */
#define PD_REQUIRED_INVOKE_SUPER __attribute__((objc_requires_super))

/**
 * 禁止被修饰类被子类继承，@eg:
 * PD_FINAL_CLASS @interface PDFinalClass : NSObject
 * - (void)method;
 * @end
 */
#define PD_FINAL_CLASS __attribute__((objc_subclassing_restricted))

/**
 * 子类必须重写被修饰的方法，@eg:
 * @interface PDAnimal : NSObject
 * - (void)eat PD_REQUIRED_OVERRIDE;
 * @end
 */
#define PD_REQUIRED_OVERRIDE // Just remind, nothing here.

/**
 * Synthsize a weak or strong reference.
 *
 * Example:
 *   @weakify(self)
 *   [self doSomething^{
 *       @strongify(self)
 *       if (!self) return;
 *       ...
 *   }];
 */
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


#endif /* PDPowerDefine_h */

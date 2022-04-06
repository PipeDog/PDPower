//
//  PDSpecialRouterPlugin.m
//  PDPower
//
//  Created by liang on 2022/3/29.
//

#import "PDSpecialRouterPlugin.h"
#import <mach-o/getsect.h>
#import <mach-o/dyld.h>
#import "PDModelKVMapper.h"
#import "PDRouterUtils.h"

@implementation PDSpecialRouterPlugin {
    NSMutableDictionary<NSString *, NSString *> *_class2PathMap;
    NSMutableDictionary<NSString *, NSString *> *_path2ClassMap;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _class2PathMap = [NSMutableDictionary dictionary];
        _path2ClassMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)load {
    @weakify(self)
    [self loadPagesWithHandler:^(NSString *pagepath, NSString *classname) {
        @strongify(self)
        if (!self) return;

        [self.router inject:pagepath eventHandler:^(NSDictionary * _Nullable params) {
            [self skip2Page:pagepath withParams:params];
        }];
    }];
}

- (PDSkip2PageMode)getSkip2PageMode:(NSString *)pagepath withParams:(NSDictionary *)params {
    return PDSkip2PageModeTransitionPush | PDSkip2PageModeAnimatedRequired;
}

- (BOOL)skip2Page:(NSString *)pagepath withParams:(NSDictionary *)params {
    NSString *classname = _path2ClassMap[pagepath];
    Class pageClass = NSClassFromString(classname);
    if (!pageClass) {
        return NO;
    }
    
    UIViewController *page = [[pageClass alloc] init];
    if (!page) {
        return NO;
    }
    
    if (![PDRouterUtils validateRouteWithNode:page pagepath:pagepath params:params]) {
        return NO;
    }

    PDModelSetValuesForProperties(page, params);
    PDSkip2PageMode mode = [self getSkip2PageMode:pagepath withParams:params];
    BOOL animated = (mode & PDSkip2PageModeAnimatedMask) == PDSkip2PageModeAnimatedRequired;
    
    NSAssert(self.navigationController, @"Set `navigationController` into `PDRouter` instance!");
    
    if ((mode & PDSkip2PageModeTransitionMask) == PDSkip2PageModeTransitionPush) {
        [self.navigationController pushViewController:page animated:animated];
    } else if ((mode & PDSkip2PageModeTransitionMask) == PDSkip2PageModeTransitionPresent) {
        page.modalPresentationStyle = UIModalPresentationOverFullScreen;
        page.modalPresentationCapturesStatusBarAppearance = YES;
        [self.navigationController.topViewController presentViewController:page animated:animated completion:nil];
    } else {
        NSAssert(NO, @"Invalid skip mode, check it!");
    }
    
    return YES;
}

#pragma mark - Private Methods
- (void)loadPagesWithHandler:(void (^)(NSString *pagepath, NSString *classname))registerHandler {
    for (uint32_t index = 0; index < _dyld_image_count(); index++) {
#ifdef __LP64__
        uint64_t addr = 0;
        const struct mach_header_64 *header = (const struct mach_header_64 *)_dyld_get_image_header(index);
        const struct section_64 *section = getsectbynamefromheader_64(header, "__DATA", "pd_exp_page");
#else
        uint32_t addr = 0;
        const struct mach_header *header = (const struct mach_header *)_dyld_get_image_header(index);
        const struct section *section = getsectbynamefromheader(header, "__DATA", "pd_exp_page");
#endif
        
        if (section == NULL) { continue; }
        
        if (header->filetype != MH_OBJECT && header->filetype != MH_EXECUTE && header->filetype != MH_DYLIB) {
            continue;
        }
        
        for (addr = section->offset; addr < section->offset + section->size; addr += sizeof(PDRoutePageName)) {
#ifdef __LP64__
            PDRoutePageName *page = (PDRoutePageName *)((uint64_t)header + addr);
#else
            PDRoutePageName *page = (PDRoutePageName *)((uint32_t)header + addr);
#endif
            if (!page) { continue; }
            
            NSString *pagepath = [NSString stringWithUTF8String:page->pagepath];
            NSString *classname = [NSString stringWithUTF8String:page->classname];
            _path2ClassMap[pagepath] = classname;
            _class2PathMap[classname] = pagepath;
            !registerHandler ?: registerHandler(pagepath, classname);
        }
    }
}

- (void)registerHandlerWithPagepath:(NSString *)pagepath classname:(NSString *)classname {
    @weakify(self)
    [self.router inject:pagepath eventHandler:^(NSDictionary * _Nullable params) {
        @strongify(self)
        if (self) return;
        [self skip2Page:pagepath withParams:params];
    }];
}

#pragma mark - Getter Methods
- (NSDictionary<NSString *,NSString *> *)path2ClassMap {
    return _path2ClassMap;
}

- (NSDictionary<NSString *,NSString *> *)class2PathMap {
    return _class2PathMap;
}

@end

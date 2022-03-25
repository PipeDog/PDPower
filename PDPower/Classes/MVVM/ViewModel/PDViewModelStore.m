//
//  PDViewModelStore.m
//  PDPower
//
//  Created by liang on 2022/3/23.
//

#import "PDViewModelStore.h"

@interface PDViewModelStore ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, PDViewModel *> *viewModelMap;

@end

@implementation PDViewModelStore

- (instancetype)init {
    self = [super init];
    if (self) {
        _viewModelMap = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public Methods
- (PDViewModel *)viewModelForKey:(NSString *)key {
    return _viewModelMap[key];
}

- (void)setViewModel:(PDViewModel *)viewModel forKey:(NSString *)key {
    _viewModelMap[key] = viewModel;
}

- (void)removeAllViewModels {
    [_viewModelMap removeAllObjects];
}

@end

@implementation PDViewModelStore (Subscript)

- (PDViewModel *)objectForKeyedSubscript:(NSString *)key {
    return [self viewModelForKey:key];
}

- (void)setObject:(PDViewModel *)obj forKeyedSubscript:(NSString *)key {
    [self setViewModel:obj forKey:key];
}

@end

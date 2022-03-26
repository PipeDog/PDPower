//
//  PDMediatorLiveData.m
//  PDPower
//
//  Created by liang on 2022/3/25.
//

#import "PDMediatorLiveData.h"
#import "PDLiveData.h"
#import "PDLiveData+Internal.h"

@interface PDMediatorLiveDataSource : NSObject

@property (nonatomic, weak) PDLiveData *liveData;
@property (nonatomic, copy) void (^observer)(id);
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, copy) void (^onChangedBlock)(id);

@end

@implementation PDMediatorLiveDataSource

- (instancetype)initWithLiveData:(PDLiveData *)liveData observer:(void (^)(id))observer {
    self = [super init];
    if (self) {
        _version = PDLiveDataValueStartVersion;
        _liveData = liveData;
        _observer = observer;
        
    }
    return self;
}

- (void)plug {
    [self.liveData observeForever:self.onChangedBlock];
}

- (void)unplug {
    [self.liveData removeObserver:self.onChangedBlock];
}

- (void (^)(id))onChangedBlock {
    if (!_onChangedBlock) {
        __weak typeof(self) weakSelf = self;
        _onChangedBlock = ^(id newValue) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            
            if (strongSelf.version == [strongSelf.liveData getVersion]) {
                return;
            }
            
            strongSelf.version = [strongSelf.liveData getVersion];
            !strongSelf.observer ?: strongSelf.observer(newValue);
        };
    }
    return _onChangedBlock;
}

@end

@interface PDMediatorLiveData ()

@property (nonatomic, strong) NSMapTable<PDLiveData *, PDMediatorLiveDataSource *> *sourceMap;

@end

@implementation PDMediatorLiveData

- (instancetype)init {
    self = [super init];
    if (self) {
        _sourceMap = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

#pragma mark - Public Methods
- (void)addSource:(PDLiveData *)source observer:(void (^)(id _Nullable))observer {
    PDMediatorLiveDataSource *existing = [self.sourceMap objectForKey:source];
    PDMediatorLiveDataSource *e = [[PDMediatorLiveDataSource alloc] initWithLiveData:source observer:observer];
    [_sourceMap setObject:e forKey:source];
    
    if (existing && existing.observer != observer) {
        [[NSException exceptionWithName:@"PDMediatorLiveDataException"
                                 reason:@"This source was already added with the different observer!"
                               userInfo:nil] raise];
    }
    if (existing) {
        return;
    }
    if ([self hasActiveObservers]) {
        [e plug];
    }
}

- (void)removeSource:(PDLiveData *)source {
    PDMediatorLiveDataSource *e = [self.sourceMap objectForKey:source];
    if (!e) {
        return;
    }
    
    [e unplug];
    [self.sourceMap removeObjectForKey:source];
}

#pragma mark - Override Methods
- (void)onActive {
    PDMediatorLiveDataSource *source;
    NSEnumerator *objectEnumerator = [self.sourceMap objectEnumerator];
    
    while (source = [objectEnumerator nextObject]) {
        [source plug];
    }
}

- (void)onInactive {
    PDMediatorLiveDataSource *source;
    NSEnumerator *objectEnumerator = [self.sourceMap objectEnumerator];
    
    while (source = [objectEnumerator nextObject]) {
        [source unplug];
    }
}

@end

//
//  PDMediatorLiveData.m
//  PDPower
//
//  Created by liang on 2022/3/25.
//

#import "PDMediatorLiveData.h"
#import "PDLiveData.h"
#import "PDLiveData+Internal.h"

@interface PDMediatorLiveDataSource : NSObject <PDLiveDataObserver>

@property (nonatomic, weak) PDLiveData *liveData;
@property (nonatomic, weak) id<PDLiveDataObserver> observer;
@property (nonatomic, assign) NSInteger version;

@end

@implementation PDMediatorLiveDataSource

- (instancetype)initWithLiveData:(PDLiveData *)liveData observer:(id<PDLiveDataObserver>)observer {
    self = [super init];
    if (self) {
        _version = PDLiveDataValueStartVersion;
        _liveData = liveData;
        _observer = observer;
    }
    return self;
}

- (void)plug {
    [self.liveData observeForever:self];
}

- (void)unplug {
    [self.liveData removeObserver:self];
}

- (void)liveData:(PDLiveData *)liveData onChanged:(id)newValue {
    if (self.version == [self.liveData getVersion]) {
        return;
    }
    
    self.version = [self.liveData getVersion];
    [self.observer liveData:self.liveData onChanged:newValue];
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
- (void)addSource:(PDLiveData *)source observer:(id<PDLiveDataObserver>)observer {
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

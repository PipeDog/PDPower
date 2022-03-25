//
//  PDLiveData.m
//  PDPower
//
//  Created by liang on 2022/3/25.
//

#import "PDLiveData.h"
#import "PDLifecycleOwner.h"
#import "PDLifecycle.h"
#import "PDLifecycleObserver.h"

static NSInteger const PDLiveDataValueStartVersion = -1;

static id PDLiveDataDefaultValue(void) {
    static NSObject *object;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[NSObject alloc] init];
    });
    return object;
}


@interface PDObserverWrapper : NSObject

@property (nonatomic, weak) PDLiveData *liveData;
@property (nonatomic, weak) id<PDLiveDataObserver> observer;
@property (nonatomic, assign, getter=isActive) BOOL active;
@property (nonatomic, assign) NSInteger lastVersion;

- (instancetype)initWithLiveData:(PDLiveData *)liveData observer:(id<PDLiveDataObserver>)observer;
- (BOOL)shouldBeActive;
- (BOOL)isAttachTo:(UIResponder<PDLifecycleOwner> *)lifecycleOwner;
- (void)detachObserver;
- (void)activeStateChanged:(BOOL)isActive;

@end

@interface PDLifecycleBoundObserver : PDObserverWrapper <PDLifecycleObserver>

@property (nonatomic, weak) UIResponder<PDLifecycleOwner> *lifecycleOwner;

- (instancetype)initWithLiveData:(PDLiveData *)liveData
                        observer:(id<PDLiveDataObserver>)observer
                  lifecycleOwner:(UIResponder<PDLifecycleOwner> *)lifecycleOwner;

@end

@interface PDLifecycleAlwaysActiveObserver : PDObserverWrapper

@end

@interface PDLiveData ()

@property (nonatomic, assign) NSInteger activeCount;
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) id bindValue;
@property (nonatomic, strong) NSMapTable<id<PDLiveDataObserver>, PDObserverWrapper *> *observerTable;
@property (nonatomic, assign, getter=isDispatchingValue) BOOL dispatchingValue;
@property (nonatomic, assign, getter=isDispatchInvalidated) BOOL dispatchInvalidated;

- (void)onActive;
- (void)onInactive;
- (void)dispatchingValue:(PDObserverWrapper *)observer;

@end

@implementation PDLiveData

- (instancetype)init {
    self = [super init];
    if (self) {
        _bindValue = PDLiveDataDefaultValue();
        _version = PDLiveDataValueStartVersion;
        _observerTable = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

#pragma mark - Public Methods
- (void)observeForever:(id<PDLiveDataObserver>)observer {
    PDObserverWrapper *existing = [self.observerTable objectForKey:observer];
    PDLifecycleAlwaysActiveObserver *wrapper = [[PDLifecycleAlwaysActiveObserver alloc] initWithLiveData:self
                                                                                                observer:observer];
    [self.observerTable setObject:wrapper forKey:observer];

    if (existing && [existing isKindOfClass:[PDLifecycleAlwaysActiveObserver class]]) {
        [[NSException exceptionWithName:@"PDLiveDataException"
                                 reason:@"Cannot add the same observer with different lifecycles!"
                               userInfo:nil] raise];
    }
    if (existing) {
        return;
    }
    
    if (self.bindValue != PDLiveDataDefaultValue()) {
        [wrapper activeStateChanged:YES];
    }
}

- (void)observe:(id<PDLiveDataObserver>)observer withLifecycleOwner:(UIResponder<PDLifecycleOwner> *)lifecycleOwner {
    if ([[lifecycleOwner getLifecycle] getCurrentState] == PDLifecycleStatePageDealloc) {
        return;
    }

    PDObserverWrapper *existing = [self.observerTable objectForKey:observer];
    PDLifecycleBoundObserver *wrapper = [[PDLifecycleBoundObserver alloc] initWithLiveData:self
                                                                                  observer:observer
                                                                            lifecycleOwner:lifecycleOwner];
    [self.observerTable setObject:wrapper forKey:observer];

    if (existing && ![existing isAttachTo:lifecycleOwner]) {
        [[NSException exceptionWithName:@"PDLiveDataException"
                                 reason:@"Cannot add the same observer with different lifecycles!"
                               userInfo:nil] raise];
    }
    if (existing) {
        return;
    }
    
    PDLifecycle *lifecycle = [lifecycleOwner getLifecycle];
    [lifecycle addObserver:wrapper];
    
    if (PDLifecycleIsActive([lifecycle getCurrentState])) {
        [wrapper activeStateChanged:YES];
    }
}

- (void)removeObserver:(id<PDLiveDataObserver>)observer {
    PDObserverWrapper *wrapper = [self.observerTable objectForKey:observer];
    if (!wrapper) {
        return;
    }
    
    [wrapper detachObserver];
    [wrapper activeStateChanged:NO];
    [self.observerTable removeObjectForKey:observer];
}

- (void)removeObservers:(UIResponder<PDLifecycleOwner> *)lifecycleOwner {
    NSDictionary *observers = self.observerTable.dictionaryRepresentation;
    NSArray<id<PDLiveDataObserver>> *allKeys = observers.allKeys;

    for (id<PDLiveDataObserver> observer in allKeys) {
        PDObserverWrapper *wrapper = observers[observer];
        if ([wrapper isAttachTo:lifecycleOwner]) {
            [self removeObserver:observer];
        }
    }
}

- (void)setValue:(id)value {
    self.version += 1;
    self.bindValue = value;
    [self dispatchingValue:nil];
}

- (id)getValue {
    return _bindValue != PDLiveDataDefaultValue() ? _bindValue : nil;
}

#pragma mark - Private Methods
- (void)onActive {
    
}

- (void)onInactive {
    
}

- (void)dispatchingValue:(PDObserverWrapper *)initiator {
    if (self.isDispatchingValue) {
        self.dispatchInvalidated = YES;
        return;
    }
    
    do {
        self.dispatchInvalidated = NO;
        
        if (initiator) {
            [self considerNotify:initiator];
            initiator = nil;
        } else {
            NSDictionary *observers = self.observerTable.dictionaryRepresentation;
            NSArray<id<PDLiveDataObserver>> *allKeys = observers.allKeys;

            for (id<PDLiveDataObserver> observer in allKeys) {
                PDObserverWrapper *wrapper = observers[observer];
                [self considerNotify:wrapper];
                
                if (self.isDispatchInvalidated) {
                    break;
                }
            }
        }
    } while (self.isDispatchInvalidated);
    
    self.dispatchingValue = NO;
}

- (void)considerNotify:(PDObserverWrapper *)observer {
    if (!observer.isActive) {
        return;
    }
    if (![observer shouldBeActive]) {
        [observer activeStateChanged:NO];
        return;
    }
    if (observer.lastVersion >= self.version) {
        return;
    }
    
    observer.lastVersion = self.version;
    [observer.observer liveData:self onChanged:self.bindValue];
}

@end

@implementation PDObserverWrapper

- (instancetype)initWithLiveData:(PDLiveData *)liveData observer:(id<PDLiveDataObserver>)observer {
    self = [super init];
    if (self) {
        _liveData = liveData;
        _observer = observer;
    }
    return self;
}

- (BOOL)shouldBeActive {
    NSAssert(NO, @"Override this method in subclass!");
    return NO;
}

- (BOOL)isAttachTo:(UIResponder<PDLifecycleOwner> *)lifecycleOwner {
    return NO;
}

- (void)detachObserver {
    
}

- (void)activeStateChanged:(BOOL)isActive {
    if (isActive == self.isActive) {
        return;
    }
    
    self.active = isActive;
    BOOL wasInactive = self.liveData.activeCount == 0;
    self.liveData.activeCount += self.isActive ? 1 : -1;
    
    if (wasInactive && self.isActive) {
        [self.liveData onActive];
    }
    
    if (self.liveData.activeCount == 0 && !self.isActive) {
        [self.liveData onInactive];
    }
    
    if (self.isActive) {
        [self.liveData dispatchingValue:self];
    }
}

@end

@implementation PDLifecycleBoundObserver

- (instancetype)initWithLiveData:(PDLiveData *)liveData
                        observer:(id<PDLiveDataObserver>)observer
                  lifecycleOwner:(UIResponder<PDLifecycleOwner> *)lifecycleOwner {
    self = [super initWithLiveData:liveData observer:observer];
    if (self) {
        _lifecycleOwner = lifecycleOwner;
    }
    return self;
}

- (BOOL)shouldBeActive {
    return PDLifecycleIsActive([[self.lifecycleOwner getLifecycle] getCurrentState]);
}

- (void)lifecycleOwner:(id<PDLifecycleOwner>)lifecycleOwner onStateChanged:(PDLifecycleState)state {
    if ([[self.lifecycleOwner getLifecycle] getCurrentState] == PDLifecycleStatePageDealloc) {
        [self.liveData removeObserver:self.observer];
        return;
    }
    
    [self activeStateChanged:[self shouldBeActive]];
}

- (BOOL)isAttachTo:(UIResponder<PDLifecycleOwner> *)lifecycleOwner {
    return self.lifecycleOwner == lifecycleOwner;
}

- (void)detachObserver {
    [[self.lifecycleOwner getLifecycle] removeObserver:self];
}

@end

@implementation PDLifecycleAlwaysActiveObserver

- (BOOL)shouldBeActive {
    return YES;
}

@end

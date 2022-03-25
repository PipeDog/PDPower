//
//  PDMediatorLiveData.m
//  PDPower
//
//  Created by liang on 2022/3/25.
//

#import "PDMediatorLiveData.h"
#import "PDLiveData.h"

@interface PDMediatorLiveDataSource : NSObject <PDLiveDataObserver>

@property (nonatomic, weak) PDLiveData *liveData;
@property (nonatomic, weak) id<PDLiveDataObserver> observer;

@end

@implementation PDMediatorLiveDataSource

- (instancetype)initWithLiveData:(PDLiveData *)liveData observer:(id<PDLiveDataObserver>)observer {
    self = [super init];
    if (self) {
        _liveData = liveData;
        _observer = observer;
    }
    return self;
}

@end

@interface PDMediatorLiveData ()

@property (nonatomic, strong) NSMutableDictionary *sourceMap;

@end

@implementation PDMediatorLiveData



@end

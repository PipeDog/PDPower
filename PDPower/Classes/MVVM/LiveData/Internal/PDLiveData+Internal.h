//
//  PDLiveData+Internal.h
//  PDPower
//
//  Created by liang on 2022/3/25.
//

#import "PDLiveData.h"

NS_ASSUME_NONNULL_BEGIN

static NSInteger const PDLiveDataValueStartVersion = -1;

@interface PDLiveData ()

- (void)setValue:(id)value;
- (id)getValue;
- (void)onActive;
- (void)onInactive;

@end

NS_ASSUME_NONNULL_END

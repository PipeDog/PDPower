//
//  PDTestViewController.h
//  PDPower_Example
//
//  Created by liang on 2022/3/26.
//  Copyright © 2022 liang. All rights reserved.
//

#import <PDPower/PDPower.h>

NS_ASSUME_NONNULL_BEGIN

PD_EXPORT_PAGE("pipedog://open/page/test", PDTestViewController)

@interface PDTestViewController : PDViewController

// 这两个属性写在这里只是为了更直观，实际上你应该将这两个属性放到 .m 文件中，不应该对外暴露
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end

NS_ASSUME_NONNULL_END

//
//  TransducerViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "DataCenterModel.h"

@interface TransducerViewController : EMIBaseViewController
- (void)setViewValuesWithModel:(DataCenterModel *)model;

+ (NSString *)getHMS:(NSString *)str;
@end

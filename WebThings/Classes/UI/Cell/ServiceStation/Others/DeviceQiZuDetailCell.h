//
//  DeviceQiZuDetailCell.h
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"
#import "ServiceCenterBaseModel.h"

@interface DeviceQiZuDetailCell : EMINormalTableViewCell
- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model;

- (void)setAction1:(SEL)action1 Action2:(SEL)action2 target:(id)target;
@end

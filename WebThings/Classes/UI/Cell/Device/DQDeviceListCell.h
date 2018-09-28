//
//  DQDeviceListCell.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//  项目管理-设备cell

#import <UIKit/UIKit.h>
#import "DeviceModel.h"

@interface DQDeviceListCell : MGSwipeTableCell
- (void)configDeviceListWithModel:(DeviceModel *)model;
@end

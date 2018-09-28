//
//  DriversHomeCell.h
//  WebThings
//
//  Created by machinsight on 2017/7/24.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseTableViewCell.h"
#import "DeviceModel.h"

@interface DriversHomeCell : EMIBaseTableViewCell
- (void)setViewWithValues:(DeviceModel *)model;
@end

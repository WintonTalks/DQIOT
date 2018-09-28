//
//  DeviceWHDetailCell.h
//  WebThings
//  设备维保
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"

@interface DeviceWHDetailCell : EMINormalTableViewCell
//- (void)setWhnrLabText:(NSString *)str;

//- (CGFloat)cellHeight;

- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model;

//servicefinishbtn
- (void)setAction1:(SEL)action1 target:(id)target;
@end

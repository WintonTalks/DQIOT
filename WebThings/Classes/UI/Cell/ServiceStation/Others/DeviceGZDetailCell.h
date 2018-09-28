//
//  DeviceGZDetailCell.h
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"

@interface DeviceGZDetailCell : EMINormalTableViewCell
- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model;

//servicefinishbtn
- (void)setAction1:(SEL)action1 target:(id)target;

- (CGFloat)cellHeight;
@end

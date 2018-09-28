//
//  BaoHuiCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//  驳回cell

#import "EMINormalTableViewCell.h"
#import "ServiceCenterBaseModel.h"

@interface BaoHuiCell : EMINormalTableViewCell
- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model;
@end

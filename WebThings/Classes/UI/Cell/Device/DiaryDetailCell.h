//
//  DiaryDetailCell.h
//  WebThings
//
//  Created by machinsight on 2017/7/6.
//  Copyright © 2017年 machinsight. All rights reserved.
//  设备报告cell

#import <UIKit/UIKit.h>
#import "CheckModel.h"

@interface DiaryDetailCell : UITableViewCell
- (void)setViewValuesWithModel:(CheckModel *)model;

@end

//
//  WorkDeskBaseCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//  工作台cell 基类，用于滑动删除

#import "EMINormalTableViewCell.h"
#import "WorkDeskDetailView.h"
#import "DWMsgModel.h"


@interface WorkDeskBaseCell : EMINormalTableViewCell
- (void)setViewValuesWithModel:(DWMsgModel *)model;
- (CGFloat)cellOpenHeightWithModel:(DWMsgModel *)model;

- (CGFloat)cellCloseHeight;
@end

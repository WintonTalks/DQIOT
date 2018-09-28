//
//  WorkDeskListCell.h
//  WebThings
//
//  Created by machinsight on 2017/7/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"
#import "DWMsgModel.h"

@interface WorkDeskListCell : EMINormalTableViewCell
- (void)setViewValues:(DWMsgModel *)model;

- (void)hideCardV;//影藏卡片背景

- (void)judgeIsYiDu;//判断是否已读
@end

//
//  WorkersButtonCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/16.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"
#import "DWMsgModel.h"

@class WorkersButtonCell;
@protocol WorkersButtonCellDelegate <NSObject>

- (void)leftBtnClickedWithIndex:(NSInteger)index WithModel:(DWMsgModel *)model;
- (void)rightBtnClickedWithIndex:(NSInteger)index WithModel:(DWMsgModel *)model;

@end
@interface WorkersButtonCell : EMINormalTableViewCell
@property (nonatomic,weak) id<WorkersButtonCellDelegate> delegate;

@property NSInteger index;

- (void)setViewValues:(DWMsgModel *)model;
@end

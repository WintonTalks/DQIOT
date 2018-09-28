//
//  WorkersBTnCell.h
//  WebThings
//
//  Created by machinsight on 2017/7/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINormalTableViewCell.h"
#import "DWMsgModel.h"
@class WorkersBTnCell;
@protocol WorkersBTnCellDelegate <NSObject>

- (void)leftBtnClickedWithIndex:(NSInteger)index WithModel:(DWMsgModel *)model;
- (void)rightBtnClickedWithIndex:(NSInteger)index WithModel:(DWMsgModel *)model;

@end
@interface WorkersBTnCell : EMINormalTableViewCell
@property (nonatomic, weak) id<WorkersBTnCellDelegate> delegate;

@property NSInteger index;

- (void)setViewValues:(DWMsgModel *)model;
@end

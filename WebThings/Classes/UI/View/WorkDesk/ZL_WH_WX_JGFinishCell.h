//
//  ZL_WH&WX&JGFinishCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//  租赁方 维保、维修、加高已完成cell

#import "WorkDeskBaseCell.h"


@protocol ZL_WH_WX_JGFinishCellDelegate <NSObject>

@optional
//驳回 （已完成）
- (void)bohuiBtnClicked;
@end
@interface ZL_WH_WX_JGFinishCell : WorkDeskBaseCell
@property (nonatomic,weak) id<ZL_WH_WX_JGFinishCellDelegate> zl_WH_WX_JGFinishCellDelegate;
+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<ZL_WH_WX_JGFinishCellDelegate>)delegate;
@end

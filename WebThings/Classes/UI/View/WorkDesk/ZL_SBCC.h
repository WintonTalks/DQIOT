//
//  ZL_SBCC.h
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//  租赁方设备拆除

#import "WorkDeskBaseCell.h"
@protocol ZL_SBCCDelegate <NSObject>

@optional

//确认（已核实并发起）
- (void)querenBtnClicked;
//驳回 （已完成）
- (void)bohuiBtnClicked;

@end
@interface ZL_SBCC : WorkDeskBaseCell
@property (nonatomic, weak) id<ZL_SBCCDelegate> zl_SBCCDelegate;
+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<ZL_SBCCDelegate>)delegate;
@end

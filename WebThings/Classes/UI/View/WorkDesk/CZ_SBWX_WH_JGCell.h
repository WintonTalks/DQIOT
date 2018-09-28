//
//  CZ_SBWX&WH&JGCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//  承租方设备修护、维修、加高cell

#import "WorkDeskBaseCell.h"
@protocol CZ_SBWX_WH_JGCellDelegate <NSObject>

@optional

//确认（已核实并发起）
- (void)querenBtnClicked;
//驳回 （已完成）
- (void)bohuiBtnClicked;

@end
@interface CZ_SBWX_WH_JGCell : WorkDeskBaseCell
@property(nonatomic,strong)id<CZ_SBWX_WH_JGCellDelegate> cz_SBWX_WH_JGDelegate;
+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<CZ_SBWX_WH_JGCellDelegate>)delegate;
@end

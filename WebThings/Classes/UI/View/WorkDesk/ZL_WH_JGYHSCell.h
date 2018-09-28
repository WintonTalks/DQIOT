//
//  ZL_WH&JGCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "WorkDeskBaseCell.h"

@protocol ZL_WH_JGYHSCellDelegate <NSObject>

@optional

//确认（已核实并发起）
- (void)querenBtnClicked;


@end
@interface ZL_WH_JGYHSCell : WorkDeskBaseCell
@property (nonatomic,weak) id<ZL_WH_JGYHSCellDelegate> zl_WH_JGYHSCellDelegate;
+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<ZL_WH_JGYHSCellDelegate>)delegate;
@end

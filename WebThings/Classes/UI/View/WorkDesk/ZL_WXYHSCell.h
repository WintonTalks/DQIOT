//
//  ZL_WXYHSCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "WorkDeskBaseCell.h"

@protocol ZL_WXYHSCellDelegate <NSObject>

@optional

//确认（已核实并发起）
- (void)querenBtnClicked;


@end

@interface ZL_WXYHSCell : WorkDeskBaseCell
@property (nonatomic,weak) id<ZL_WXYHSCellDelegate> zl_WXYHSCellDelegate;
+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<ZL_WXYHSCellDelegate>)delegate;
@end

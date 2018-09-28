//
//  CZ_DDQRCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//  承租方订单确认

#import "WorkDeskBaseCell.h"
@protocol CZ_DDQRCellDelegate <NSObject>

@optional

//确认（已核实并发起）
- (void)querenBtnClicked;
//驳回 （已完成）
- (void)bohuiBtnClicked;

@end
@interface CZ_DDQRCell : WorkDeskBaseCell
@property (nonatomic,weak) id<CZ_DDQRCellDelegate> cz_DDQRCellDelegate;
+ (id)cellWithTableView:(UITableView *)tableview delegate:(id<CZ_DDQRCellDelegate>)delegate;
@end

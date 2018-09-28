//
//  GZTZCell.h
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//  承租方 故障通知cell

#import "WorkDeskBaseCell.h"

@protocol GZTZCellDelegate <NSObject>

@optional
//故障通知点击(填写维修单)
- (void)gztzBtnClicked;
@end
@interface GZTZCell : WorkDeskBaseCell
@property (nonatomic, weak) id<GZTZCellDelegate> gztzDelegate;
+ (id)cellWithTableView:(UITableView *)tableview  delegate:(id<GZTZCellDelegate>)delegate;
@end

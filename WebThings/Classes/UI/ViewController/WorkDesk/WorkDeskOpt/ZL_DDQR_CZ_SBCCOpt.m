//
//  ZL_DDQR_CZ_SBCCOpt.m
//  WebThings
//
//  Created by machinsight on 2017/8/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ZL_DDQR_CZ_SBCCOpt.h"
#import "ZL_DDQR_CZ_SBCCCell.h"

@implementation ZL_DDQR_CZ_SBCCOpt
-(UITableViewCell *) getTableViewCell:(NotifyDetailViewController *)vc tableView:(UITableView *)tableView DWMsgData:(DWMsgModel *)model{
    ZL_DDQR_CZ_SBCCCell *cell = [ZL_DDQR_CZ_SBCCCell cellWithTableView:tableView];
    [cell setViewValuesWithModel:model];
//    model.closeCellHeight = [cell cellCloseHeight];
    model.openCellHeight = [cell cellOpenHeightWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end

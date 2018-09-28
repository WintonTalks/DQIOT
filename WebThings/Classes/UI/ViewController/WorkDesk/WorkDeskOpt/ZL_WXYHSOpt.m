//
//  ZL_WXYHSOpt.m
//  WebThings
//
//  Created by machinsight on 2017/8/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ZL_WXYHSOpt.h"
#import "ZL_WXYHSCell.h"
#import "ChooseMaintainers.h"
@interface ZL_WXYHSOpt()
@property(nonatomic,strong)NotifyDetailViewController *vc;
@property(nonatomic,strong)DWMsgModel *model;
@end
@implementation ZL_WXYHSOpt
-(UITableViewCell *) getTableViewCell:(NotifyDetailViewController *)vc tableView:(UITableView *)tableView DWMsgData:(DWMsgModel *)model{
    _vc = vc;
    _model = model;
    ZL_WXYHSCell *cell = [ZL_WXYHSCell cellWithTableView:tableView delegate:self];
    [cell setViewValuesWithModel:model];
//    model.closeCellHeight = [cell cellCloseHeight];
    model.openCellHeight = [cell cellOpenHeightWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//已核实并发起维修
- (void)querenBtnClicked{
    ChooseMaintainers *VC = [AppUtils VCFromSB:@"Main" vcID:@"ChooseMaintainersVC"];
    VC.deviceid = _model.deviceid;
    VC.billid = _model.noticeid;
    VC.projectid = _model.projectid;
    VC.basedelegate = _vc;
    VC.thistitle = @"选择维修人员";
    [_vc.navigationController pushViewController:VC animated:YES];
}
@end

//
//  ZL_WH_JGYHSOpt.m
//  WebThings
//
//  Created by machinsight on 2017/8/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ZL_WH_JGYHSOpt.h"
#import "ZL_WH_JGYHSCell.h"
#import "WorkDeskStrConfig.h"
#import "ChooseMaintainers.h"
@interface ZL_WH_JGYHSOpt()
@property(nonatomic,strong)NotifyDetailViewController *vc;
@property(nonatomic,strong)DWMsgModel *model;
@end
@implementation ZL_WH_JGYHSOpt
-(UITableViewCell *) getTableViewCell:(NotifyDetailViewController *)vc tableView:(UITableView *)tableView DWMsgData:(DWMsgModel *)model{
    _vc = vc;
    _model = model;
    ZL_WH_JGYHSCell *cell = [ZL_WH_JGYHSCell cellWithTableView:tableView delegate:self];
    [cell setViewValuesWithModel:model];
//    model.closeCellHeight = [cell cellCloseHeight];
    model.openCellHeight = [cell cellOpenHeightWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//已核实并发起维保、加高
- (void)querenBtnClicked{
    ChooseMaintainers *VC = [AppUtils VCFromSB:@"Main" vcID:@"ChooseMaintainersVC"];
    VC.deviceid = _model.deviceid;
    VC.billid = _model.noticeid;
    VC.projectid = _model.projectid;
    VC.basedelegate = _vc;
    if ([_model.noticetype isEqualToString:Notice_SBWH]) {
        VC.thistitle = @"选择维保人员";
        
    }else if(([_model.noticetype isEqualToString:Notice_SBJG])){
        VC.thistitle = @"选择加高人员";
    }
    
    [_vc.navigationController pushViewController:VC animated:YES];
}
@end

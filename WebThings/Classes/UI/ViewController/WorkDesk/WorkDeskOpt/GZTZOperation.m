//
//  GZTZOperation.m
//  WebThings
//
//  Created by machinsight on 2017/8/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "GZTZOperation.h"
#import "GZTZCell.h"
#import "AddDeviceWXListViewController.h"
@interface GZTZOperation()
@property(nonatomic,strong)NotifyDetailViewController *vc;
@property(nonatomic,strong)DWMsgModel *model;
@end
@implementation GZTZOperation
- (UITableViewCell *) getTableViewCell:(NotifyDetailViewController *)vc tableView:(UITableView *)tableView DWMsgData:(DWMsgModel *)model{
    _vc = vc;
    _model = model;
//    NSLog(@"%@",_model);
    GZTZCell *cell = [GZTZCell cellWithTableView:tableView delegate:self];    
    [cell setViewValuesWithModel:model];
//    model.closeCellHeight = [cell cellCloseHeight];
    model.openCellHeight = [cell cellOpenHeightWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//故障通知点击
- (void)gztzBtnClicked {
//    NSLog(@"点击：%@",self.model);
//    NSLog(@"点击：%@",self);
    //填写维保单
    AddDeviceWXListViewController *VC = [AppUtils VCFromSB:@"Main" vcID:@"AddDeviceWXListVC"];
    VC.deviceid = self.model.deviceid;
    VC.address = self.model.address;
    VC.brand_model = self.model.deviceno;
    VC.projectid = self.model.projectid;
    VC.basedelegate = self.vc;
    VC.warnid = self.model.warnid;
    VC.warnname = self.model.warnname;
    [_vc.navigationController pushViewController:VC animated:YES];
}
@end

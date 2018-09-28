//
//  ZL_WH_WX_JGFinishOpt.m
//  WebThings
//
//  Created by machinsight on 2017/8/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ZL_WH_WX_JGFinishOpt.h"
#import "ZL_WH_WX_JGFinishCell.h"
#import "WorkDeskStrConfig.h"
#import "RepairFinishWI.h"
#import "MaintainFinishDo.h"

@interface ZL_WH_WX_JGFinishOpt()
@property(nonatomic,strong)NotifyDetailViewController *vc;
@property(nonatomic,strong)DWMsgModel *model;
@end
@implementation ZL_WH_WX_JGFinishOpt
-(UITableViewCell *) getTableViewCell:(NotifyDetailViewController *)vc tableView:(UITableView *)tableView DWMsgData:(DWMsgModel *)model{
    _vc = vc;
    _model = model;
    ZL_WH_WX_JGFinishCell *cell = [ZL_WH_WX_JGFinishCell cellWithTableView:tableView delegate:self];
    [cell setViewValuesWithModel:model];
//    model.closeCellHeight = [cell cellCloseHeight];
    model.openCellHeight = [cell cellOpenHeightWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//已完成
- (void)bohuiBtnClicked{
    if ([_model.noticetype isEqualToString:Notice_SBWH]) {
        [self fetch_MaintainFinishDo];
    }else if(([_model.noticetype isEqualToString:Notice_SBWX])){
        [self fetch_RepairFinishWI];
    }else{
        [self fetch_AddHighFinshWI];
    }
}


/**
 我已完成维保
 */
- (void)fetch_MaintainFinishDo{
    MaintainFinishDo *lwi = [[MaintainFinishDo alloc] init];
    NSArray *arr = @[@(_vc.baseUser.userid),_vc.baseUser.type,@(_model.projectid),@(_model.deviceid),@(_model.noticeid),_vc.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            [_vc fetchList];
        }
        
        
    } WithFailureBlock:^(NSError *error) {
        
    }];
}



/**
 我已完成维修
 */
- (void)fetch_RepairFinishWI{
    RepairFinishWI *lwi = [[RepairFinishWI alloc] init];
    NSArray *arr = @[@(_vc.baseUser.userid),_vc.baseUser.type,@(_model.projectid),@(_model.deviceid),@(_model.noticeid),_vc.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            [_vc fetchList];
        }
        
        
    } WithFailureBlock:^(NSError *error) {
        
    }];
}

/**
 我已加高完成
 */
- (void)fetch_AddHighFinshWI
{    
    [[DQServiceInterface sharedInstance] dq_getAddHeightFinsh: @(_model.projectid)  deviceid:@(_model.deviceid) highid:@(_model.noticeid) success:^(id result) {
        if (result) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:3.0];
            [t show];
            [_vc fetchList];
        }
    } failture:^(NSError *error) {
        
    }];
}

@end

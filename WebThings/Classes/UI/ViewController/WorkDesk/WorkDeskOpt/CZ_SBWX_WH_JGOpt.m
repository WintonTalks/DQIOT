//
//  CZ_SBWX_WH_JGOpt.m
//  WebThings
//
//  Created by machinsight on 2017/8/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CZ_SBWX_WH_JGOpt.h"
#import "CZ_SBWX_WH_JGCell.h"
#import "AgreeorDismissWI.h"
#import "WorkDeskStrConfig.h"
@interface CZ_SBWX_WH_JGOpt()
@property(nonatomic,strong)NotifyDetailViewController *vc;
@property(nonatomic,strong)DWMsgModel *model;
@end
@implementation CZ_SBWX_WH_JGOpt
-(UITableViewCell *) getTableViewCell:(NotifyDetailViewController *)vc tableView:(UITableView *)tableView DWMsgData:(DWMsgModel *)model{
    _vc = vc;
    _model = model;
    CZ_SBWX_WH_JGCell *cell = [CZ_SBWX_WH_JGCell cellWithTableView:tableView delegate:self];
    [cell setViewValuesWithModel:model];
//    model.closeCellHeight = [cell cellCloseHeight];
    model.openCellHeight = [cell cellOpenHeightWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//确认
- (void)querenBtnClicked{
    if ([_model.noticetype isEqualToString:Notice_SBWH]) {
        [self fetchAgreeOrDismissWithEventtype:SBWH WithYesOrNo:Agree];
    }else if(([_model.noticetype isEqualToString:Notice_SBWX])){
        [self fetchAgreeOrDismissWithEventtype:SBWX WithYesOrNo:Agree];
    }else{
        [self fetchAgreeOrDismissWithEventtype:SBJG WithYesOrNo:Agree];
    }
}
//驳回
- (void)bohuiBtnClicked{
    if ([_model.noticetype isEqualToString:Notice_SBWH]) {
        [self fetchAgreeOrDismissWithEventtype:SBWH WithYesOrNo:Refuse];
    }else if(([_model.noticetype isEqualToString:Notice_SBWX])){
        [self fetchAgreeOrDismissWithEventtype:SBWX WithYesOrNo:Refuse];
    }else{
        [self fetchAgreeOrDismissWithEventtype:SBJG WithYesOrNo:Refuse];
    }
}

//同意驳回
- (void)fetchAgreeOrDismissWithEventtype:(NSString *)eventtype WithYesOrNo:(NSString *)yesorno{
    AgreeorDismissWI *lwi = [[AgreeorDismissWI alloc] init];
    NSArray *arr = @[@(_vc.baseUser.userid),_vc.baseUser.type,eventtype,yesorno,@(_model.projectid),@(_model.deviceid),@(_model.noticeid),@(_model.projectdeviceid),_vc.baseUser.usertype];
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

@end

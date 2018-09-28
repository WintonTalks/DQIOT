//
//  ZL_SBCCOpt.m
//  WebThings
//
//  Created by machinsight on 2017/8/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ZL_SBCCOpt.h"
#import "ZL_SBCC.h"
#import "AgreeorDismissWI.h"
@interface ZL_SBCCOpt()
@property(nonatomic,strong)NotifyDetailViewController *vc;
@property(nonatomic,strong)DWMsgModel *model;
@end
@implementation ZL_SBCCOpt
-(UITableViewCell *) getTableViewCell:(NotifyDetailViewController *)vc tableView:(UITableView *)tableView DWMsgData:(DWMsgModel *)model{
    _vc = vc;
    _model = model;
    ZL_SBCC *cell = [ZL_SBCC cellWithTableView:tableView delegate:self];
    [cell setViewValuesWithModel:model];
//    model.closeCellHeight = [cell cellCloseHeight];
    model.openCellHeight = [cell cellOpenHeightWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//确认
- (void)querenBtnClicked{
    [self fetchAgreeOrDismissWithEventtype:SBCC WithYesOrNo:Agree];
    
}
//驳回
- (void)bohuiBtnClicked{
    [self fetchAgreeOrDismissWithEventtype:SBCC WithYesOrNo:Refuse];
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

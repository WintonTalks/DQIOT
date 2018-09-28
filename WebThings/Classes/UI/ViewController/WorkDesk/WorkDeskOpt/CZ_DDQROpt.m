//
//  CZ_DDQROpt.m
//  WebThings
//
//  Created by machinsight on 2017/8/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CZ_DDQROpt.h"
#import "CZ_DDQRCell.h"
#import "AgreeorDismissWI.h"
@interface CZ_DDQROpt()
@property(nonatomic,strong)NotifyDetailViewController *vc;
@property(nonatomic,strong)DWMsgModel *model;
@end
@implementation CZ_DDQROpt
-(UITableViewCell *) getTableViewCell:(NotifyDetailViewController *)vc tableView:(UITableView *)tableView DWMsgData:(DWMsgModel *)model{
    _vc = vc;
    _model = model;
    CZ_DDQRCell *cell = [CZ_DDQRCell cellWithTableView:tableView delegate:self];
    [cell setViewValuesWithModel:model];
//    model.closeCellHeight = [cell cellCloseHeight];
    model.openCellHeight = [cell cellOpenHeightWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//确认
- (void)querenBtnClicked{
    [self fetchAgreeOrDismissWithEventtype:QQGT_JCGTD WithYesOrNo:Agree];

}
//驳回
- (void)bohuiBtnClicked{
    [self fetchAgreeOrDismissWithEventtype:QQGT_JCGTD WithYesOrNo:Refuse];
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

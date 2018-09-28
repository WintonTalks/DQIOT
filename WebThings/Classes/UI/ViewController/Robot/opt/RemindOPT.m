//
//  RemindOPT.m
//  WebThings
//
//  Created by Henry on 2017/8/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RemindOPT.h"
#import "RobotAddRemindWI.h"
#import "CheckStringConfig.h"

@interface RemindOPT()<RobotRemindMsgDelegate>
@property(nonatomic,weak)RobotChatViewController *robotVC;
@property(nonatomic,copy)NSString *msg;
@end

@implementation RemindOPT


-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    _robotVC = vc;
    RemindMsgCell *cell = [RemindMsgCell cellWithTableView:tableView data:chatModel.data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatModel.cellHeight = [cell cellHeight];
    _msg = cell.msg;
    cell.delegate = self;
    return cell;
}

-(void)onConfirmDate:(NSString *)date{
//    [_robotVC xiaoWeiSay:@"我会提醒你"];
//    ChatModel *robotBean = [[ChatModel alloc] init];
//    robotBean.checktype = @"提醒返回";
//    robotBean.data = @[@"提醒",date];
//    [_robotVC addChatModel:robotBean];
    [self fetchAddRemind:_msg date:date];
}

//网络请求
-(void)fetchAddRemind:(NSString *)msg date:(NSString *)date{
        UserModel *user = [AppUtils readUser];
        RobotAddRemindWI *webInterface = [[RobotAddRemindWI alloc] init];
        NSArray *arr = @[[NSNumber numberWithInteger:user.userid],user.type,user.usertype,date,msg];
        NSDictionary *param = [webInterface inBox:arr];
        [CKNetTools requestWithRequestType:POST WithURL:webInterface.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
    
        } WithSuccessBlock:^(id returnValue) {
            NSArray *temp = [webInterface unBox:returnValue];
            if ([temp[0] integerValue] == 1) {
                [_robotVC xiaoWeiSay:@"我会提醒你"];
                ChatModel *robotBean = [[ChatModel alloc] init];
                robotBean.checktype = TYPE_REMIND_RETURN;
                //            robotBean.data = @[chatModel.data,date];
                robotBean.data = @[msg,date];
                [_robotVC addChatModel:robotBean];
            }
            
        } WithFailureBlock:^(NSError *error) {
        }];
}

@end

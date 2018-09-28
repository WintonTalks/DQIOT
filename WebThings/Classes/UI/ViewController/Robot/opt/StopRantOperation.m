//
//  StopRantOperation.m
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "StopRantOperation.h"
#import "RobotStopRantCell.h"
#import "AddStopRentOrderWI.h"
@interface StopRantOperation()<RobotDelegate>
@property(nonatomic,weak)RobotChatViewController *robotVC;
@property(nonatomic,strong)ChatModel *chatModel;
@end
@implementation StopRantOperation

-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    _robotVC =vc;
    _chatModel = chatModel;
    RobotStopRantCell *cell = [RobotStopRantCell cellWithTableView:tableView data:chatModel.data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatModel.cellHeight = [cell height];
    cell.delegate = self;
    return cell;
}

-(void)confirm:(id)data{
    NSString *date = data;
    if(![date isEqualToString:@""]){
        [self fetchStopRant:_chatModel date:date];
    }else{
        [_robotVC xiaoWeiSay:@"请填写完整数据"];
    }

}

//网络请求
-(void)fetchStopRant:(ChatModel *)chatModel date:(NSString *)date{
    UserModel *user = [AppUtils readUser];
    AddStopRentOrderWI *webInterface = [[AddStopRentOrderWI alloc] init];
    DeviceModel *device = chatModel.data;
    NSArray *arr = @[[NSNumber numberWithInteger:user.userid],user.type,user.usertype,[NSNumber numberWithInteger:device.projectid],[NSNumber numberWithInteger:device.deviceid],date];
    NSDictionary *param = [webInterface inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:webInterface.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSMutableArray *arr = [webInterface unBox:returnValue];
        if ([arr[0] intValue] == 1) {
            [_robotVC xiaoWeiSay:@"新增停租单成功"];
        }else{
            [_robotVC xiaoWeiSay:@"新增停租单失败"];
        }
    } WithFailureBlock:^(NSError *error) {
        [_robotVC xiaoWeiSay:@"新增停租单失败"];
    }];
}


@end

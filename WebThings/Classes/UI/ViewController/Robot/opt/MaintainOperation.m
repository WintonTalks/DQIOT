//
//  MaintainOperation.m
//  WebThings
//
//  Created by Henry on 2017/8/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "MaintainOperation.h"
#import "RobotMaintainCell.h"
#import "RobotDateTime.h"
#import "AddDeviceMaintainOrderWI.h"
@interface MaintainOperation()<RobotDelegate>
@property(nonatomic,weak)RobotChatViewController *robotVC;
@property(nonatomic,strong)ChatModel *chatModel;
@end
@implementation MaintainOperation


-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    _robotVC = vc;
    _chatModel = chatModel;
    RobotMaintainCell *cell = [RobotMaintainCell cellWithTableView:tableView data:chatModel.data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatModel.cellHeight = [cell height];
    cell.delegate = self;
    return cell;
}

-(void)confirm:(id)data{
    NSArray *array = data;
    if([RobotDateTime checkEmpty:array]){
        [self fetchAddMaintain:_chatModel date:array[0] enddate:array[1]];
    }else{
        [_robotVC xiaoWeiSay:@"请填写完整数据"];
    }
}

//网络请求
-(void)fetchAddMaintain:(ChatModel *)chatModel date:(NSString *)date enddate:(NSString *)enddate{
    UserModel *user = [AppUtils readUser];
    AddDeviceMaintainOrderWI *webInterface = [[AddDeviceMaintainOrderWI alloc] init];
    DeviceModel *device = chatModel.data;
    NSArray *arr = @[[NSNumber numberWithInteger:user.userid],user.type,[NSNumber numberWithInteger:device.projectid],[NSNumber numberWithInteger:device.deviceid],date,enddate,@"",user.usertype];
    NSDictionary *param = [webInterface inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:webInterface.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSMutableArray *arr = [webInterface unBox:returnValue];
        if ([arr[0] intValue] == 1) {
            [_robotVC xiaoWeiSay:@"新增维保单成功"];
        }else{
            [_robotVC xiaoWeiSay:@"新增维保单失败"];
        }
    } WithFailureBlock:^(NSError *error) {
        [_robotVC xiaoWeiSay:@"新增维保单失败"];
    }];
}
@end

//
//  RepairOperation.m
//  WebThings
//
//  Created by Henry on 2017/8/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RepairOperation.h"
#import "RobotRepairCell.h"
#import "RobotDateTime.h"

@interface RepairOperation()<RobotDelegate>
@property(nonatomic,weak)RobotChatViewController *robotVC;
@property(nonatomic,strong)ChatModel *chatModel;
@end
@implementation RepairOperation

-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    _robotVC = vc;
    _chatModel = chatModel;
    RobotRepairCell *cell = [RobotRepairCell cellWithTableView:tableView data:chatModel.data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatModel.cellHeight = [cell height];
    cell.delegate = self;
    return cell;
}
-(void)confirm:(id)data{
    NSArray *array = data;
    if(![array[0] isEqualToString:@""]&&![array[1] isEqualToString:@""]&&([array[2] integerValue]!=0||![array[3] isEqualToString:@""])){
        [self fetchAddRepair:_chatModel date:array[0] enddate:array[1] warnid:array[2] text:array[3]];
    }else{
        [_robotVC xiaoWeiSay:@"请填写完整数据"];
    }
}

//网络请求
-(void)fetchAddRepair:(ChatModel *)chatModel date:(NSString *)date enddate:(NSString *)enddate warnid:(NSNumber *)warnid text:(NSString *)text
{
    UserModel *user = [AppUtils readUser];
    DeviceModel *device = chatModel.data;
    NSDictionary *dic = @{@"userid" : @(user.userid),
                          @"type" : [NSObject changeType:user.type],
                          @"usertype" : [NSObject changeType:user.usertype],
                          @"projectid" : @(device.projectid),
                          @"deviceid" : @(device.deviceid),
                          @"warnid" : warnid,
                          @"sdate" : [NSObject changeType:date],
                          @"edate" : [NSObject changeType:enddate],
                          @"text" : [NSObject changeType:text]};    
    [[DQServiceInterface sharedInstance] dq_getAddDeviceRepairOrder:dic success:^(id result) {
        if (result != nil) {
             [_robotVC xiaoWeiSay:@"新增维修单成功"];
        } else {
            [_robotVC xiaoWeiSay:@"新增维修单失败"];
        }
    } failture:^(NSError *error) {
         [_robotVC xiaoWeiSay:@"新增维修单失败"];
    }];
}

@end

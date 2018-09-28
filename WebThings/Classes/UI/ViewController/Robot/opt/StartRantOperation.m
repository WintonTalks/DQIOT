//
//  StartRantOperation.m
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "StartRantOperation.h"
#import "RobotStartRantCell.h"
#import "RobotDateTime.h"
@interface StartRantOperation()<RobotDelegate>
@property(nonatomic,weak)RobotChatViewController *robotVC;
@property(nonatomic,strong)ChatModel *chatModel;
@end


@implementation StartRantOperation

-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    _robotVC = vc;
    _chatModel = chatModel;
    RobotStartRantCell *cell = [RobotStartRantCell cellWithTableView:tableView data:chatModel.data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatModel.cellHeight = [cell height];
    cell.delegate = self;
    return cell;
}

-(void)confirm:(id)data{
    NSArray *array = data;
    if([RobotDateTime checkEmpty:array]){
        [self fetchStartRant:_chatModel date:array[0] recordno:array[1] checkcompany:array[2] chckreportid:array[3]];
    }else{
        [_robotVC xiaoWeiSay:@"请填写完整数据"];
    }
}

//网络请求
-(void)fetchStartRant:(ChatModel *)chatModel date:(NSString *)date recordno:(NSString *)recordno checkcompany:(NSString *)checkcompany chckreportid:(NSString *)chckreportid{
    UserModel *user = [AppUtils readUser];
    DeviceModel *device = chatModel.data;
    NSDictionary *dic = @{@"userid" : @(user.userid),
                          @"type" : [NSObject changeType:user.type],
                          @"usertype" : [NSObject changeType:user.usertype],
                          @"projectid" : @(device.projectid),
                          @"deviceid" : @(device.deviceid),
                          @"startdate" : date,
                          @"recordno" : [NSObject changeType:recordno],
                          @"checkcompany" : [NSObject changeType:checkcompany],
                          @"chckreportid" : [NSObject changeType:chckreportid]};
    
    [[DQServiceInterface sharedInstance] dq_getAddStarRentOrder:dic success:^(id result) {
        if (result != nil) {
             [_robotVC xiaoWeiSay:@"新增启租单成功"];
        } else {
         [_robotVC xiaoWeiSay:@"新增启租单失败"];
        }
    } failture:^(NSError *error) {
        [_robotVC xiaoWeiSay:@"新增启租单失败"];
    }];
}

@end

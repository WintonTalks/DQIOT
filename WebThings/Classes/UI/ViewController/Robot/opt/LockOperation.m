//
//  LockOperation.m
//  WebThings
//
//  Created by Henry on 2017/8/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "LockOperation.h"
#import "DeviceModel.h"

@interface LockOperation()
@property(nonatomic,weak)RobotChatViewController *robotVC;
@property(nonatomic,weak)ChatModel *model;
@end


@implementation LockOperation

-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    _robotVC = vc;
    _model = chatModel;
    RobotLockCell *cell = [RobotLockCell cellWithTableView:tableView delegate:self];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatModel.cellHeight = [cell cellHeight];
    return cell;
}

-(void)lockMachine
{
    [self fetchLockMachine];
}

-(void)fetchLockMachine
{
    DeviceModel *deviceModel = _model.data;
    [[DQServiceInterface sharedInstance] dq_getConfigLocked:@(deviceModel.projectid) deviceid:@(deviceModel.deviceid) success:^(id result) {
        if (result) {
            [_robotVC xiaoWeiSay:@"锁机成功"];
        } else {
            [_robotVC xiaoWeiSay:@"锁机失败"];
        }
    } failture:^(NSError *error) {
        [_robotVC xiaoWeiSay:@"锁机失败"];
    }];

}
@end

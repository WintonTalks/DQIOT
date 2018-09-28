//
//  UserOperation.m
//  WebThings
//
//  Created by Henry on 2017/8/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "UserOperation.h"
#import "RobotUserCell.h"
@implementation UserOperation

-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    RobotUserCell *cell = [RobotUserCell cellWithTableView:tableView data:chatModel.data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell setValuesWithModel:chatModel];
    chatModel.cellHeight = [cell cellHeight];
    return cell;
}
@end

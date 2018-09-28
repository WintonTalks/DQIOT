//
//  SayOperation.m
//  WebThings
//
//  Created by Henry on 2017/7/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "SayOperation.h"
#import "RobotRightCell.h"
@implementation SayOperation

-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    RobotRightCell *cell = [RobotRightCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setValuesWithModel:chatModel];
    chatModel.cellHeight = [cell cellHeight];
    return cell;
}
@end

//
//  XiaoWeiOperation.m
//  WebThings
//
//  Created by Henry on 2017/7/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "XiaoWeiOperation.h"
#import "RobotLeftCell.h"
@implementation XiaoWeiOperation

-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    RobotLeftCell *cell = [RobotLeftCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setValuesWithModel:chatModel];
    chatModel.cellHeight = [cell cellHeight];
    return cell;
}
@end

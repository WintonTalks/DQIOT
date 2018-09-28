//
//  RemindReturnOPT.m
//  WebThings
//
//  Created by Henry on 2017/8/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RemindReturnOPT.h"
#import "RobotRemindReturnCell.h"
@implementation RemindReturnOPT

-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    RobotRemindReturnCell *cell = [RobotRemindReturnCell cellWithTableView:tableView data:chatModel.data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatModel.cellHeight = [cell cellHeight];
    return cell;
}
@end

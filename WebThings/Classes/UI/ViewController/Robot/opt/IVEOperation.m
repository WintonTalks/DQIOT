//
//  IVEOperation.m
//  WebThings
//
//  Created by Henry on 2017/8/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "IVEOperation.h"
#import "RobotIVECell.h"

@implementation IVEOperation

-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{

    RobotIVECell *cell = [RobotIVECell cellWithTableView:tableView data:chatModel.data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatModel.cellHeight = [cell cellHeight];
    return cell;
}

@end

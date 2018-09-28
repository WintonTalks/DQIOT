//
//  EmptyOperation.m
//  WebThings
//
//  Created by Henry on 2017/8/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EmptyOperation.h"
#import "RobotEmptyCell.h"
@implementation EmptyOperation
-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    RobotEmptyCell *cell = [RobotEmptyCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatModel.cellHeight = [cell height];
    return cell;
}
@end

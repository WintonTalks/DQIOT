//
//  ReportOperation.m
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ReportOperation.h"
#import "RobotReportCell.h"
@implementation ReportOperation

-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    RobotReportCell *cell = [RobotReportCell cellWithTableView:tableView data:chatModel.data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatModel.cellHeight = [cell cellHeight];
    return cell;
}
@end

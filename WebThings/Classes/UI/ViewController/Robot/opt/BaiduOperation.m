//
//  BaiduOperation.m
//  WebThings
//
//  Created by Henry on 2017/7/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "BaiduOperation.h"
#import "RobotContainerCell.h"

@implementation BaiduOperation

-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    
    RobotContainerCell *cell = [RobotContainerCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIWebView *webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-24, 470)];
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",chatModel.data] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
//    webV.delegate = self;
    [cell setView:webV];
    chatModel.cellHeight = [cell cellHeight];
    return cell;

}
@end

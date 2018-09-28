//
//  OperationDelegate.h
//  WebThings
//
//  Created by Henry on 2017/7/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ChatModel.h"
#import "RobotChatViewController.h"
@protocol OperationDelegate <NSObject>

-(UITableViewCell *) getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel;
@end

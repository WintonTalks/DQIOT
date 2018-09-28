//
//  WorkDeskDelegate.h
//  WebThings
//
//  Created by machinsight on 2017/8/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DWMsgModel.h"
#import "NotifyDetailViewController.h"
@protocol WorkDeskDelegate <NSObject>

-(UITableViewCell *) getTableViewCell:(NotifyDetailViewController *)vc tableView:(UITableView *)tableView DWMsgData:(DWMsgModel *)model;

@end

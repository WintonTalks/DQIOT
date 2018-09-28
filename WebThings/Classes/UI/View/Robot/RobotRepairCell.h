//
//  RobotRepairCell.h
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"
#import "RobotDelegate.h"
#import "WarningModel.h"
@interface RobotRepairCell : UITableViewCell
@property (nonatomic,  weak) id<RobotDelegate> delegate;
@property (nonatomic,assign) CGFloat height;
+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data;
-(void)valueWithDevice:(DeviceModel *)device;
@end

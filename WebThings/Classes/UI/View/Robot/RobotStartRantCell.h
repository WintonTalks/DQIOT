//
//  RobotStartRantCell.h
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"
#import "RobotDelegate.h"
@interface RobotStartRantCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet MDTextField *tfDate;
@property (weak, nonatomic) IBOutlet MDTextField *tfTime;
@property (weak, nonatomic) IBOutlet MDTextField *tfRecordNo;
@property (weak, nonatomic) IBOutlet MDTextField *tfCheckUnit;
@property (weak, nonatomic) IBOutlet MDTextField *tfCheckReportNo;
@property (nonatomic,   weak) id<RobotDelegate> delegate;
@property (nonatomic, assign) CGFloat height;
+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data;
-(void)valueWithDevice:(DeviceModel *)device;

@end

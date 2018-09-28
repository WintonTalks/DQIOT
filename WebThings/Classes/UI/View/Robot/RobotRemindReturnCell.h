//
//  RobotRemindReturnCell.h
//  WebThings
//
//  Created by Henry on 2017/8/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RobotRemindReturnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *remindMsg;
@property (weak, nonatomic) IBOutlet UILabel *remindDate;
@property(nonatomic,assign)CGFloat cellHeight;
+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data;

//- (CGFloat)cellHeight;
@end

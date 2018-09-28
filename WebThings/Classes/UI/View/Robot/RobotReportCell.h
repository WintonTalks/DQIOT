//
//  RobotReportCell.h
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMICardView.h"
@interface RobotReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet EMICardView *body;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property(nonatomic,assign)CGFloat height;
+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data;

- (CGFloat)cellHeight;
@end

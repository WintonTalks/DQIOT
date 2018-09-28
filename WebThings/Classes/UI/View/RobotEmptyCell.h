//
//  RobotEmptyCell.h
//  WebThings
//
//  Created by Henry on 2017/8/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RobotEmptyCell : UITableViewCell
@property(nonatomic,assign)CGFloat height;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

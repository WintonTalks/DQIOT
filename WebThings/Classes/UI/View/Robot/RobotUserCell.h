//
//  RobotUserCell.h
//  WebThings
//
//  Created by Henry on 2017/8/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMINormalTableViewCell.h"
@interface RobotUserCell : EMINormalTableViewCell
@property(nonatomic,assign)CGFloat cellHeight;
+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data;

- (CGFloat)cellHeight;
@end

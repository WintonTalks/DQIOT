//
//  RobotIVECell.h
//  WebThings
//
//  Created by Henry on 2017/8/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RobotIVECell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data;

- (CGFloat)cellHeight;

-(CGFloat)bodyWidth;

-(void)addLabel:(UILabel *)label;
@end

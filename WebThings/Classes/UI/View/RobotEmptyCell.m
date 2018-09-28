//
//  RobotEmptyCell.m
//  WebThings
//
//  Created by Henry on 2017/8/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotEmptyCell.h"

@implementation RobotEmptyCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    RobotEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RobotEmptyCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotEmptyCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(CGFloat)height{
    return 0;
}

@end

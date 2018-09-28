//
//  RobotUserCell.m
//  WebThings
//
//  Created by Henry on 2017/8/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotUserCell.h"
#import "RobotUserView.h"


@implementation RobotUserCell

+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data{
    RobotUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RobotUserCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotUserCell" owner:nil options:nil] objectAtIndex:0];
        NSArray *userArray = data;
        cell.cellHeight = 96*userArray.count;
        cell.contentView.height = 96*userArray.count;
        for(int i=0;i<userArray.count;i++){
            UserModel *user = userArray[i];
            RobotUserView *userView = [RobotUserView viewWithUser:user];
            CGRect rect = userView.frame;
            rect.origin.y = 96*i;
            userView.frame = rect;
            [cell.contentView addSubview:userView];
        }
    }
    return cell;
}

-(CGFloat)cellHeight{
    return _cellHeight;
}

@end

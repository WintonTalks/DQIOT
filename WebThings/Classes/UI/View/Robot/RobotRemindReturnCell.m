//
//  RobotRemindReturnCell.m
//  WebThings
//
//  Created by Henry on 2017/8/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotRemindReturnCell.h"

//int height;

@implementation RobotRemindReturnCell

+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data{
    NSArray *array = data;
    RobotRemindReturnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RobotRemindReturnCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotRemindReturnCell" owner:nil options:nil] lastObject];
        cell.remindMsg.text = array[0];
        cell.remindDate.text = array[1];
        CGFloat height = [AppUtils textHeightSystemFontString:cell.remindMsg.text height:cell.remindMsg.bounds.size.width font:cell.remindMsg.font];
        cell.cellHeight = 129+height;

    }
    return cell;
}

//- (CGFloat)cellHeight{
//    return height;
//}

@end

//
//  RobotReportCell.m
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotReportCell.h"
#import "RobotReportView.h"
#import "DailyModel.h"


@implementation RobotReportCell


+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data{
    RobotReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RobotReportCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotReportCell" owner:nil options:nil] lastObject];
        DailyModel *dModel = data;
        NSArray<CheckModel *> *array = dModel.data;
        cell.title.text = [NSString stringWithFormat:@"%@%@",dModel.date,@"施工电梯检查日报"];
        cell.height = 64+61*array.count+25;
        for (int i=0; i<array.count; i++) {
            CheckModel *cModel = array[i];
            RobotReportView *view = [RobotReportView viewWithCheck:cModel];
            CGRect rect = CGRectMake(15, 64+i*61, cell.body.bounds.size.width-30, 61) ;
            view.frame = rect;
            if ([@"待修复" isEqualToString:cModel.checktype]) {
//                holder.tvState.setTextColor(mContext.getResources().getColor(R.color.me_exit_bt_bg));
                view.checkstate.textColor = [UIColor colorWithHexString:@"#DC4437"];
            }
            [cell.body addSubview:view];
        }
    }
    return cell;
}

- (CGFloat)cellHeight{
    return _height;
}

@end

//
//  RemindMsgCell.m
//  WebThings
//
//  Created by Henry on 2017/8/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RemindMsgCell.h"
#import "MDDatePickerDialog.h"

@interface RemindMsgCell()<MDDatePickerDialogDelegate>

@end

@implementation RemindMsgCell

- (IBAction)confirmDate:(id)sender {
    MDDatePickerDialog *dialog = [[MDDatePickerDialog alloc] init];
    [dialog setTitleOk:@"确定" andTitleCancel:@"取消"];
    dialog.delegate = self;
    [dialog show];
}

+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data{
    RemindMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindMsgCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindMsgCell" owner:nil options:nil] lastObject];
        cell.remindMsg.text = data;
        cell.msg = data;
    }
    return cell;
}

- (CGFloat)cellHeight{
    return 147;
}

-(void)datePickerDialogDidSelectDate:(NSDate *)date{
    NSString *dateString = [DateTools dateTopointedString:date format:@"yyyy/MM/dd"];
//    NSLog(@"%@",dateString);
    if (_delegate) {
        [_delegate onConfirmDate:dateString];
    }
}

@end

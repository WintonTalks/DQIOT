//
//  RobotStartRantCell.m
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotStartRantCell.h"
#import "MDDatePickerDialog.h"
#import "MDTimePickerDialog.h"
#import "RobotDateTime.h"

@interface RobotStartRantCell()<MDDatePickerDialogDelegate,MDTimePickerDialogDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceNo;
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceAddress;
@property(nonatomic,strong)MDDatePickerDialog *dialog;

@property(nonatomic,strong)DeviceModel *thisModel;

@property (weak, nonatomic) IBOutlet UIView *tapV;
@end

@implementation RobotStartRantCell
- (IBAction)onConfirm:(id)sender {
    if (_thisModel.isRobotClicked == 1) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请勿重复提交" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (_delegate) {
        NSArray *array = @[[RobotDateTime getDate:_tfDate.text time:_tfTime.text],_tfRecordNo.text,_tfCheckUnit.text,_tfCheckReportNo.text];
        [_delegate confirm:array];
        _thisModel.isRobotClicked = 1;
    }
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data{
    RobotStartRantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RobotStartRantCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotStartRantCell" owner:nil options:nil] lastObject];
        [cell valueWithDevice:data];
        [cell.tapV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(hidekeyboard:)]];
    }
    return cell;
}

- (void)hidekeyboard:(UITapGestureRecognizer *)sender{
    [self endEditing:YES];
}
- (IBAction)startdate:(id)sender {
    //    [self.dialog show];MDDatePickerDialog *dialog = [[MDDatePickerDialog alloc] init];
    MDDatePickerDialog *dialog = [[MDDatePickerDialog alloc] init];
    [dialog setTitleOk:@"确定" andTitleCancel:@"取消"];
    dialog.delegate = self;
    [dialog show];
}

- (IBAction)enddate:(id)sender {
    MDTimePickerDialog *dialog = [[MDTimePickerDialog alloc] init];
    [dialog setTitleOk:@"确定" andTitleCancel:@"取消"];
    dialog.delegate = self;
    [dialog show];
}

-(MDDatePickerDialog *)dialog{
    if (!_dialog) {
        MDDatePickerDialog *dialog = [[MDDatePickerDialog alloc] init];
        [dialog setTitleOk:@"确定" andTitleCancel:@"取消"];
        dialog.delegate = self;
    }
    return _dialog;
}

-(void)valueWithDevice:(DeviceModel *)device{
    _thisModel = device;
    UserModel *user = [AppUtils readUser];
    self.labelName.text = user.name;
    self.labelPhone.text = user.dn;
    self.labelDeviceNo.text = device.deviceno;
    self.labelDeviceAddress.text = device.installationsite;
}

-(CGFloat)height{
    return 531;
}

-(void)datePickerDialogDidSelectDate:(NSDate *)date{
    NSString *dateString = [DateTools dateTopointedString:date format:@"yyyy/MM/dd"];
    _tfDate.text = dateString;
}

-(void)timePickerDialog:(MDTimePickerDialog *)timePickerDialog didSelectHour:(NSInteger)hour andMinute:(NSInteger)minute{
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld",(long)hour,(long)minute];
    _tfTime.text = timeString;
}

@end

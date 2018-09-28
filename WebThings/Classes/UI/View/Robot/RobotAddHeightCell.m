//
//  RobotAddHeightCell.m
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//
#import "RobotAddHeightCell.h"
#import "MDDatePickerDialog.h"
#import "MDTimePickerDialog.h"
#import "RobotDateTime.h"
@interface RobotAddHeightCell()<MDDatePickerDialogDelegate,MDTimePickerDialogDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet MDTextField *tfDate;
@property (weak, nonatomic) IBOutlet MDTextField *tfTime;
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceNo;
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceAddress;
@property (weak, nonatomic) IBOutlet MDTextField *tfEndDate;
@property (weak, nonatomic) IBOutlet MDTextField *tfEndTime;
@property (weak, nonatomic) IBOutlet MDTextField *tfHeight;
@property(nonatomic,assign)BOOL isStartDate;
@property(nonatomic,assign)BOOL isStartTime;

@property(nonatomic,strong)DeviceModel *thisModel;

@property (weak, nonatomic) IBOutlet UIView *tapV;
@end

@implementation RobotAddHeightCell
- (IBAction)onConfirm:(id)sender {
    if (_thisModel.isRobotClicked == 1) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请勿重复提交" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (_delegate) {
        NSArray *array = @[[RobotDateTime getDate:_tfDate.text time:_tfTime.text],[RobotDateTime getDate:_tfEndDate.text time:_tfEndTime.text],_tfHeight.text];
        [_delegate confirm:array];
        _thisModel.isRobotClicked = 1;
    }
}

+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data{
    RobotAddHeightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RobotAddHeightCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotAddHeightCell" owner:nil options:nil] lastObject];
        [cell defaultInput];
        [cell valueWithDevice:data];
        [cell.tapV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(hidekeyboard:)]];
    }
    return cell;
    
}
- (void)hidekeyboard:(UITapGestureRecognizer *)sender{
    [self endEditing:YES];
}
-(void)defaultInput{
    _tfHeight.keyboardType = UIKeyboardTypeNumberPad;
}
- (IBAction)startdate:(id)sender {
    [self endEditing:YES];
    _isStartDate = YES;
    MDDatePickerDialog *dialog = [[MDDatePickerDialog alloc] init];
    [dialog setTitleOk:@"确定" andTitleCancel:@"取消"];
    dialog.delegate = self;
    [dialog show];

}
- (IBAction)starttime:(id)sender {
    [self endEditing:YES];
    _isStartTime = YES;
    MDTimePickerDialog *dialog = [[MDTimePickerDialog alloc] init];
    [dialog setTitleOk:@"确定" andTitleCancel:@"取消"];
    dialog.delegate = self;
    [dialog show];

}
- (IBAction)enddate:(id)sender {
    [self endEditing:YES];
    _isStartDate = NO;
    MDDatePickerDialog *dialog = [[MDDatePickerDialog alloc] init];
    [dialog setTitleOk:@"确定" andTitleCancel:@"取消"];
    dialog.delegate = self;
    [dialog show];

}
- (IBAction)endtime:(id)sender {
    [self endEditing:YES];
    _isStartTime = NO;
    MDTimePickerDialog *dialog = [[MDTimePickerDialog alloc] init];
    [dialog setTitleOk:@"确定" andTitleCancel:@"取消"];
    dialog.delegate = self;
    [dialog show];
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
    return 500;
}

-(void)datePickerDialogDidSelectDate:(NSDate *)date{
    NSString *dateString = [DateTools dateTopointedString:date format:@"yyyy/MM/dd"];
    if (_isStartDate) {
        _tfDate.text = dateString;
    }else{
        _tfEndDate.text = dateString;
    }
    
}

-(void)timePickerDialog:(MDTimePickerDialog *)timePickerDialog didSelectHour:(NSInteger)hour andMinute:(NSInteger)minute{
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld",(long)hour,(long)minute];
    if(_isStartTime){
        _tfTime.text = timeString;
    }else{
        _tfEndTime.text = timeString;
    }
}

@end

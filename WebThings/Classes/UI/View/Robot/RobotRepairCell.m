//
//  RobotRepairCell.m
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotRepairCell.h"
#import "MDDatePickerDialog.h"
#import "MDTimePickerDialog.h"
#import "RobotDateTime.h"
#import "NewDeviceScrollView.h"

@interface RobotRepairCell()<MDDatePickerDialogDelegate,MDTimePickerDialogDelegate,NewDeviceScrollViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet MDTextField *tfDate;
@property (weak, nonatomic) IBOutlet MDTextField *tfTime;
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceNo;
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceAddress;
@property (weak, nonatomic) IBOutlet MDTextField *tfEndDate;
@property (weak, nonatomic) IBOutlet MDTextField *tfEndTime;
@property (weak, nonatomic) IBOutlet MDTextField *tfWarn;
@property (weak, nonatomic) IBOutlet MDTextField *tfOtherWarn;
@property(nonatomic,assign)BOOL isStartDate;
@property(nonatomic,assign)BOOL isStartTime;
@property(nonatomic,strong)NSMutableArray <WarningModel *> *gzArr;//故障数据
@property(nonatomic,strong)WarningModel *warn;
@property (nonatomic,strong) NewDeviceScrollView *gzAlertV;/**< 故障 弹出框*/

@property(nonatomic,strong)DeviceModel *thisModel;

@property (weak, nonatomic) IBOutlet UIView *tapV;
@end


@implementation RobotRepairCell

+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data{
    RobotRepairCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RobotRepairCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotRepairCell" owner:nil options:nil] lastObject];
        [cell valueWithDevice:data];
        [cell.tapV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(hidekeyboard:)]];
    }
    return cell;
}
- (IBAction)onConfirm:(id)sender {
    if (_thisModel.isRobotClicked == 1) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请勿重复提交" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (_delegate) {
        NSInteger warnid = 0;
        if (_warn) {
            warnid = _warn.warnid;
        }
        NSArray *array = @[[RobotDateTime getDate:_tfDate.text time:_tfTime.text],[RobotDateTime getDate:_tfEndDate.text time:_tfEndTime.text],[NSNumber numberWithInteger:warnid],_tfOtherWarn.text];
        [_delegate confirm:array];
        _thisModel.isRobotClicked = 1;
    }
}
- (void)hidekeyboard:(UITapGestureRecognizer *)sender{
    [self endEditing:YES];
}
- (IBAction)selectWarn:(id)sender {
    if(_gzArr){
        [self showDrawDown:_tfWarn];
    }else{
        [self fetchGuZList];
    }
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
    return 531;
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

-(void)showDrawDown:(UIView *)view{
    if(_gzArr.count>1){
        CGRect r = [[UIScreen mainScreen] bounds];
        //[ UIScreen mainScreen ].applicationFrame;//屏幕大小
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect=[view convertRect: view.bounds toView:window];
        CGFloat max = _gzArr.count * 40;
        CGFloat height = r.size.height -rect.origin.y;//view距离底部的距离
        int standardHeight = 320;
        CGFloat realHeight = [self minHeight:max height2:height height3:standardHeight];
        rect.size.height = realHeight;
        rect.origin.x = rect.origin.x-15;
        rect.size.width = rect.size.width+30;
        _gzAlertV = [[NewDeviceScrollView alloc] initWithFrame:rect];
        _gzAlertV.tag = 4000;
        [_gzAlertV setData:_gzArr];
        _gzAlertV.delegate = self;
        [_gzAlertV showWithFatherV:window];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchWindow)];
        tapGes.delegate = self;
        [window addGestureRecognizer:tapGes];
    }else if(_gzArr.count ==1){
        _warn = _gzArr[0];
        _tfWarn.text = _warn.warnname;
    }
    
}

-(void)touchWindow{
    [_gzAlertV disshow];
}

#pragma NewDeviceScrollViewDelegate
- (void)didSelectValue:(id)value withSelf:(NewDeviceScrollView *)sender witnIndex:(NSInteger)index{
    if(sender.tag == 4000){
        _warn = (WarningModel *)value;
        _tfWarn.text = _warn.warnname;
    }
    
}


-(CGFloat)minHeight:(CGFloat)height1 height2:(CGFloat)height2 height3:(CGFloat)height3{
    CGFloat result = height1;
    if (result>height2) {
        result = height2;
    }
    if (result>height3) {
        result = height3;
    }
    return result;
}

/**
 请求故障列表
 */
- (void)fetchGuZList
{
    UserModel *user = [AppUtils readUser];
    NSDictionary *dic = @{@"userid" : @(user.userid),
                          @"type" : [NSObject changeType:user.type],
                          @"usertype" : [NSObject changeType:user.usertype]};
    [[DQServiceInterface sharedInstance] dq_getFaultdata:dic success:^(id result) {
        if (result != nil) {
            NSMutableArray *list = (NSMutableArray *)result;
            _gzArr = [list safeObjectAtIndex:0];
            [_gzAlertV setData:_gzArr];
             [self showDrawDown:_tfWarn];
        }
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    DQLog(@"%@",NSStringFromClass(object_getClass(touch.view)));
    if ([NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
@end

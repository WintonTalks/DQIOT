//
//  NewDeviceDetailCell.m
//  WebThings
//
//  Created by machinsight on 2017/6/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NewDeviceDetailCell.h"
#import "NewDeviceScrollView.h"
#import "GetDevicemodelListWI.h"
#import "BRDatePickerView.h"

@interface NewDeviceDetailCell()<NewDeviceScrollViewDelegate>
/**设备品牌父视图*/@property (weak, nonatomic) IBOutlet UIView *sbppFatherV;
/** 设备品牌父视图手势*/@property (nonatomic,strong) UITapGestureRecognizer *pdxhFatherGes;
/** 设备品牌 弹出框*/@property (nonatomic,strong) NewDeviceScrollView *pdxhAlertV;
/** 设备品牌 数据源*/@property (nonatomic,strong)NSMutableArray *pdxhArr;
/**设备品牌输入*/@property (weak, nonatomic) IBOutlet MDTextField *sbppTV;

/**设备型号父视图*/@property (weak, nonatomic) IBOutlet UIView *sbxhFatherV;
/** 设备型号父视图手势*/@property (nonatomic,strong) UITapGestureRecognizer *sbxhFatherGes;
/** 设备型号 弹出框*/@property (nonatomic,strong) NewDeviceScrollView *sbxhAlertV;
/**设备型号输入*/@property (weak, nonatomic) IBOutlet MDTextField *sbxhTV;

/**租赁价格*/@property (weak, nonatomic) IBOutlet MDTextField *zljgTV;

/**预埋件安装时间父视图*/@property (weak, nonatomic) IBOutlet UIView *ymjazFatherV;
/** 预埋件安装时间父视图手势*/@property (nonatomic,strong) UITapGestureRecognizer *ymjazFatherGes;
///**预埋件安装时间选择器*/@property(nonatomic) EMI_MDDatePickerAlert *ymjazdatePicker;
/**预埋件安装时间*/@property (weak, nonatomic) IBOutlet MDTextField *ymjazTV;

/**安装高度*/@property (weak, nonatomic) IBOutlet MDTextField *azgdTV;

/**安装时间父视图*/@property (weak, nonatomic) IBOutlet UIView *azsjFatherV;
/** 安装时间父视图手势*/@property (nonatomic,strong) UITapGestureRecognizer *azsjFatherGes;
///**安装时间选择器*/@property(nonatomic) EMI_MDDatePickerAlert *azsjdatePicker;
/**安装时间*/@property (weak, nonatomic) IBOutlet MDTextField *azsjTV;

/**安装地点*/@property (weak, nonatomic) IBOutlet MDTextField *azddTV;

/**使用时间父视图*/@property (weak, nonatomic) IBOutlet UIView *sysjFatherV;
/** 使用时间父视图手势*/@property (nonatomic,strong) UITapGestureRecognizer *sysjFatherGes;
///**使用时间选择器*/@property(nonatomic) EMI_MDDatePickerAlert *sysjdatePicker;
/**使用时间*/@property (weak, nonatomic) IBOutlet MDTextField *sysjTV;

@property (nonatomic,assign)NSInteger deviceid;

@end
@implementation NewDeviceDetailCell

+ (id)cellWithTableView:(UITableView *)tableview{
    NewDeviceDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:@"NewDeviceDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewDeviceDetailCell" owner:nil options:nil] objectAtIndex:0];
    }
    [cell initView];
    return cell;
}

- (void)initView {
    
    [self initGesture:_pdxhFatherGes withSelTag:0 withView:_sbppFatherV];
    [self initGesture:_sbxhFatherGes withSelTag:1 withView:_sbxhFatherV];
    [self initGesture:_ymjazFatherGes withSelTag:2 withView:_ymjazFatherV];
    [self initGesture:_azsjFatherGes withSelTag:3 withView:_azsjFatherV];
    [self initGesture:_sysjFatherGes withSelTag:4 withView:_sysjFatherV];
    
    [_zljgTV setKeyboardType:UIKeyboardTypeDecimalPad];
    [_azgdTV setKeyboardType:UIKeyboardTypeNumberPad];
    
    if (!_pdxhAlertV) {
        _pdxhAlertV = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(20, 69, screenWidth-16-38, 223)];
        _pdxhAlertV.tag = 0;
        _pdxhAlertV.delegate = self;
    }
    
    if (!_sbxhAlertV) {
        _sbxhAlertV = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(20, 138, screenWidth-16-38, 223)];
        _sbxhAlertV.tag = 1;
        _sbxhAlertV.delegate = self;
    }
}

#pragma 初始化手势
- (void)initGesture:(UITapGestureRecognizer *)ges withSelTag:(int)tag withView:(UIView *)aimView{
    NSString *selStr;
    switch (tag) {
        case 0:
            selStr = @"gesTap0:";
            break;
        case 1:
            selStr = @"gesTap1:";
            break;
        case 2:
            selStr = @"gesTap2:";
            break;
        case 3:
            selStr = @"gesTap3:";
            break;
        case 4:
            selStr = @"gesTap4:";
            break;
        default:
            break;
    }
    if (!ges) {
        ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(selStr)];
        [aimView addGestureRecognizer:ges];
    }
}

/**
 设备品牌手势
 */
- (void)gesTap0:(UITapGestureRecognizer *)sender{
    
    if (_pdxhAlertV.hidden) {
        [_pdxhAlertV showWithFatherV:self.contentView];
    } else {
        [_pdxhAlertV disshow];
    }
    
    [self.contentView endEditing:YES];
    [_sbxhAlertV disshow];
}

/**
 设备型号手势
 */
- (void)gesTap1:(UITapGestureRecognizer *)sender{
    if (![_sbppTV.text length]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请先选择设备品牌" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    
    if (_sbxhAlertV.hidden) {
        [_sbxhAlertV showWithFatherV:self.contentView];
    } else {
        [_sbxhAlertV disshow];
    }
    
    [self.contentView endEditing:YES];
    [_pdxhAlertV disshow];
}

/**
 预埋件安装时间
 */
- (void)gesTap2:(UITapGestureRecognizer *)sender {
    [self.contentView endEditing:YES];
    [_pdxhAlertV disshow];
    [_sbxhAlertV disshow];
    [BRDatePickerView
     showDatePickerWithTitle:@"请选择"
     dateType:UIDatePickerModeDate
     defaultSelValue:_ymjazTV.text
     minDateStr:@""
     maxDateStr:nil
     isAutoSelect:true
     resultBlock:^(NSString *selectValue) {
         _ymjazTV.text = selectValue;
    }];
}

/**
 安装时间
 */
- (void)gesTap3:(UITapGestureRecognizer *)sender {
    [BRDatePickerView
     showDatePickerWithTitle:@"请选择"
     dateType:UIDatePickerModeDate
     defaultSelValue:_azsjTV.text
     minDateStr:@""
     maxDateStr:nil
     isAutoSelect:true
     resultBlock:^(NSString *selectValue) {
         _azsjTV.text = selectValue;
    }];
    
    [self.contentView endEditing:YES];
    [_pdxhAlertV disshow];
    [_sbxhAlertV disshow];
}

/**
 使用时间
 */
- (void)gesTap4:(UITapGestureRecognizer *)sender {
    [BRDatePickerView
     showDatePickerWithTitle:@"请选择"
     dateType:UIDatePickerModeDate
     defaultSelValue:_sysjTV.text
     minDateStr:@""
     maxDateStr:nil
     isAutoSelect:true resultBlock:^(NSString *selectValue) {
         _sysjTV.text = selectValue;
    }];
    
    [self.contentView endEditing:YES];
    [_pdxhAlertV disshow];
    [_sbxhAlertV disshow];
}

/**
 保存
 @param sender sender
 */
- (IBAction)saveMethod:(MDButton *)sender {
    if (![_sbppTV.text length] || ![_sbxhTV.text length] || ![_zljgTV.text length] || ![_ymjazTV.text length] || ![_azgdTV.text length] || ![_azsjTV.text length] || ![_azddTV.text length] || ![_sysjTV.text length]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写相关数据" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    
    _m = [[DeviceModel alloc] init];
    _m.brand = _sbppTV.text;
    _m.deviceid = _deviceid;
    _m.price = [_zljgTV.text doubleValue];
    _m.projectid = _projectid;
    _m.beforehanddate = _ymjazTV.text;
    _m.high = [_azgdTV.text integerValue];
    _m.handdate = _azsjTV.text;
    _m.address = _azddTV.text;
    _m.installationsite = _azddTV.text;
    _m.starttime = _sysjTV.text;
    _m.deviceno = _sbxhTV.text;
    
    if (_delegate && [_delegate respondsToSelector:@selector(cellBtnClicked:)]) {
        [_delegate cellBtnClicked:_m];
    }
    [self setTextNil];
}

- (void)setSbppData:(NSMutableArray *)dataArray{
    _pdxhArr = dataArray;
    [_pdxhAlertV setData:dataArray];
    
    //修改时用来给编号数组赋值
    if (_sbppTV.text.length) {
        for (int i = 0; i < _pdxhArr.count; i++) {
            if ([[_pdxhArr[i] objectForKey:@"brand"] isEqualToString:_sbppTV.text]) {
                [self setSbxhData:[_pdxhArr[i] objectForKey:@"device"]];
                break;//跳出循环
            }
        }
    }
}

- (void)setSbxhData:(NSMutableArray *)dataArray {
    [_sbxhAlertV setData:dataArray];
}

#pragma devicescrolldelegat
- (void)didSelectValue:(id)value withSelf:(NewDeviceScrollView *)sender witnIndex:(NSInteger)index{
    if (sender.tag == 0) {
        //设备品牌
        _sbppTV.text = [value objectForKey:@"brand"];
        [self setSbxhData:[_pdxhArr[index] objectForKey:@"device"]];
    }else
    if (sender.tag == 1) {
        //设备型号
        _sbxhTV.text = [value objectForKey:@"deviceno"];
        _deviceid = [[value objectForKey:@"deviceid"] integerValue];
    }
}

- (void)setViewWithDeviceValues:(DeviceModel *)model{
    _m = model;
    _sbppTV.text = model.brand;
    _sbxhTV.text = model.deviceno;
    _deviceid = model.deviceid;
    _zljgTV.text = [NSString stringWithFormat:@"%.0f",model.price];
    _ymjazTV.text = [DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.beforehanddate WithOrignFormat:@"yyyy-MM-dd HH:mm:ss"];
    _azgdTV.text = [NSString stringWithFormat:@"%.0f",model.high];
    _azsjTV.text = [DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.handdate WithOrignFormat:@"yyyy-MM-dd HH:mm:ss"];
    _azddTV.text = model.installationsite;
    _sysjTV.text = [DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.starttime WithOrignFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (BOOL)judgeIsInfoFull{
    if (![_sbppTV.text length] || ![_sbxhTV.text length] || ![_zljgTV.text length] || ![_ymjazTV.text length] || ![_azgdTV.text length] || ![_azsjTV.text length] || ![_azddTV.text length] || ![_sysjTV.text length]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写相关数据" actionTitle:@"" duration:3.0];
        [t show];
        return NO;
    }else{
        _m.brand = _sbppTV.text;
        _m.deviceid = _deviceid;
        _m.price = [_zljgTV.text doubleValue];
        _m.projectid = _projectid;
        _m.beforehanddate = _ymjazTV.text;
        _m.high = [_azgdTV.text integerValue];
        _m.handdate = _azsjTV.text;
        _m.address = _azddTV.text;
        _m.installationsite = _azddTV.text;
        _m.starttime = _sysjTV.text;
        _m.deviceno = _sbxhTV.text;
        return YES;
    }
}

- (void)setTextNil{
    _sbppTV.text = nil;
    _sbxhTV.text = nil;
    _zljgTV.text = nil;
    _ymjazTV.text = nil;
    _azgdTV.text = nil;
    _azsjTV.text = nil;
    _azddTV.text = nil;
    _sysjTV.text = nil;
}
@end

//
//  DQAddNewDeriveView.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/18.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQAddNewDeriveView.h"
#import "CKRadioButton.h"
#import "MDButton.h"
#import "DriverModel.h"
@interface DQAddNewDeriveView()<CKRadioButtonDelegate>
{
    CKRadioButton *_monthMonetyBtn;
    CKRadioButton *_bGMonetyBtn;
    CKRadioButton *_sureBtn;
    CKRadioButton *_noneSureBtn;
    MDButton *_saveButton;
}
@property (nonatomic, strong) UIView *monetyView;
@property (nonatomic, strong) UIView *deriveEduView;
@property (nonatomic, strong) NSString *rentType;
@property (nonatomic, assign) NSInteger isSafe;
@end

#define checkButton_Tag  231560

@implementation DQAddNewDeriveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = true;
        [self addSubview:self.deriveNameField];
        [self addSubview:self.numberIDField];
        [self addSubview:self.phoneField];
        [self addSubview:self.monetyView];
        [self addSubview:self.gzField];
        [self addSubview:self.deriveEduView];
    }
    return self;
}

#pragma mark -CKRadioButtonDelegate
- (void)btnClicked:(CKRadioButton *)btn
{
    if (btn.tag == checkButton_Tag) {
        _bGMonetyBtn.isOn = false;
        _rentType = @"月工资";
        
    } else if (btn.tag == checkButton_Tag+1) {
        _monthMonetyBtn.isOn = false;
        _rentType = @"包干工资";
    
    } else if (btn.tag == checkButton_Tag+2) {
        _noneSureBtn.isOn = false;
        _isSafe = 0;
    
    } else {
        _sureBtn.isOn = false;
        _isSafe = 1;
    }
    
    [self endEditing:YES];
}

- (void)setInfoModel:(DriverModel *)infoModel
{
    _infoModel = infoModel;
    self.deriveNameField.text = infoModel.name;
    self.numberIDField.text = infoModel.idcard;
    self.phoneField.text = infoModel.dn;
    self.gzField.text = [NSString stringWithFormat:@"%f",infoModel.rent];
    _rentType = infoModel.renttype;
    _isSafe = infoModel.issafeteach;
}

- (void)setType:(DQAddNewDeriveViewType)type
{
    if (type == DQAddNewDeriveViewFixStyle) {
        _saveButton.hidden = true;
    }
}

- (DriverModel *)configInitDeriveModel
{
    _infoModel.name = self.deriveNameField.text;
    _infoModel.idcard = self.numberIDField.text ;
    _infoModel.dn = self.phoneField.text;
    _infoModel.rent = [self.gzField.text doubleValue];
    _infoModel.renttype = _rentType;
    _infoModel.issafeteach = _isSafe;
    return _infoModel;
}

#pragma mark -保存
- (void)onSaveBtnClick
{
    if (!self.deriveNameField.text.length || !self.numberIDField.text.length || !self.phoneField.text.length || !self.gzField.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写完整信息" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    //手机号校验
    if (![AppUtils checkPhoneNumber:self.phoneField.text]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写正确的手机号" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    //身份证校验
    if (![AppUtils checkUserID:self.numberIDField.text]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写合法的身份证信息" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }

    DriverModel *model = [[DriverModel alloc] init];
    model.name = self.deriveNameField.text;
    model.idcard = self.numberIDField.text ;
    model.dn = self.phoneField.text;
    model.rent = [self.gzField.text doubleValue];
    model.renttype = _rentType;
    model.issafeteach = _isSafe;
    [self successWithClear];
    if (self.delegate  && [self.delegate respondsToSelector:@selector(addNewDeriveWithModel:model:)]) {
        [self.delegate addNewDeriveWithModel:self model:model];
    }
}

#pragma mark -UI
- (MDTextField *)deriveNameField
{
    if (!_deriveNameField) {
        _deriveNameField = [[MDTextField alloc] initWithFrame:CGRectMake(8, 5, self.width-16, 70)];
        _deriveNameField.returnKeyType = UIReturnKeyDefault;
        _deriveNameField.normalColor = RGB_Color(129, 139, 146, 1);
        _deriveNameField.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _deriveNameField.hintColor = RGB_Color(129, 139, 146, 1);
        _deriveNameField.highlightColor = RGB_Color(60, 123, 225, 1);
        _deriveNameField.enabled = true;
        _deriveNameField.floatingLabel = true;
        _deriveNameField.highlightLabel = true;
        _deriveNameField.singleLine = true;
        _deriveNameField.label = @"司机姓名";
    }
    return _deriveNameField;
}

- (MDTextField *)numberIDField
{
    if (!_numberIDField) {
        _numberIDField = [[MDTextField alloc] initWithFrame:CGRectMake(self.deriveNameField.left, self.deriveNameField.bottom, self.deriveNameField.width, self.deriveNameField.height)];
        _numberIDField.returnKeyType = UIReturnKeyDefault;
        _numberIDField.normalColor = RGB_Color(129, 139, 146, 1);
        _numberIDField.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _numberIDField.hintColor = RGB_Color(129, 139, 146, 1);
        _numberIDField.highlightColor = RGB_Color(60, 123, 225, 1);
        _numberIDField.enabled = true;
        _numberIDField.floatingLabel = true;
        _numberIDField.highlightLabel = true;
        _numberIDField.singleLine = true;
        _numberIDField.label = @"身份证号";
    }
    return _numberIDField;
}

- (MDTextField *)phoneField
{
    if (!_phoneField) {
        _phoneField = [[MDTextField alloc] initWithFrame:CGRectMake(self.deriveNameField.left, self.numberIDField.bottom, self.deriveNameField.width, self.deriveNameField.height)];
        _phoneField.returnKeyType = UIReturnKeyDefault;
        _phoneField.normalColor = RGB_Color(129, 139, 146, 1);
        _phoneField.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _phoneField.hintColor = RGB_Color(129, 139, 146, 1);
        _phoneField.highlightColor = RGB_Color(60, 123, 225, 1);
        _phoneField.enabled = true;
        _phoneField.floatingLabel = true;
        _phoneField.highlightLabel = true;
        _phoneField.singleLine = true;
        _phoneField.label = @"联系电话";
    }
    return _phoneField;
}

- (UIView *)monetyView
{
    if (!_monetyView) {
        _monetyView = [[UIView alloc] initWithFrame:CGRectMake(self.phoneField.left, self.phoneField.bottom, self.phoneField.width, 80)];
        _monetyView.backgroundColor = [UIColor whiteColor];
        _monetyView.userInteractionEnabled = true;
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 70, 18)];
        typeLabel.text = @"工资类型";
        typeLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        typeLabel.font = [UIFont dq_regularSystemFontOfSize:14];
        typeLabel.textAlignment = NSTextAlignmentLeft;
        [_monetyView addSubview:typeLabel];
        
        _monthMonetyBtn = [[CKRadioButton alloc] initWithFrame:CGRectMake(typeLabel.left, typeLabel.bottom+10, 16, 16)];
        _monthMonetyBtn.rippleColor = [UIColor colorWithHexString:@"#DFEBFB"];
        _monthMonetyBtn.isOn = true;
        _monthMonetyBtn.delegate = self;
        _monthMonetyBtn.tag = checkButton_Tag;
        [_monetyView addSubview:_monthMonetyBtn];
        
        NSString *zjText = @"月工资";
        NSString *sfText = @"包干工资";
        _rentType = @"月工资";
        UIFont *font = [UIFont dq_regularSystemFontOfSize:14];
        CGFloat width = [AppUtils textWidthSystemFontString:zjText height:20 font:font];
        CGFloat sfWidth = [AppUtils textWidthSystemFontString:sfText height:20 font:font];
        
        UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(_monthMonetyBtn.right+2, _monthMonetyBtn.top, width, 18)];
        userLabel.text = zjText;
        userLabel.font = font;
        userLabel.textColor = [UIColor colorWithHexString:@"#212526"];
        [_monetyView addSubview:userLabel];
        
        _bGMonetyBtn = [[CKRadioButton alloc] initWithFrame:CGRectMake(userLabel.right+40, userLabel.top, 16, 16)];
        _bGMonetyBtn.rippleColor = [UIColor colorWithHexString:@"#DFEBFB"];
        _bGMonetyBtn.isOn = false;
        _bGMonetyBtn.delegate = self;
        _bGMonetyBtn.tag = checkButton_Tag+1;
        [_monetyView addSubview:_bGMonetyBtn];
        
        UILabel *sfLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bGMonetyBtn.right+2, _bGMonetyBtn.top, sfWidth, 18)];
        sfLabel.text = sfText;
        sfLabel.font = font;
        sfLabel.textColor = [UIColor colorWithHexString:@"#212526"];
        [_monetyView addSubview:sfLabel];
        
    }
    return _monetyView;
}

- (MDTextField *)gzField
{
    if (!_gzField) {
        _gzField = [[MDTextField alloc] initWithFrame:CGRectMake(self.monetyView.left, self.monetyView.bottom+5, self.monetyView.width, self.phoneField.height)];
        _gzField.returnKeyType = UIReturnKeyDefault;
        _gzField.normalColor = RGB_Color(129, 139, 146, 1);
        _gzField.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _gzField.hintColor = RGB_Color(129, 139, 146, 1);
        _gzField.highlightColor = RGB_Color(60, 123, 225, 1);
        _gzField.enabled = true;
        _gzField.floatingLabel = true;
        _gzField.highlightLabel = true;
        _gzField.singleLine = true;
        _gzField.label = @"工资";
    }
    return _gzField;
}

- (UIView *)deriveEduView
{
    if (!_deriveEduView) {
        _deriveEduView = [[UIView alloc] initWithFrame:CGRectMake(self.gzField.left, self.gzField.bottom, self.gzField.width, self.gzField.height+30)];
        _deriveEduView.userInteractionEnabled = true;
        _deriveEduView.backgroundColor = [UIColor whiteColor];
        
        NSString *text = @"司机安全教育";
        _isSafe = 0;
        UIFont *font = [UIFont dq_regularSystemFontOfSize:14];
        CGFloat width = [AppUtils textWidthSystemFontString:text height:18 font:font];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, width, 18)];
        titleLabel.text = text;
        titleLabel.font = font;
        titleLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [_deriveEduView addSubview:titleLabel];
        
        _sureBtn = [[CKRadioButton alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+10, 16, 16)];
        _sureBtn.rippleColor = [UIColor colorWithHexString:@"#DFEBFB"];
        _sureBtn.isOn = true;
        _sureBtn.delegate = self;
        _sureBtn.tag = checkButton_Tag+2;
        [_deriveEduView addSubview:_sureBtn];

        UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sureBtn.right+2, _sureBtn.top, width, 18)];
        userLabel.text = @"完成";
        userLabel.font = font;
        userLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        [_deriveEduView addSubview:userLabel];
        
        _noneSureBtn = [[CKRadioButton alloc] initWithFrame:CGRectMake(_bGMonetyBtn.left, userLabel.top, 16, 16)];
        _noneSureBtn.rippleColor = [UIColor colorWithHexString:@"#DFEBFB"];
        _noneSureBtn.isOn = false;
        _noneSureBtn.delegate = self;
        _noneSureBtn.tag = checkButton_Tag+3;
        [_deriveEduView addSubview:_noneSureBtn];
        
        UILabel *sfLabel = [[UILabel alloc] initWithFrame:CGRectMake(_noneSureBtn.right+2, _noneSureBtn.top, 60, 18)];
        sfLabel.text = @"未完成";
        sfLabel.font = font;
        sfLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        [_deriveEduView addSubview:sfLabel];
        
        _saveButton = [[MDButton alloc] initWithFrame:CGRectMake(_sureBtn.left, _sureBtn.bottom+20, 80, 30)];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.backgroundColor = [UIColor colorWithHexString:@"3366cc"];
        [_saveButton addTarget:self action:@selector(onSaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_deriveEduView addSubview:_saveButton];
    }
    return _deriveEduView;
}

- (void)successWithClear
{
    self.deriveNameField.text = nil;
    self.numberIDField.text = nil;
    self.phoneField.text = nil;
    self.gzField.text = nil;
    _rentType = @"月工资";
    _isSafe = 1;
}

@end

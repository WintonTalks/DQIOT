//
//  NewDriverDetailCell.m
//  WebThings
//
//  Created by machinsight on 2017/6/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NewDriverDetailCell.h"

@interface NewDriverDetailCell()<CKRadioButtonDelegate>
@property (weak, nonatomic) IBOutlet MDTextField *sjxmTF;/**< 司机姓名*/
@property (weak, nonatomic) IBOutlet MDTextField *sfzhTF;/**< 身份证号*/
@property (weak, nonatomic) IBOutlet MDTextField *lxdhTF;/**< 联系电话*/
@property (weak, nonatomic) IBOutlet UIView *gzlxFatherV;/**< 工资类型父视图*/
@property (weak, nonatomic) IBOutlet UILabel *gzlxLab;/**< 工资类型Label*/
@property (nonatomic,strong)CKRadioButton *ygzBtn;/**< 月工资按钮*/
@property (nonatomic,strong)UILabel *ygzLab;/**< 月工资label*/
@property (nonatomic,strong)CKRadioButton *bggzBtn;/**< 包干工资按钮*/
@property (nonatomic,strong)UILabel *bggzLab;/**< 包干工资label*/
@property (weak, nonatomic) IBOutlet MDTextField *gzTF;/**< 工资*/

@property (weak, nonatomic) IBOutlet UIView *sjaqjyFatherV;/**< 司机安全教育*/
@property (weak, nonatomic) IBOutlet UILabel *sjaqjyLab;/**< 司机安全教育Lab*/
@property (nonatomic,strong)CKRadioButton *wwcBtn;/**< 未完成按钮*/
@property (nonatomic,strong)UILabel *wwcLab;/**< 未完成label*/
@property (nonatomic,strong)CKRadioButton *wcBtn;/**< 完成按钮*/
@property (nonatomic,strong)UILabel *wcLab;/**< 完成label*/
@property (weak, nonatomic) IBOutlet MDButton *saveBtn;/**< 保存按钮*/

@property (nonatomic,strong)NSString *rentType;
@property (nonatomic,assign)NSInteger isSafe;

@end
@implementation NewDriverDetailCell

+ (id)cellWithTableView:(UITableView *)tableview{
    NewDriverDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:@"NewDriverDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewDriverDetailCell" owner:nil options:nil] objectAtIndex:0];
        [cell.gzTF setKeyboardType:UIKeyboardTypeNumberPad];//工资键盘数字型
    }
    return cell;
}

- (void)setView{
    if (!_ygzBtn) {
#pragma 月工资按钮
        _ygzBtn = [[CKRadioButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_gzlxFatherV addSubview:_ygzBtn];
        _ygzBtn.sd_layout.leftSpaceToView(_gzlxFatherV, 0).topSpaceToView(_gzlxLab, 10).widthIs(16).heightIs(16);
        _ygzBtn.rippleColor = [UIColor colorWithHexString:@"#DFEBFB"];
        _ygzBtn.isOn = YES;
        _rentType = @"月工资";
        _ygzBtn.delegate = self;
        _ygzBtn.tag = 1;
#pragma 月工资Label
        _ygzLab = [[UILabel alloc] init];
        [_gzlxFatherV addSubview:_ygzLab];
        _ygzLab.sd_layout.leftSpaceToView(_ygzBtn, 8).centerYEqualToView(_ygzBtn).heightIs(20).widthIs(105);
        _ygzLab.textColor = [UIColor colorWithHexString:@"#212526"];
        _ygzLab.font = [UIFont fontWithName:@"DroidSansFallback" size:15.f];
        _ygzLab.text = @"月工资";
#pragma 包干工资按钮
        _bggzBtn = [[CKRadioButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_gzlxFatherV addSubview:_bggzBtn];
        _bggzBtn.sd_layout.leftSpaceToView(_ygzLab, 35).topSpaceToView(_gzlxLab, 10).widthIs(16).heightIs(16);
        _bggzBtn.rippleColor = [UIColor colorWithHexString:@"#DFEBFB"];
        _bggzBtn.isOn = NO;
        _bggzBtn.delegate = self;
        _bggzBtn.tag = 2;
#pragma 包干工资Label
        _bggzLab = [[UILabel alloc] init];
        [_gzlxFatherV addSubview:_bggzLab];
        _bggzLab.sd_layout.leftSpaceToView(_bggzBtn, 8).centerYEqualToView(_bggzBtn).heightIs(20).widthIs(80);
        _bggzLab.textColor = [UIColor colorWithHexString:@"#212526"];
        _bggzLab.font = [UIFont fontWithName:@"DroidSansFallback" size:15.f];
        _bggzLab.text = @"包干工资";
        
        
        
#pragma 未完成按钮
        _wwcBtn = [[CKRadioButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_sjaqjyFatherV addSubview:_wwcBtn];
        _wwcBtn.sd_layout.leftSpaceToView(_sjaqjyFatherV, 0).topSpaceToView(_sjaqjyLab, 12).widthIs(16).heightIs(16);
        _wwcBtn.rippleColor = [UIColor colorWithHexString:@"#DFEBFB"];
        _wwcBtn.isOn = YES;
        _isSafe = 0;
        _wwcBtn.delegate = self;
        _wwcBtn.tag = 3;
#pragma 未完成Label
        _wwcLab = [[UILabel alloc] init];
        [_sjaqjyFatherV addSubview:_wwcLab];
        _wwcLab.sd_layout.leftSpaceToView(_wwcBtn, 8).centerYEqualToView(_wwcBtn).heightIs(20).widthIs(105);
        _wwcLab.textColor = [UIColor colorWithHexString:@"#212526"];
        _wwcLab.font = [UIFont fontWithName:@"DroidSansFallback" size:15.f];
        _wwcLab.text = @"未完成";
#pragma 完成按钮
        _wcBtn = [[CKRadioButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_sjaqjyFatherV addSubview:_wcBtn];
        _wcBtn.sd_layout.leftSpaceToView(_wwcLab, 35).topSpaceToView(_sjaqjyLab, 12).widthIs(16).heightIs(16);
        _wcBtn.rippleColor = [UIColor colorWithHexString:@"#DFEBFB"];
        _wcBtn.isOn = NO;
        _wcBtn.delegate = self;
        _wcBtn.tag = 4;
#pragma 完成Label
        _wcLab = [[UILabel alloc] init];
        [_sjaqjyFatherV addSubview:_wcLab];
        _wcLab.sd_layout.leftSpaceToView(_wcBtn, 8).centerYEqualToView(_wcBtn).heightIs(20).widthIs(80);
        _wcLab.textColor = [UIColor colorWithHexString:@"#212526"];
        _wcLab.font = [UIFont fontWithName:@"DroidSansFallback" size:15.f];
        _wcLab.text = @"完成";
    }

}

/**
 保存

 @param sender sender
 */
- (IBAction)saveMethod:(MDButton *)sender {
    if (!_sjxmTF.text.length || !_sfzhTF.text.length || !_lxdhTF.text.length || !_gzTF.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写完整信息" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    _m = [[DriverModel alloc] init];
    _m.name = _sjxmTF.text;
    _m.idcard = _sfzhTF.text;
    _m.dn = _lxdhTF.text;
    _m.rent = [_gzTF.text doubleValue];
    _m.renttype = _rentType;
    _m.issafeteach = _isSafe;
    
    if (_delegate && [_delegate respondsToSelector:@selector(cellBtnClickedWithModel:)]) {
        [_delegate cellBtnClickedWithModel:_m];
    }
}
#pragma radioButton
- (void)btnClicked:(CKRadioButton *)btn{
    if (btn.tag == 1 && btn.isOn) {
        _rentType = @"月工资";
        _bggzBtn.isOn = NO;
        return;
    }
    if (btn.tag == 2 && btn.isOn) {
        _rentType = @"包干工资";
        _ygzBtn.isOn = NO;
    }
    if (btn.tag == 3 && btn.isOn) {
        _isSafe = 0;
        _wcBtn.isOn = NO;
        return;
    }
    if (btn.tag == 4 && btn.isOn) {
        _isSafe = 1;
        _wwcBtn.isOn = NO;
    }
}

//选择司机
- (IBAction)toChooseDriver:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(nextPageClicked)]) {
        [_delegate nextPageClicked];
    }
}

//赋值
- (void)setViewWithValues:(UserModel *)model{
    _sjxmTF.text = model.name;
    _sfzhTF.text = model.idcard;
    _lxdhTF.text = model.dn;
}

//赋值
- (void)setViewWithDriverValues:(DriverModel *)model{
    _sjxmTF.text = model.name;
    _sfzhTF.text = model.idcard;
    _lxdhTF.text = model.dn;
    if ([model.renttype isEqualToString:@"月工资"]) {
        _ygzBtn.isOn = YES;
        _bggzBtn.isOn = NO;
        _rentType = @"月工资";
    }else{
        _ygzBtn.isOn = NO;
        _bggzBtn.isOn = YES;
        _rentType = @"包干工资";
    }
    _gzTF.text = [NSString stringWithFormat:@"%.0f",model.rent];
    if (model.issafeteach == 1) {
        _wwcBtn.isOn = NO;
        _wcBtn.isOn = YES;
        _isSafe = 1;
    }else{
        _wwcBtn.isOn = YES;
        _wcBtn.isOn = NO;
        _isSafe = 0;
    }
}


- (void)hideSaveBtn{
    _saveBtn.hidden = YES;
}

- (BOOL)judgeIsInfoFull{
    if (!_sjxmTF.text.length || !_sfzhTF.text.length || !_lxdhTF.text.length || !_gzTF.text.length) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请填写完整信息" actionTitle:@"" duration:3.0];
        [t show];
        return NO;
    }else{
        _m = [[DriverModel alloc] init];
        _m.name = _sjxmTF.text;
        _m.idcard = _sfzhTF.text;
        _m.dn = _lxdhTF.text;
        _m.rent = [_gzTF.text doubleValue];
        _m.renttype = _rentType;
        _m.issafeteach = _isSafe;
        return YES;
    }
}
@end

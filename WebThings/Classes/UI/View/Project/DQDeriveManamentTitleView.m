//
//  DQDeriveManamentTitleView.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//  cell司机信息、操作权限

#import "DQDeriveManamentTitleView.h"
#import "HeadImgV.h"

@interface DQDeriveManamentTitleView()
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *authLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) HeadImgV *deriveHeadVew;
@property (nonatomic, strong) UIImageView *downView;
@property (nonatomic, strong) UIButton *editFixButton;
@end

@implementation DQDeriveManamentTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.deriveHeadVew];
        [self addSubview:self.numberLabel];
        [self addSubview:self.authLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.sexLabel];
        [self addSubview:self.ageLabel];
        [self addSubview:self.editFixButton];
        [self addSubview:self.downView];
        
        UserModel *managerModel = [AppUtils readUser];
        if ([managerModel.type isEqualToString:@"承租商"]) {
            self.downView.hidden = true;
            self.editFixButton.hidden = true;
        }
    }
    return self;
}

//操作权限
- (void)onAuthShowPullView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDerivePullStackView:)]) {
        [self.delegate didDerivePullStackView:self];
    }
}

//编辑
- (void)onEditBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeriveInfoEditclicked:)]) {
        [self.delegate didDeriveInfoEditclicked:self];
    }
}

- (void)configDriveTitleData:(DriverModel *)model
{
    _deriveHeadVew.image = [_deriveHeadVew defaultImageWithName:[model.name substringWithRange:NSMakeRange(0, 1)]];
    self.numberLabel.text = [NSString stringWithFormat:@"人员编号 %@",model.no];
    self.nameLabel.text = model.name;
    self.sexLabel.text = model.sex;
    
    if ([AppUtils isAllNum:model.sex]) {
        self.sexLabel.text = [model.sex isEqualToString:@"1"] ? @"男" : @"女";
    } else {
        self.sexLabel.text = model.sex;
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%@岁",model.age];
    [self layoutIfNeeded];
}

- (void)setInfoAuth:(NSString *)infoAuth
{
    self.authLabel.text = [NSString stringWithFormat:@"操作权限： %@",infoAuth];
//    CGFloat width = [AppUtils textWidthSystemFontString:infoAuth height:self.authLabel.height font:self.authLabel.font];
//    self.authLabel.width = width;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = [AppUtils textWidthSystemFontString:self.numberLabel.text height:self.numberLabel.height font:self.numberLabel.font];
    self.numberLabel.width = width;
    
    CGFloat nameWidth = [AppUtils textWidthSystemFontString:self.nameLabel.text height:self.nameLabel.height font:self.nameLabel.font];
    self.nameLabel.width = nameWidth;
    self.sexLabel.left = self.nameLabel.right+24;
    self.ageLabel.left = self.sexLabel.right+23;
}

#pragma mark- UI
- (HeadImgV *)deriveHeadVew
{
    if (!_deriveHeadVew) {
        _deriveHeadVew = [[HeadImgV alloc] initWithFrame:CGRectMake(16, 16, 46, 46)];
        [_deriveHeadVew borderWid:1];
        [_deriveHeadVew borderColor:[UIColor colorWithHexString:@"407ee9"]];
    }
    return _deriveHeadVew;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.deriveHeadVew.right+16, self.deriveHeadVew.top, 120, 14)];
        _numberLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
        _numberLabel.textAlignment = NSTextAlignmentLeft;
        _numberLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    }
    return _numberLabel;
}

- (UILabel *)authLabel
{
    if (!_authLabel) {
        _authLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-120-16, self.numberLabel.top, 108, 14)];
        _authLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
        _authLabel.textAlignment = NSTextAlignmentLeft;
        _authLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _authLabel.text = @"操作权限： 允许";
        _authLabel.userInteractionEnabled = true;
        [_authLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAuthShowPullView)]];
    }
    return _authLabel;
}

- (UIImageView *)downView
{
    if (!_downView) {
        _downView = [[UIImageView alloc] initWithImage:ImageNamed(@"ic_down")];
        _downView.frame = CGRectMake(self.width-16-6, self.authLabel.top+4, 6, 6);
    }
    return _downView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.numberLabel.left, self.numberLabel.bottom+16, 28, 14)];
        _nameLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    }
    return _nameLabel;
}

- (UILabel *)sexLabel
{
    if (!_sexLabel) {
        _sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.right+24, self.nameLabel.top, 14, 14)];
        _sexLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
        _sexLabel.textAlignment = NSTextAlignmentLeft;
        _sexLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    }
    return _sexLabel;
}

- (UILabel *)ageLabel
{
    if (!_ageLabel) {
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sexLabel.right+23, self.sexLabel.top, 45, 14)];
        _ageLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
        _ageLabel.textAlignment = NSTextAlignmentLeft;
        _ageLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    }
    return _ageLabel;
}

- (UIButton *)editFixButton
{
    if (!_editFixButton) {
        _editFixButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editFixButton.frame = CGRectMake(self.width-17-46, self.ageLabel.top, 46, 13);
        [_editFixButton setTitle:@"编辑" forState:UIControlStateNormal];
        _editFixButton.titleLabel.font = [UIFont dq_regularSystemFontOfSize:12];
        [_editFixButton setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
        [_editFixButton setImage:ImageNamed(@"icon_edit") forState:UIControlStateNormal];
        [_editFixButton layoutButtonWithEdgeInsetsStyle:TQButtonEdgeInsetsStyleLeft imageTitleSpace:8];
        [_editFixButton addTarget:self action:@selector(onEditBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editFixButton;
}

@end

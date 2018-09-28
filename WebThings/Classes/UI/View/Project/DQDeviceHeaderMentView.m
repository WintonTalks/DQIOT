//
//  DQDeviceHeaderMentView.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQDeviceHeaderMentView.h"

@interface DQDeviceHeaderMentView()
{
    CGFloat _left;
    CGFloat _right;
    CGFloat _offX;
    CGFloat _spaX;
}
@property (nonatomic, strong) UIButton *manageMentBtn;
@property (nonatomic, strong) UIButton *deviceListBtn;
@property (nonatomic, strong) UIButton *dealingsBtn;
@property (nonatomic, strong) UIView   *xLineView;
@end

@implementation DQDeviceHeaderMentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = true;
        _spaX = 68*screenWidth/375;
        [self addSubview:self.manageMentBtn];
        [self addSubview:self.deviceListBtn];
        [self addSubview:self.dealingsBtn];
        [self addSubview:self.xLineView];
        _left = self.manageMentBtn.left+(self.manageMentBtn.width-20)/2;
        _right = self.deviceListBtn.left+(self.deviceListBtn.width-20)/2;
        _offX = self.dealingsBtn.left+(self.dealingsBtn.width-20)/2;
        self.xLineView.left = _left;
        self.manageMentBtn.selected = true;
    }
    return self;
}

- (UIButton *)manageMentBtn
{
    if (!_manageMentBtn) {
        NSString *text = @"人员管理";
        UIFont *font = [UIFont dq_semiboldSystemFontOfSize:16];
        CGFloat height = self.height-2;
        CGFloat width = [AppUtils textWidthSystemFontString:text height:height font:font];
        _manageMentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _manageMentBtn.frame = CGRectMake(25*screenWidth/375, 0, width, height);
        [_manageMentBtn setTitle:text forState:UIControlStateNormal];
        _manageMentBtn.titleLabel.font = font;
        [_manageMentBtn setTitleColor:[UIColor colorWithHexString:@"#B9B9B9"] forState:UIControlStateNormal];
        [_manageMentBtn setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateSelected];
        [_manageMentBtn addTarget:self action:@selector(onManageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _manageMentBtn;
}

- (UIButton *)deviceListBtn
{
    if (!_deviceListBtn) {
        _deviceListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deviceListBtn.frame = CGRectMake(self.manageMentBtn.right+_spaX, self.manageMentBtn.top, self.manageMentBtn.width, self.manageMentBtn.height);
        [_deviceListBtn setTitle:@"设备列表" forState:UIControlStateNormal];
        _deviceListBtn.titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:16];
        [_deviceListBtn setTitleColor:[UIColor colorWithHexString:@"#B9B9B9"] forState:UIControlStateNormal];
        [_deviceListBtn setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateSelected];
        [_deviceListBtn addTarget:self action:@selector(onDeviceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deviceListBtn;
}

- (UIButton *)dealingsBtn
{
    if (!_dealingsBtn) {
        _dealingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dealingsBtn.frame = CGRectMake(self.deviceListBtn.right+_spaX, self.manageMentBtn.top, self.manageMentBtn.width, self.manageMentBtn.height);
        [_dealingsBtn setTitle:@"商务往来" forState:UIControlStateNormal];
        _dealingsBtn.titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:16];
        [_dealingsBtn setTitleColor:[UIColor colorWithHexString:@"#B9B9B9"] forState:UIControlStateNormal];
        [_dealingsBtn setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateSelected];
        [_dealingsBtn addTarget:self action:@selector(onDealingsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dealingsBtn;
}

- (UIView *)xLineView
{
    if (!_xLineView) {
        _xLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-2, 20, 2)];
        _xLineView.backgroundColor = [UIColor colorWithHexString:COLOR_BLACK];
    }
    return _xLineView;
}

/**
 人员管理
 */
- (void)onManageBtnClick
{
    self.manageMentBtn.selected = true;
    self.deviceListBtn.selected = false;
    self.dealingsBtn.selected = false;
    self.xLineView.left = _left;
    if (self.headerMentBlock) {
        self.headerMentBlock(0);
    }
}

/**
 设备列表
 */
- (void)onDeviceBtnClick
{
    self.manageMentBtn.selected = false;
    self.dealingsBtn.selected = false;
    self.deviceListBtn.selected = true;
    self.xLineView.left = _right;
    if (self.headerMentBlock) {
        self.headerMentBlock(1);
    }
}

/**
 商务往来
 */
- (void)onDealingsBtnClick
{
    self.manageMentBtn.selected = false;
    self.deviceListBtn.selected = false;
    self.dealingsBtn.selected = true;
    self.xLineView.left = _offX;
    if (self.headerMentBlock) {
        self.headerMentBlock(2);
    }
}

@end

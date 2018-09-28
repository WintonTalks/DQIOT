//
//  DQDeviceListCell.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQDeviceListCell.h"

@interface DQDeviceListCell()
@property (nonatomic, strong) UILabel *deviceNameLb;
@property (nonatomic, strong) UILabel *deviceAddressLb;
@property (nonatomic, strong) UILabel *deviceTypeLb;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *shadowView;
@end

@implementation DQDeviceListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.deviceNameLb];
        [self.contentView addSubview:self.deviceAddressLb];
        [self.contentView addSubview:self.shadowView];
        [self.shadowView addSubview:self.progressView];
        [self.contentView addSubview:self.deviceTypeLb];
    }
    return self;
}

- (UILabel *)deviceNameLb
{
    if (!_deviceNameLb) {
        _deviceNameLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _deviceNameLb.font = [UIFont dq_semiboldSystemFontOfSize:14];
        _deviceNameLb.textColor = [UIColor colorWithHexString:COLOR_BLUE];
        _deviceNameLb.textAlignment = NSTextAlignmentLeft;
    }
    return _deviceNameLb;
}

- (UILabel *)deviceAddressLb
{
    if (!_deviceAddressLb) {
        _deviceAddressLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _deviceAddressLb.font = [UIFont dq_regularSystemFontOfSize:12];
        _deviceAddressLb.textColor = [UIColor colorWithHexString:COLOR_TITLE_GRAY];
        _deviceAddressLb.textAlignment = NSTextAlignmentLeft;
    }
    return _deviceAddressLb;
}

- (UILabel *)deviceTypeLb
{
    if (!_deviceTypeLb) {
        _deviceTypeLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _deviceTypeLb.font = [UIFont dq_regularSystemFontOfSize:12];
        _deviceTypeLb.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _deviceTypeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _deviceTypeLb;
}

- (UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectZero];
        _shadowView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _shadowView;
}

- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectZero];
        _progressView.backgroundColor = [UIColor colorWithHexString:@"#417EE8"];
        _progressView.layer.cornerRadius = 3;
        _progressView.layer.shadowColor = RGB_Color(185, 211, 248, 1).CGColor;
        _progressView.layer.shadowOffset = CGSizeMake(0,2);
        _progressView.layer.shadowOpacity = 1.0;
        _progressView.layer.shadowRadius = 4;
    }
    return _progressView;
}

- (void)configDeviceListWithModel:(DeviceModel *)model
{
    self.deviceNameLb.text = [NSString stringWithFormat:@"设备名称：%@",[NSObject changeType:model.deviceno]];
    self.deviceAddressLb.text = [NSString stringWithFormat:@"安装地点：%@",model.installationsite];
    self.progressView.width = model.fidstate/10.0*(self.contentView.width-32);
    self.deviceTypeLb.text = [NSString stringWithFormat:@"设备阶段：%@",model.statedesc];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat nameWidth = [AppUtils textWidthSystemFontString:self.deviceNameLb.text height:18 font:self.deviceNameLb.font];
    CGFloat addressWidth = [AppUtils textWidthSystemFontString:self.deviceAddressLb.text height:18 font:self.deviceAddressLb.font];
    CGFloat typeWidth = [AppUtils textWidthSystemFontString:self.deviceTypeLb.text height:12 font:self.deviceTypeLb.font];
    
    self.deviceNameLb.frame = CGRectMake(16, 16, nameWidth, 18);
    self.deviceAddressLb.frame = CGRectMake(self.deviceNameLb.left, self.deviceNameLb.bottom+16, addressWidth, 18);
    self.shadowView.frame = CGRectMake(16, self.deviceAddressLb.bottom+16, self.contentView.width-32, 6);
    self.progressView.left = 0;
    self.progressView.top = 0;
    self.progressView.height = 6;
    self.deviceTypeLb.frame = CGRectMake(self.contentView.width-16-typeWidth, self.shadowView.bottom+16, typeWidth, 12);
}

@end

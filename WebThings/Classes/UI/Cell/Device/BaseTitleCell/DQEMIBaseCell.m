//
//  DQEMIBaseCell.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQEMIBaseCell.h"

@interface DQEMIBaseCell()
@property (nonatomic, strong) UILabel *leftNameLabel;
@end

@implementation DQEMIBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.leftNameLabel];
    }
    return self;
}

- (UILabel *)leftNameLabel
{
    if (!_leftNameLabel) {
        _leftNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftNameLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _leftNameLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
        _leftNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftNameLabel;
}

- (void)setConfigLeftName:(NSString *)configLeftName
{
    _configLeftName = configLeftName;
    self.leftNameLabel.text = configLeftName;
    [self layoutIfNeeded];
}

- (void)setConfigLeftFont:(UIFont *)configLeftFont
{
    self.leftNameLabel.font = configLeftFont;
    [self layoutIfNeeded];
}

- (void)setConfigLeftTitleColor:(NSString *)configLeftTitleColor
{
    self.leftNameLabel.textColor = [UIColor colorWithHexString:configLeftTitleColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = [AppUtils textWidthSystemFontString:_configLeftName height:18 font:self.leftNameLabel.font];
    
    CGFloat top = self.contentView.height>125 ? 8 : (self.contentView.height-25)/2;
    self.leftNameLabel.frame = CGRectMake(16, top, width, 14);
}

@end

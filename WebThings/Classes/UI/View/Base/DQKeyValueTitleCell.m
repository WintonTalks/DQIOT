//
//  DQKeyValueTitleCell.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/20.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQKeyValueTitleCell.h"

@interface DQKeyValueTitleCell()
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@end

@implementation DQKeyValueTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightLabel];
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 0, 18)];
        _leftLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _leftLabel.font = [UIFont dq_regularSystemFontOfSize:14];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 0, 18)];
        _rightLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _rightLabel.font = [UIFont dq_regularSystemFontOfSize:14];
        _rightLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rightLabel;
}

- (void)setKeyTitle:(NSString *)keyTitle
{
    _keyTitle = keyTitle;
    self.leftLabel.text = keyTitle;
    CGFloat width = [AppUtils textWidthSystemFontString:keyTitle height:18 font:self.leftLabel.font];
    self.leftLabel.width = width;
    self.leftLabel.top = (self.contentView.height-18)/2;
}

- (void)setValueTitle:(NSString *)valueTitle
{
    _valueTitle = valueTitle;
    self.rightLabel.text = valueTitle;
    CGFloat width = [AppUtils textWidthSystemFontString:valueTitle height:18 font:self.rightLabel.font];
    self.rightLabel.width = width;
    self.rightLabel.top = self.leftLabel.top;
}

- (void)configKey:(NSString *)key value:(NSString *)value
{
    self.leftLabel.text = key;
    self.rightLabel.text = value;
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = [AppUtils textWidthSystemFontString:self.leftLabel.text height:18 font:self.leftLabel.font];
    self.leftLabel.width = width;
    self.leftLabel.top = (self.contentView.height-18)/2;
    
    CGFloat mWidth = [AppUtils textWidthSystemFontString:self.rightLabel.text height:18 font:self.rightLabel.font];
    self.rightLabel.width = mWidth;
    self.rightLabel.top = self.leftLabel.top;
}

@end

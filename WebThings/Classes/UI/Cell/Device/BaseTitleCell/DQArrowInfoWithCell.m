//
//  DQArrowInfoWithCell.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//  右边带箭头cell，左边文字

#import "DQArrowInfoWithCell.h"

@interface DQArrowInfoWithCell()
@property (nonatomic, strong) UIImageView *arrowView;
@end

@implementation DQArrowInfoWithCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.arrowView];
    }
    return self;
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:ImageNamed(@"icon_indictor")];
        _arrowView.frame = CGRectZero;
    }
    return _arrowView;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 18)];
        _rightLabel.textColor = [UIColor colorWithHexString:@"303030"];
        _rightLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
        _rightLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rightLabel;
}

- (void)setConfigRightTitle:(NSString *)configRightTitle
{
    _configRightTitle = configRightTitle;
    self.rightLabel.text = configRightTitle;
    CGFloat width = [AppUtils textWidthSystemFontString:configRightTitle height:18 font: self.rightLabel.font];
    self.rightLabel.left = self.contentView.width-16-13-width;
    self.rightLabel.top = (self.contentView.height-18)/2;
    self.rightLabel.width = width;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = self.contentView.height;
    CGFloat width = [AppUtils textWidthSystemFontString:self.rightLabel.text height:18 font: self.rightLabel.font];
    self.arrowView.frame = CGRectMake(self.contentView.width-16-7, (height-11)/2, 7, 11);
    self.rightLabel.left =  self.arrowView.left-7-width;
    self.rightLabel.top = (self.contentView.height-18)/2;
    self.rightLabel.width = width;
}

@end

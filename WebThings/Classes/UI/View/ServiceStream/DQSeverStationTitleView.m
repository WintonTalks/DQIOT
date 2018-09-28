//
//  DQSeverStationTitleView.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQSeverStationTitleView.h"

@interface DQSeverStationTitleView()
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@end

@implementation DQSeverStationTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
    }
    return self;
}

- (void)configLeftName:(NSString *)title
{
    self.leftLabel.text = title;
    CGFloat width = [AppUtils textWidthSystemFontString:title height:self.leftLabel.height font:self.leftLabel.font];
    self.leftLabel.width = width;
}

- (void)configRightName:(NSString *)title
{
    self.rightLabel.text = title;
    CGFloat width = [AppUtils textWidthSystemFontString:title height:22 font:self.rightLabel.font];
    self.rightLabel.width = width;
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.rightLabel.left = self.width-140;

}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 0, 24)];
        _leftLabel.font = [UIFont dq_regularSystemFontOfSize:12];
        _leftLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.leftLabel.top, 0, 24)];
        _rightLabel.font = [UIFont dq_regularSystemFontOfSize:12];
        _rightLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _rightLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rightLabel;
}

@end

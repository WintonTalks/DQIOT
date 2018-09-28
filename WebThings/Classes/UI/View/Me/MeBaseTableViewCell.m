//
//  MeBaseTableViewCell.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/5.
//  Copyright © 2017年 陈凯. All rights reserved.
//

#import "MeBaseTableViewCell.h"

@interface MeBaseTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightArrowView;
@end

@implementation MeBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.rightArrowView];
    }
    return self;
}

- (void)configTitleWithCell:(NSString *)text
{
    self.titleLabel.text = text;
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = self.contentView.height;
    CGFloat width = [AppUtils textWidthSystemFontString:self.titleLabel.text height:25 font:self.titleLabel.font];
    self.titleLabel.frame = CGRectMake(14, (height-25)/2, width, 25);
    self.rightArrowView.frame = CGRectMake(self.contentView.width-16-7, (height-11)/2, 7, 11);
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor colorWithHexString:@"303030"];
        _titleLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIImageView *)rightArrowView
{
    if (!_rightArrowView) {
        _rightArrowView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightArrowView.image = ImageNamed(@"icon_indictor");
    }
    return _rightArrowView;
}

@end

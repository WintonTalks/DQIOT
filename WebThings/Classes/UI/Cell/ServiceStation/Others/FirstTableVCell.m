//
//  FirstTableVCell.m
//  WebThings
//
//  Created by machinsight on 2017/6/21.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "FirstTableVCell.h"
@interface FirstTableVCell()
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIImageView *arrowView;
@end

@implementation FirstTableVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.arrowView];
    }
    return self;
}

- (void)setViewWithValues:(NSString *)str
{
    self.nameLab.text = str;
    [self layoutIfNeeded];
}

- (void)setImgvHide:(BOOL)hide
{
    self.arrowView.hidden = hide;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = [AppUtils textWidthSystemFontString:self.nameLab.text height:20 font:self.nameLab.font];    width = width > 240 ? 240 : width;
    self.nameLab.frame = CGRectMake(12, 13, width, 18);
    if (!self.arrowView.hidden) {
        self.arrowView.frame = CGRectMake(self.contentView.width-6-15, 13, 15, 15);
    }
}

- (UILabel *)nameLab
{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLab.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _nameLab.font = [UIFont dq_regularSystemFontOfSize:14];
        _nameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLab;
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowView.image = ImageNamed(@"ic_expand_more");
    }
    return _arrowView;
}


@end

//
//  EvaluateReplyCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EvaluateReplyCell.h"
#import "EMICardView.h"

@interface EvaluateReplyCell()
{
    int _direction;
}
@property (nonatomic, strong) EMICardView *cardView;
@property (nonatomic, strong) UIView *xLineView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, assign) CGFloat fatherVLeading;

@end

@implementation EvaluateReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      self.contentView.backgroundColor = [UIColor clearColor];
      [self configUI];
    }
    return self;
}

- (void)configUI
{
    _direction = 0;
    [self.contentView addSubview:self.xLineView];
    [self.contentView addSubview:self.cardView];
    [self.cardView addSubview:self.infoView];
    [self.infoView addSubview:self.iconView];
    [self.infoView addSubview:self.titleLabel];
}

- (UIView *)xLineView
{
    if (!_xLineView) {
        _xLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _xLineView.backgroundColor = [UIColor colorWithHexString:@"#3366cc"];
    }
    return _xLineView;
}

- (EMICardView *)cardView
{
    if (!_cardView) {
        _cardView = [[EMICardView alloc] initWithFrame:CGRectZero];
        _cardView.backgroundColor = [UIColor whiteColor];
    }
    return _cardView;
}

- (UIView *)infoView
{
    if (!_infoView) {
        _infoView = [[UIView alloc] initWithFrame:CGRectZero];
        _infoView.backgroundColor = [UIColor whiteColor];
    }
    return _infoView;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconView.image = ImageNamed(@"ic_sure");
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont dq_lightSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.xLineView.frame = CGRectMake(36, 0, 1, self.contentView.height);
    CGFloat width = [AppUtils textWidthSystemFontString:self.titleLabel.text height:19 font:self.titleLabel.font];
    self.cardView.frame = CGRectMake(self.fatherVLeading, 13, 245*autoSizeScaleX, self.contentView.height-26);
    self.infoView.frame = self.cardView.bounds;
    if (_direction == 0) {
        self.iconView.frame = CGRectMake(12, (self.infoView.height-19)/2, 19, 19);
        self.titleLabel.frame = CGRectMake(self.iconView.right+10, self.iconView.top, width, 19);
    } else {
        self.iconView.frame = CGRectMake(self.infoView.width-12-19, (self.infoView.height-19)/2, 19, 19);
        self.titleLabel.frame = CGRectMake(self.iconView.left-10-width, self.iconView.top, width, 19);
    }
}

- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model
{
    _direction = model.direction;
    if (model.direction == 0) {
        //0居左
        self.fatherVLeading = 51;
    }else{
        //1居右
        self.fatherVLeading = screenWidth-245*autoSizeScaleX-16;
    }
    
    if (model.serviceevaluate) {
        self.titleLabel.text = model.serviceevaluate.note;
    }else {
        self.titleLabel.text = model.title;
    }
}

- (CGFloat)cellHeightWithModel:(ServiceCenterBaseModel *)model
{
    CGFloat height = [AppUtils textHeightSystemFontString:self.titleLabel.text height:245*autoSizeScaleX-20 font:self.titleLabel.font];
    return 24+height+1+26;
}

@end

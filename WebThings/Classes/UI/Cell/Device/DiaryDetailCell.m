//
//  DiaryDetailCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/6.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DiaryDetailCell.h"

@interface DiaryDetailCell()
@property (nonatomic, strong) UIView  *baseView;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *stateLab;
@end

@implementation DiaryDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.baseView];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.stateLab];
    }
    return self;
}

- (UIView *)baseView
{
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _baseView;
}

- (UILabel *)contentLab
{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLab.font = [UIFont dq_semiboldSystemFontOfSize:14];
        _contentLab.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _contentLab.textAlignment = NSTextAlignmentLeft;
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

- (UILabel *)stateLab
{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _stateLab.font = [UIFont dq_semiboldSystemFontOfSize:12];
        _stateLab.textAlignment = NSTextAlignmentLeft;
    }
    return _stateLab;
}

- (void)setViewValuesWithModel:(CheckModel *)model
{
    self.contentLab.text = model.checktype;
    self.stateLab.text = model.checkstate;
    self.stateLab.textColor = [model getColor];
    self.baseView.backgroundColor = [model getColor];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.baseView.frame = CGRectMake(36, (self.contentView.height-8)/2, 8, 8);
    [self.baseView withRadius:4.f];
    
    CGSize size = [AppUtils textSizeFromTextString:self.contentLab.text width:183 height:200 font:self.contentLab.font];
    self.contentLab.frame = CGRectMake(self.baseView.right+8, (self.contentView.height-size.height)/2, size.width, size.height);
    
    CGFloat stateWidth = [AppUtils textWidthSystemFontString:self.stateLab.text height:12 font:self.stateLab.font];
    self.stateLab.frame = CGRectMake(self.contentView.width-stateWidth-36, (self.contentView.height-12)/2, stateWidth, 12);
}


@end


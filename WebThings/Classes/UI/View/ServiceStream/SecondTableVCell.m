//
//  SecondTableVCell.m
//  WebThings
//
//  Created by machinsight on 2017/6/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "SecondTableVCell.h"

@interface SecondTableVCell()<CKCheckBoxButtonDelegate>
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) CKCheckBoxButton *checkBtn;/**< 多选框*/
@end

@implementation SecondTableVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.checkBtn];
    }
    return self;
}

#pragma CKCheckBoxButtondelegate
- (void)btnClicked:(CKCheckBoxButton *)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(cellcekBtnClicked:indexPath:)]) {
        [_delegate cellcekBtnClicked:btn indexPath:self.thisIndexPath];
    }
}

- (void)setViewWithValues:(NSString *)str
{
    _nameLab.text = str;
    [self layoutIfNeeded];
}

- (void)setCheckState:(BOOL)checkState
{
    _checkState = checkState;
    self.checkBtn.isOn = checkState;
}

- (UILabel *)nameLab
{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLab.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _nameLab.font = [UIFont dq_regularSystemFontOfSize:14];
        _nameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLab;
}

- (CKCheckBoxButton *)checkBtn
{
    if (!_checkBtn) {
        _checkBtn = [[CKCheckBoxButton alloc] initWithFrame:CGRectZero];
        _checkBtn.rippleColor = [UIColor colorWithHexString:@"#DFEBFB"];
        _checkBtn.isOn = NO;
        _checkBtn.delegate = self;
    }
    return _checkBtn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = [AppUtils textWidthSystemFontString:self.nameLab.text height:18 font:self.nameLab.font];
    self.nameLab.frame = CGRectMake(12, 5, width, 18);
    self.checkBtn.frame = CGRectMake(self.contentView.width-25-10, (self.contentView.height-25)/2, 25, 25);
}

@end

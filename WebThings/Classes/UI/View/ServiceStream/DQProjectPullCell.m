//
//  DQProjectPullCell.m
//  WebThings
//
//  Created by winton on 2017/10/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQProjectPullCell.h"

@interface DQProjectPullCell()
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *checkBtn;
@end

@implementation DQProjectPullCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 0, 14)];
        _titleLb.font = [UIFont dq_regularSystemFontOfSize:14];
        _titleLb.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        [self.contentView addSubview:_titleLb];
        
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBtn.frame = CGRectZero;
        [_checkBtn setImage:ImageNamed(@"ic_check_circle_hui") forState:UIControlStateNormal];
        [_checkBtn setImage:ImageNamed(@"ic_check_circle") forState:UIControlStateSelected];
        [_checkBtn addTarget:self action:@selector(onCheckBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkBtn];
    }
    return self;
}

- (void)setCheckState:(BOOL)checkState
{
    _checkBtn.selected = checkState;
}

- (void)onCheckBtnClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didOnProjectPullCell:)]) {
        [self.delegate didOnProjectPullCell:self];
    }
}

- (void)configProjectWithName:(NSString *)title
{
    _titleLb.text = title;
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = [AppUtils textWidthSystemFontString:_titleLb.text height:_titleLb.height font:_titleLb.font];
    _titleLb.width = width;
    _titleLb.top = (self.contentView.height-_titleLb.height)/2;
    _checkBtn.frame = CGRectMake(self.contentView.width-25-16, (self.contentView.height-25)/2, 25, 25);
}

@end

//
//  DQCheckWorkUserCell.m
//  WebThings
//
//  Created by winton on 2017/10/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQCheckWorkUserCell.h"
#import "HeadImgV.h"

@interface DQCheckWorkUserCell()
{
    HeadImgV *_userHeadView;
    UILabel *_nameLabel;
    UILabel *_phoneLabel;
    UILabel *_jobLabel;
    UIButton *_checkDoubleBtn;
}
@end

@implementation DQCheckWorkUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addConfigWorkUserView];
    }
    return self;
}

- (void)addConfigWorkUserView
{
    _userHeadView = [[HeadImgV alloc] initWithFrame:CGRectMake(16, 16, 46, 46)];
    [_userHeadView withRadius:23];
    [_userHeadView borderWid:1];
    [_userHeadView borderColor:[UIColor colorWithHexString:@"407ee9"]];
    [self.contentView addSubview:_userHeadView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userHeadView.right+16, _userHeadView.top, 0, 12)];
    _nameLabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
    _nameLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    [self.contentView addSubview:_nameLabel];
    
    _jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _nameLabel.top, 0, 12)];
    _jobLabel.font = [UIFont dq_mediumSystemFontOfSize:10];
    _jobLabel.textColor = [UIColor colorWithHexString:@"#ABABAB"];
    [self.contentView addSubview:_jobLabel];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom+20, 0, 12)];
    _phoneLabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
    _phoneLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    [self.contentView addSubview:_phoneLabel];
    
    _checkDoubleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkDoubleBtn.frame = CGRectMake(screenWidth-32, 31, 16, 16);
    [_checkDoubleBtn withRadius:8];
    [_checkDoubleBtn setImage:ImageNamed(@"icon_circle_hui") forState:UIControlStateNormal];
    [_checkDoubleBtn setImage:ImageNamed(@"ic_check_circle") forState:UIControlStateSelected];
    [_checkDoubleBtn addTarget:self action:@selector(onCheckBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_checkDoubleBtn];
}

//确认是否选择
- (void)configCormit:(BOOL)isCormit
{
    _checkDoubleBtn.selected = isCormit;
}

- (void)onCheckBtnClick
{
    if (self.cellSelectedUserBlock) {
        self.cellSelectedUserBlock(self.selectIndexPath);
    }
}

//数据来源
- (void)configCheckWorkModel:(UserModel *)model
{
    _userHeadView.image = [_userHeadView defaultImageWithName:[model.name substringWithRange:NSMakeRange(0, 1)]];
    _nameLabel.text = model.name;
    _phoneLabel.text = model.dn;
    _jobLabel.text = @"操作人员";
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = [AppUtils textWidthSystemFontString:_nameLabel.text height:12 font:_nameLabel.font];
    _nameLabel.width = width;
    
    CGFloat jobWidth = [AppUtils textWidthSystemFontString:_jobLabel.text height:12 font:_jobLabel.font];
    _jobLabel.left = _nameLabel.right+16;
    _jobLabel.width = jobWidth;
    
    CGFloat dnWidth = [AppUtils textWidthSystemFontString:_phoneLabel.text height:12 font:_phoneLabel.font];
    _phoneLabel.width = dnWidth;
}

@end

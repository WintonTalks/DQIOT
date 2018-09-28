//
//  DQMangerEvaluationCell.m
//  WebThings
//
//  Created by 孙文强 on 2017/10/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQMangerEvaluationCell.h"
#import "HeadImgV.h"
#import "DQEvalueStarView.h"

@interface DQMangerEvaluationCell()
@property (nonatomic, strong) HeadImgV *headView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) DQEvalueStarView *qualityControl;
@property (nonatomic, strong) DQEvalueStarView *skillControl;
@property (nonatomic, strong) DQEvalueStarView *attitudeControl;
@property (nonatomic, strong) UITextView *mTextView;
@property (nonatomic, strong) UIButton *safixButton;
@property (nonatomic, strong) UIButton *noSafixButton;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation DQMangerEvaluationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.headView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.safixButton];
        [self.contentView addSubview:self.noSafixButton];
        [self.contentView addSubview:self.qualityControl];
        [self.contentView addSubview:self.skillControl];
        [self.contentView addSubview:self.attitudeControl];
        [self.contentView addSubview:self.mTextView];
    }
    return self;
}

- (HeadImgV *)headView
{
    if (!_headView) {
        _headView = [[HeadImgV alloc] initWithFrame:CGRectMake(16, 16, 46, 46)];
        [_headView borderWid:1];
        [_headView borderColor:[UIColor colorWithHexString:@"407ee9"]];
    }
    return _headView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headView.right+16, 31, 110, 16)];
        _nameLabel.font = [UIFont dq_mediumSystemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.bottom+9, screenWidth-20, 14)];
        _lineView.backgroundColor = [UIColor whiteColor];
       
        UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(75, 6.5, 75, 1)];
        leftLineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [_lineView addSubview:leftLineView];
        
        UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth-150, leftLineView.top, 75, 1)];
        rightLineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [_lineView addSubview:rightLineView];
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(leftLineView.right+5, 0, rightLineView.left-leftLineView.right-10, 14)];
        titleLb.font = [UIFont dq_regularSystemFontOfSize:14];
        titleLb.text = @"人员评价";
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.textColor = [UIColor colorWithHexString:@"#BAB9B9"];
        [_lineView addSubview:titleLb];
    }
    return _lineView;
}

- (UIButton *)safixButton
{
    if (!_safixButton) {
        _safixButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _safixButton.backgroundColor = [UIColor whiteColor];
        _safixButton.frame = CGRectMake(62, self.lineView.bottom+23, 111, 37);
        [_safixButton setTitle:@"满意" forState:UIControlStateNormal];
        [_safixButton setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
        [_safixButton setTitleColor:[UIColor colorWithHexString:COLOR_ORANGE] forState:UIControlStateSelected];
        [_safixButton setImage:ImageNamed(@"icon_satisfy") forState:UIControlStateNormal];
        [_safixButton setImage:ImageNamed(@"icon_satisfy_sel") forState:UIControlStateSelected];
        _safixButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_safixButton borderColor:[UIColor colorWithHexString:@"#979797"]];
        [_safixButton borderWid:1.f];
        [_safixButton withRadius:13];
    }
    return _safixButton;
}

- (UIButton *)noSafixButton
{
    if (!_noSafixButton) {
        _noSafixButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _noSafixButton.backgroundColor = [UIColor whiteColor];
        _noSafixButton.frame = CGRectMake(_safixButton.right+30, _safixButton.top, 111, 37);
        [_noSafixButton setTitle:@"不满意" forState:UIControlStateNormal];
        [_noSafixButton setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
        [_noSafixButton setTitleColor:[UIColor colorWithHexString:COLOR_ORANGE] forState:UIControlStateSelected];
        [_noSafixButton setImage:ImageNamed(@"icon_unsatisfy") forState:UIControlStateNormal];
        [_noSafixButton setImage:ImageNamed(@"icon_unsatisfy_sel") forState:UIControlStateSelected];
        _noSafixButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_noSafixButton borderColor:[UIColor colorWithHexString:@"#979797"]];
        [_noSafixButton borderWid:1.f];
        [_noSafixButton withRadius:13];
    }
    return _noSafixButton;
}

- (DQEvalueStarView *)qualityControl
{
    if (!_qualityControl) {
        _qualityControl = [[DQEvalueStarView alloc] initWithFrame:CGRectMake(16, self.safixButton.bottom+22, 215, 18) leftTitle:@"完成质量"];
        _qualityControl.touchEnable = false;
        _qualityControl.backgroundColor = [UIColor whiteColor];
    }
    return _qualityControl;
}

- (DQEvalueStarView *)skillControl
{
    if (!_skillControl) {
        _skillControl = [[DQEvalueStarView alloc] initWithFrame:CGRectMake(self.qualityControl.left, self.qualityControl.bottom+6, self.qualityControl.width, self.qualityControl.height) leftTitle:@"专项技能"];
        _skillControl.touchEnable = false;
        _skillControl.backgroundColor = [UIColor whiteColor];
    }
    return _skillControl;
}

- (DQEvalueStarView *)attitudeControl
{
    if (!_attitudeControl) {
        _attitudeControl = [[DQEvalueStarView alloc] initWithFrame:CGRectMake(self.qualityControl.left, self.skillControl.bottom+6, self.qualityControl.width, self.qualityControl.height) leftTitle:@"服务态度"];
        _attitudeControl.touchEnable = false;
        _attitudeControl.backgroundColor = [UIColor whiteColor];
    }
    return _attitudeControl;
}

- (UITextView *)mTextView
{
    if (!_mTextView) {
        _mTextView = [[UITextView alloc] initWithFrame:CGRectMake(9, self.attitudeControl.bottom+16, screenWidth-38, 104)];
        _mTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        _mTextView.font = [UIFont dq_regularSystemFontOfSize:14];
        _mTextView.textAlignment = NSTextAlignmentLeft;
        _mTextView.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        [_mTextView borderWid:1.f];
        [_mTextView borderColor:[UIColor colorWithHexString:@"#CACACA"]];
        [_mTextView setEditable:false];
    }
    return _mTextView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)configEvaluationModel:(DQEvaluateListModel *)listModel
{
    self.nameLabel.text = listModel.name;
    if (listModel.pleased) {
        self.safixButton.selected = true;
        [self.safixButton borderColor:[UIColor colorWithHexString:@"#F19E39"]];
    } else {
        self.noSafixButton.selected = true;
        [self.noSafixButton borderColor:[UIColor colorWithHexString:@"#F19E39"]];
    }
    NSString *s = [listModel.name substringWithRange:NSMakeRange(0, 1)];
    [self.headView setImageWithURL:[NSURL URLWithString:appendUrl(IMAGEURL, listModel.headimg)] placeholderImage:[self.headView defaultImageWithName:s]];

    self.qualityControl.selectedStarNumber = listModel.complete;
    self.skillControl.selectedStarNumber = listModel.service;
    self.attitudeControl.selectedStarNumber = listModel.skill;
    self.mTextView.text = listModel.asess;
}

@end

//
//  DriverListCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DriverListCell.h"
#import "EMICardView.h"
#import "ServiceDetailView.h"
#import "rightFooterView.h"
#import "leftFooterView.h"
#import "DQSeverStationTitleView.h"

@interface DriverListCell()
{
    UILabel *_titleLabel;
    UILabel *_sjInfoLabel;
    UIImageView *_bjImgView;
    EMICardView *_cardView;
    
    UIButton *_btnOK;
    UIButton *_btnBack;
    
    ServiceCenterBaseModel *_baseModel;
}
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) DQSeverStationTitleView *sjNameView;
@property (nonatomic, strong) DQSeverStationTitleView *sjIDView;
@property (nonatomic, strong) DQSeverStationTitleView *sjPhoneView;
@property (nonatomic, strong) DQSeverStationTitleView *sjTypeView;
@property (nonatomic, strong) DQSeverStationTitleView *sjMonerView;
@property (nonatomic, strong) DQSeverStationTitleView *sjEducationView;
@property (nonatomic, strong) rightFooterView *rightFootV1;
@property (nonatomic, strong) leftFooterView *leftFootV1;
//@property (nonatomic, strong) ServiceBtnView *serviceBtnFatherV;

@end

@implementation DriverListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.width = 245*autoSizeScaleX;
        _baseModel = nil;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    [self.contentView addSubview:self.lineView];
    _cardView = [[EMICardView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_cardView];
    [self.contentView addSubview:self.mainView];
    [self.mainView addSubview:self.headerView];
    [self.mainView addSubview:self.sjNameView];
    [self.mainView addSubview:self.sjIDView];
    [self.mainView addSubview:self.sjPhoneView];
    [self.mainView addSubview:self.sjTypeView];
    [self.mainView addSubview:self.sjMonerView];
    [self.mainView addSubview:self.sjEducationView];
    [self.mainView addSubview:self.bottomView];
    
    _bjImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-4, -2, 0, 49)];
    _bjImgView.image = ImageNamed(@"service_center_title_bj");
    [self.headerView addSubview:_bjImgView];
    
    NSString *text = @"司机人员清单";
    UIFont *titleFont = [UIFont dq_semiboldSystemFontOfSize:15];
    CGFloat titletWidth = [AppUtils textWidthSystemFontString:text height:24 font:titleFont];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, titletWidth, 24)];
    _titleLabel.text = text;
    _titleLabel.font = titleFont;
    _titleLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:_titleLabel];
    NSString *infoString = @"司机信息";
    UIFont *infoFont = [UIFont dq_regularSystemFontOfSize:13];
    CGFloat infoWidth = [AppUtils textWidthSystemFontString:infoString height:20 font:infoFont];
    _sjInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _bjImgView.bottom+15, infoWidth, 20)];
    _sjInfoLabel.text = infoString;
    _sjInfoLabel.font = infoFont;
    _sjInfoLabel.textColor = [UIColor colorWithHexString:COLOR_BLUE];
    [self.headerView addSubview:_sjInfoLabel];
}

- (UIView *)mainView
{
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectZero];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.userInteractionEnabled = true;
    }
    return _mainView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _headerView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _bottomView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#3366CC"];
    }
    return _lineView;
}

- (DQSeverStationTitleView *)sjNameView
{
    if (!_sjNameView) {
        _sjNameView = [[DQSeverStationTitleView alloc] initWithFrame:CGRectZero];
        [_sjNameView configLeftName:@"司机姓名"];
    }
    return _sjNameView;
}

- (DQSeverStationTitleView *)sjIDView
{
    if (!_sjIDView) {
        _sjIDView = [[DQSeverStationTitleView alloc] initWithFrame:CGRectZero];
        [_sjIDView configLeftName:@"身份证号"];
    }
    return _sjIDView;
}

- (DQSeverStationTitleView *)sjPhoneView
{
    if (!_sjPhoneView) {
        _sjPhoneView = [[DQSeverStationTitleView alloc] initWithFrame:CGRectZero];
        [_sjPhoneView configLeftName:@"联系电话"];
    }
    return _sjPhoneView;
}

- (DQSeverStationTitleView *)sjTypeView
{
    if (!_sjTypeView) {
        _sjTypeView = [[DQSeverStationTitleView alloc] initWithFrame:CGRectZero];
        [_sjTypeView configLeftName:@"工资类型"];
    }
    return _sjTypeView;
}

- (DQSeverStationTitleView *)sjMonerView
{
    if (!_sjMonerView) {
        _sjMonerView = [[DQSeverStationTitleView alloc] initWithFrame:CGRectZero];
        [_sjMonerView configLeftName:@"工资"];
    }
    return _sjMonerView;
}

- (DQSeverStationTitleView *)sjEducationView
{
    if (!_sjEducationView) {
        _sjEducationView = [[DQSeverStationTitleView alloc] initWithFrame:CGRectZero];
        [_sjEducationView configLeftName:@"司机安全教育"];
    }
    return _sjEducationView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _lineView.frame = CGRectMake(36, 0, 1, self.contentView.height);
    _cardView.frame = CGRectMake(_lineView.right+15, 5, self.contentView.width-(_lineView.right+15)-80, self.contentView.height-10);
    self.mainView.frame = CGRectMake(_lineView.right+15, 5, _cardView.width, _cardView.height);
    self.headerView.frame = CGRectMake(0, 0, self.mainView.width, 49+15+20+15);
    _bjImgView.width = self.headerView.width+8;
    _titleLabel.top = (_bjImgView.height-24)/2;
    self.sjNameView.frame = CGRectMake(self.headerView.left, self.headerView.bottom, self.mainView.width, 32);
    self.sjIDView.frame = CGRectMake(self.sjNameView.left, self.sjNameView.bottom, self.sjNameView.width, self.sjNameView.height);
    self.sjPhoneView.frame = CGRectMake(self.sjIDView.left, self.sjIDView.bottom, self.sjIDView.width, self.sjNameView.height);
    self.sjTypeView.frame = CGRectMake(self.sjPhoneView.left, self.sjPhoneView.bottom, self.sjPhoneView.width, self.sjNameView.height);
    self.sjMonerView.frame = CGRectMake(self.headerView.left, self.sjTypeView.bottom, self.sjTypeView.width, self.sjNameView.height);
    self.sjEducationView.frame = CGRectMake(self.headerView.left, self.sjMonerView.bottom, self.sjMonerView.width, self.sjNameView.height);
    self.bottomView.frame = CGRectMake(self.sjEducationView.left, self.sjEducationView.bottom, self.mainView.width, 80);
    if (_baseModel.direction == 0) {
        _leftFootV1.frame = CGRectMake(0, 0, self.bottomView.width, 40);
    } else {
        _rightFootV1.frame = CGRectMake(0, 0, self.bottomView.width, 40);
    }
    
    if (_baseModel.isLastCommit && !_baseModel.iszulin) {
        if (_leftFootV1) {
            _btnOK.frame = CGRectMake(12, 42, 73, 26);
            _btnBack.frame = CGRectMake(95, 42, 73, 26);
        } else {
            _btnOK.frame = CGRectMake(12, 42, 73, 26);
            _btnBack.frame = CGRectMake(95, 42, 73, 26);
        }
    }
}

- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model
{
    _baseModel = model;
    if (model.direction == 0) {
        if (!_leftFootV1) {
            _leftFootV1 = [[leftFooterView alloc] init];
            [self.bottomView addSubview:_leftFootV1];
            [self.bottomView addSubview:_leftFootV1];
        }
        _leftFootV1.frame = CGRectMake(0, 0, _bottomView.frame.size.width, 40);
        [_leftFootV1 setViewValuesWithModel:model];
        
    }else{
        if (!_rightFootV1) {
            _rightFootV1 = [[rightFooterView alloc] init];
            [self.bottomView addSubview:_rightFootV1];
        }
        [_rightFootV1 setViewValuesWithModel:model];
    }
    [self setStackSWithModel:model];
    if (model.isLastCommit && !model.iszulin) {
        //确认驳回按钮
        if (!_btnOK) {
            _btnOK = [[UIButton alloc] init];
            _btnOK.titleLabel.font = [UIFont systemFontOfSize:14.0];
            _btnOK.backgroundColor = [UIColor colorWithHexString:@"#3E7BE2"];
            _btnOK.layer.masksToBounds = YES;
            _btnOK.layer.cornerRadius = 2.0;
            [_btnOK setTitle:@"确认" forState:UIControlStateNormal];
            _btnOK.tag = 21;
            [self.bottomView addSubview:_btnOK];
        }
        
        if (!_btnBack) {
            _btnBack = [[UIButton alloc] init];
            _btnBack.titleLabel.font = [UIFont systemFontOfSize:14.0];
            _btnBack.backgroundColor = [UIColor whiteColor];
            [_btnBack setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
            [_btnBack setTitle:@"驳回" forState:UIControlStateNormal];
            _btnBack.tag = 22;
            [self.bottomView addSubview:_btnBack];
        }
        
        _btnOK.frame = CGRectMake(12, 42, 73, 26);
        _btnBack.frame = CGRectMake(95, 42, 73, 26);
    }
    else {
        DQLog(@"司机确认");
    }
    [self layoutIfNeeded];
}

//司机信息
- (void)setStackSWithModel:(ServiceCenterBaseModel *)model
{
    DriverModel *server = [model.dirverrenthistoryList safeObjectAtIndex:0];
    NSString *safe = server.issafeteach == 1 ? @"已完成" : @"未完成";
    [self.sjNameView configRightName:server.name];
    [self.sjIDView configRightName:server.idcard];
    [self.sjPhoneView configRightName:server.dn];
    [self.sjTypeView configRightName:server.renttype];
    [self.sjMonerView configRightName:[NSString stringWithFormat:@"%.0f元",server.rent]];
    [self.sjEducationView configRightName:safe];
}

- (void)setAction1:(SEL)action1 Action2:(SEL)action2 target:(id)target{
    [_btnOK addTarget:target action:action1 forControlEvents:UIControlEventTouchUpInside];
    [_btnBack addTarget:target action:action2 forControlEvents:UIControlEventTouchUpInside];
}

- (CGFloat)cellHeightWithModel:(ServiceCenterBaseModel *)model{
    CGFloat h;
    if (!model.dirverrenthistoryList.count) {
        h = 94.5+41.5+8;
    }else{
        h = 94.5+41.5+(model.dirverrenthistoryList.count-1)*(20+192)+192+8;
    }
    
    if (model.isLastCommit) {
        h = h+5;
    }
    if (!model.iszulin && model.isLastCommit) {
        h = h + 35;
    }
    return h+10;
}
@end

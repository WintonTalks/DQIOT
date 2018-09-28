//
//  DQProjectUserTitleView.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQProjectUserTitleView.h"

@interface DQProjectUserTitleView()
{
    UIColor *_lineColor;
    NSArray *_imageList;
    NSArray *_titleList;
}
@property (nonatomic, strong) UIView *attenView;
@property (nonatomic, strong) UIView *quationView;
@property (nonatomic, strong) UIView *trainingView;
@property (nonatomic, strong) UIView *evaluationView;
@property (nonatomic) DQProjectManageInfoViewType infoType;
@end

#define BTN_SPACE 12

@implementation DQProjectUserTitleView

- (instancetype)initWithFrame:(CGRect)frame
           manageInfoViewType:(DQProjectManageInfoViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineColor = [UIColor colorWithHexString:@"#F0F0F0"];
        self.infoType = type;
        if (type == KDQProjectManageTopSelectedStyle) {//头视图
            _imageList = @[@"Project_TouchID_Selected",@"Project_Down",@"Project_Group",@"Project_EditSelected"];
            _titleList = @[@"考勤记录",@"资质记录",@"培训记录",@"人员评价"];
        } else {//司机cell选项
            _imageList = @[@"Project_TouchID_Normal",@"Project_TopArrow",@"Project_Mome",@"Project_EditNormal"];
            _titleList = @[@"考勤",@"资质上传",@"培训",@"评价"];
        }
        [self addSubview:self.attenView];
        [self addSubview:self.quationView];
        [self addSubview:self.trainingView];
        [self addSubview:self.evaluationView];
    }
    return self;
}

- (UIView *)attenView
{
    if (!_attenView) {
        _attenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width/4, self.height)];
        _attenView.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(14, 0, _attenView.width-28, _attenView.height);
        [btn setTitle:[_titleList safeObjectAtIndex:0] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
        [btn setImage:ImageNamed([_imageList safeObjectAtIndex:0]) forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:10];
        [btn layoutButtonWithEdgeInsetsStyle:TQButtonEdgeInsetsStyleTop imageTitleSpace:BTN_SPACE];
        [btn addTarget:self action:@selector(onAttenBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_attenView addSubview:btn];
    }
    return _attenView;
}

- (UIView *)quationView
{
    if (!_quationView) {
        _quationView = [[UIView alloc] initWithFrame:CGRectMake(self.attenView.right, 0, self.attenView.width, self.attenView.height)];
        _quationView.backgroundColor = [UIColor whiteColor];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(14, 0, _attenView.width-28, _attenView.height);
        [btn setTitle:[_titleList safeObjectAtIndex:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
        [btn setImage:ImageNamed([_imageList safeObjectAtIndex:1]) forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:10];
        [btn layoutButtonWithEdgeInsetsStyle:TQButtonEdgeInsetsStyleTop imageTitleSpace:BTN_SPACE];
        [btn addTarget:self action:@selector(onQuationBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_quationView addSubview:btn];

    }
    return _quationView;
}

- (UIView *)trainingView
{
    if (!_trainingView) {
        _trainingView = [[UIView alloc] initWithFrame:CGRectMake(self.quationView.right, 0, self.attenView.width, self.height)];
        _trainingView.backgroundColor = [UIColor whiteColor];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(14, 0, _attenView.width-28, _attenView.height);
        [btn setTitle:[_titleList safeObjectAtIndex:2] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
        [btn setImage:ImageNamed([_imageList safeObjectAtIndex:2]) forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:10];
        [btn layoutButtonWithEdgeInsetsStyle:TQButtonEdgeInsetsStyleTop imageTitleSpace:BTN_SPACE];
        [btn addTarget:self action:@selector(onTrainingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_trainingView addSubview:btn];

    }
    return _trainingView;
}

- (UIView *)evaluationView
{
    if (!_evaluationView) {
        _evaluationView = [[UIView alloc] initWithFrame:CGRectMake(self.trainingView.right, 0, self.attenView.width, self.height)];
        _evaluationView.backgroundColor = [UIColor whiteColor];
//        CGFloat left = (_attenView.width-28-23)/2;

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(14, 0, _attenView.width-28, _attenView.height);
        [btn setTitle:[_titleList safeObjectAtIndex:3] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
        [btn setImage:ImageNamed([_imageList safeObjectAtIndex:3]) forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:10];
        [btn layoutButtonWithEdgeInsetsStyle:TQButtonEdgeInsetsStyleTop imageTitleSpace:BTN_SPACE];
       [btn addTarget:self action:@selector(onEvaluationBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_evaluationView addSubview:btn];
    }
    return _evaluationView;
}

#pragma mark- Method
- (void)onAttenBtnClick
{//考勤
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectUserMentView:type:)]) {
        [self.delegate didProjectUserMentView:self type:KDQProjectUserAttendanceStyle];
    }
}

- (void)onQuationBtnClick
{//资质
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectUserMentView:type:)]) {
        [self.delegate didProjectUserMentView:self type:KDQProjectUserQualificationStyle];
    }
}

- (void)onTrainingBtnClick
{//培训
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectUserMentView:type:)]) {
        [self.delegate didProjectUserMentView:self type:KDQProjectUserTrainingStyle];
    }
}

- (void)onEvaluationBtnClick
{//人员评价
    if (self.delegate && [self.delegate respondsToSelector:@selector(didProjectUserMentView:type:)]) {
        [self.delegate didProjectUserMentView:self type:KDQProjectUserEvaluationStyle];
    }
}

@end

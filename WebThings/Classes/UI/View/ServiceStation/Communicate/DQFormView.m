//
//  DQFormView.m
//  WebThings
//
//  Created by Eugene on 9/28/17.
//  Copyright © 2017 machinsight. All rights reserved.
//  前期沟通-》沟通表单 包含：topView、容器视图、bottomView

#import "DQFormView.h"
#import "DQUserInfoTopView.h"
#import "DQFormConfirmView.h"

#import "DQLogicServiceBaseModel.h"
#import "DQLogicPackModel.h"

const NSInteger margin = 16;

@interface DQFormView ()

/** 用户信息view */
@property (nonatomic, strong) DQUserInfoTopView *topView;
/** 内容视图 */
@property (nonatomic, strong) UIView *containerView;
/** 底部视图 确定、驳回 */
@property (nonatomic, strong) DQFormConfirmView *bottomConfirmView;

@end

@implementation DQFormView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommunicateFormView];
    }
    return self;
}

- (void)initCommunicateFormView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithHexString:@"BACFF2"].CGColor;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    
    // 用户信息view
    self.topView.frame = CGRectMake(0, 0, self.width, 76);
    [self addSubview:self.topView];
    
    self.bottomConfirmView.frame = CGRectMake(0, self.height-55, self.width, 54);
    [self addSubview:self.bottomConfirmView];
    
    [self reloadFormSubView];
    
    // block 事件
    __weak typeof(self) weakself = self;
    self.topView.unfoldBlock = ^(BOOL isUnfold){
        _isUnfold = isUnfold;
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(formViewConfirm:)]) {
            [weakself.delegate formViewUnfold:isUnfold];
        }
    };

    self.bottomConfirmView.confirmBlock = ^(){
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(formViewConfirm:)]) {
            [weakself.delegate formViewConfirm:weakself];
        }
    };
    self.bottomConfirmView.ignoreBlock = ^{
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(formViewIgnore:)]) {
            [weakself.delegate formViewIgnore:weakself];
        }
    };
}

- (void)addFormSubviews:(NSArray <UIView *>*)subviews {
    [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:[UIView class]]) {
            //[self addFormSubView:view];
        }
    }];
}

/** 加载自定义的containerView */
- (void)addFormSubView:(UIView *)view {
    
    if (self.containerView) { return; }
    
    self.containerView = view;
    [self addSubview:view];
    
    [self reloadFormSubView];
}

- (void)reloadFormSubView {
    
    CGRect rectBottom = _containerView.frame;
    rectBottom.size.width = self.frame.size.width;
    rectBottom.origin.x = 0;
    rectBottom.origin.y = _topView.frame.size.height;
    _containerView.frame = rectBottom;
    
    rectBottom = self.bottomConfirmView.frame;
    rectBottom.origin.y = _containerView.frame.size.height + _topView.frame.size.height;
    self.bottomConfirmView.frame = rectBottom;
    
    CGRect rect = self.frame;
    rect.size.height = rectBottom.origin.y + (self.bottomConfirmView.hidden ? 0 : rectBottom.size.height);
    self.frame = rect;
}

#pragma mark - Getter
- (DQUserInfoTopView *)topView {
    
    if (!_topView) {
        _topView = [[DQUserInfoTopView alloc] init];
    }
    return _topView;
}

- (DQFormConfirmView *)bottomConfirmView {
    
    if (!_bottomConfirmView) {
        _bottomConfirmView = [[DQFormConfirmView alloc] init];
    }
    return _bottomConfirmView;
}

#pragma mark - Setter
- (void)setIsHiddenFoldBtn:(BOOL)isHiddenFoldBtn {
    _isHiddenFoldBtn = isHiddenFoldBtn;
    self.topView.isHidden = isHiddenFoldBtn;
}

- (void)setLogicServiceModel:(DQLogicServiceBaseModel *)logicServiceModel {
    _logicServiceModel = logicServiceModel;
    
    self.topView.viewData = logicServiceModel;
    self.bottomConfirmView.logicServiceBaseModel = logicServiceModel;

    self.backgroundColor = logicServiceModel.hexBgColor;
    self.layer.borderColor = logicServiceModel.hexBorderColor.CGColor;
    if (logicServiceModel.isClearBillColor) {
        self.containerView.backgroundColor = [UIColor clearColor];
    } else {
        self.containerView.backgroundColor = [UIColor whiteColor];
    }
    
    if (logicServiceModel.showRefuteBackButton && logicServiceModel.isLast) {
        [self formBottomConfirmViewHidden:NO];
    } else {
        [self formBottomConfirmViewHidden:YES];
    }
}

- (void)formBottomConfirmViewHidden:(BOOL)isHidden {
    self.bottomConfirmView.hidden = isHidden;
    [self reloadFormSubView];
}
@end

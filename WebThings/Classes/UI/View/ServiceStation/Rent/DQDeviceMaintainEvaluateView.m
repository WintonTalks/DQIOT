//
//  DQDeviceMaintainEvaluateView.m
//  WebThings
//
//  Created by Eugene on 10/13/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQDeviceMaintainEvaluateView.h"

#import "DQServiceEvaluateView.h"

#import "DQSubEvaluateModel.h"

#import "DQFormView.h"

@interface DQDeviceMaintainEvaluateView ()<DQServiceEvaluateViewDelegate>

@property (nonatomic, strong) DQFormView *formView;
@property (nonatomic, strong) UIView *bodyView;
    
@property (nonatomic, strong) DQServiceEvaluateView *evaluteView;     // 人员评价
@property (nonatomic, strong) UIButton *btnSend; // 发送按钮

@end

@implementation DQDeviceMaintainEvaluateView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _formView = [[DQFormView alloc]
                     initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_formView];
        
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _bodyView.userInteractionEnabled = true;
        [_formView addFormSubView:_bodyView];
        
        _evaluteView = [[DQServiceEvaluateView alloc]
                              initWithFrame:CGRectMake(0, 0, screenWidth - 58 - 16, 215)];
        _evaluteView.titleStr = @"人员评价";
        _evaluteView.delegate = self;
        [_bodyView addSubview:_evaluteView];
        
        _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSend.frame = CGRectMake(0, frame.size.height - 44, frame.size.width, 44);
        [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
        _btnSend.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnSend setTitleColor:[UIColor colorWithHexString:COLOR_GREEN] forState:UIControlStateNormal];
        [_bodyView addSubview:_btnSend];
    }
    return self;
}

- (void)setEvaluteLogic:(DQLogicEvaluateModel *)evaluteLogic {
    _evaluteLogic = evaluteLogic;
    
    _evaluteLogic.cellData.text = @"服务评价";
    if (_evaluteLogic.cellData.enumstateid == 164) {
        // 添加评论
        UserModel *user = [AppUtils readUser];
        _evaluteLogic.cellData.sendname = user.name;
        _evaluteLogic.cellData.sendheadimg = user.headimg;
    }
    
    _formView.logicServiceModel = evaluteLogic;
    [_evaluteView setData:_evaluteLogic evaluate:nil];
    _btnSend.hidden = !_evaluteLogic.canEdit;
    
    [self reloadFrame];
}

- (void)reloadFrame {
    
    // 人员评价View的Frame
    CGRect rectPerson = _evaluteView.frame;
    rectPerson.size.height = [_evaluteView getMaxY];
    _evaluteView.frame = rectPerson;
    
    CGFloat y = CGRectGetMaxY(_evaluteView.frame);
    CGRect rect = _bodyView.frame;
    // 发送按钮的位置
    y = CGRectGetMaxY(_evaluteView.frame);
    if (!_btnSend.hidden) {
        _btnSend.frame = CGRectMake(0, y, rect.size.width, 44);
        y += 44;
    } else {
        y += 16;
    }
    rect.size.height = y;
    _bodyView.frame = rect;
    
    [_formView reloadFormSubView];
}

- (CGFloat)getMaxY {
    return CGRectGetMaxY(_formView.frame);
}

#pragma mark - DQServiceEvaluateViewDelegate
/// 文本框高度发生改变
- (void)willChangeHeight:(CGFloat)height
            evaluateView:(DQServiceEvaluateView *)evaluateView {
    CGRect rect = evaluateView.frame;
    rect.size.height = height;
    evaluateView.frame = rect;
    
    [self reloadFrame];
    if (self.delegate && [self.delegate respondsToSelector:@selector(willChangeHeight:)]) {
        [self.delegate willChangeHeight:[self getMaxY]];
    }
}

@end

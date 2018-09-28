//
//  DQServiceEvaluateFooterView.m
//  WebThings
//  评价View
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceEvaluateFooterView.h"

#import "DQServiceInfoCell.h"

#import "DQSubEvaluateModel.h"

#import "DQFormView.h"

@implementation DQServiceEvaluateFooterView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _formView = [[DQFormView alloc]
                       initWithFrame:CGRectMake(58, 0, frame.size.width - 58 - 16, frame.size.height)];
        [self addSubview:_formView];
        
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _bodyView.userInteractionEnabled = true;
        [_formView addFormSubView:_bodyView];
        
        CGFloat y = 0;
        _evalutePersonView = [[DQServiceEvaluateView alloc]
                               initWithFrame:CGRectMake(0, y, screenWidth - 58 - 16, 215)
                              type:DQEvaluateTypePersonInService];
        _evalutePersonView.titleStr = @"人员评价";
        _evalutePersonView.delegate = self;
        [_bodyView addSubview:_evalutePersonView];
        y += _evalutePersonView.frame.size.height + 16;
        
        _evaluteDeviceView = [[DQServiceEvaluateView alloc]
                              initWithFrame:CGRectMake(0, y, screenWidth - 58 - 16, 215)
                              type:DQEvaluateTypeDevice];
        _evaluteDeviceView.titleStr = @"设备评价";
        _evaluteDeviceView.delegate = self;
        [_bodyView addSubview:_evaluteDeviceView];
        
        _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSend.frame = CGRectMake(0, frame.size.height - 44, frame.size.width, 44);
        [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
        _btnSend.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnSend setTitleColor:[UIColor colorWithHexString:COLOR_GREEN] forState:UIControlStateNormal];
        [_btnSend addTarget:self action:@selector(onSendEvaluateClick)
           forControlEvents:UIControlEventTouchUpInside];
        [_bodyView addSubview:_btnSend];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap {
    [self endEditing:YES];
}

- (void)setEvaluteLogic:(DQLogicEvaluateModel *)evaluteLogic {
    _evaluteLogic = evaluteLogic;
    
    _evaluteLogic.cellData.title = @"服务评价";
    if (_evaluteLogic.canEdit) {
        // 添加评论
        UserModel *user = [AppUtils readUser];
        _evaluteLogic.cellData.sendname = user.name;
        _evaluteLogic.cellData.sendheadimg = user.headimg;
    }
    
    _formView.logicServiceModel = _evaluteLogic;
    
    DQSubEvaluateModel *model = (DQSubEvaluateModel *)_evaluteLogic.cellData;
    
    ServiceevaluateModel *evaluatePerson = nil;
    ServiceevaluateModel *evaluateDevice = nil;
    if ([model.serviceevaluate count] > 0) {
        evaluatePerson = model.serviceevaluate[0];
    }
    if ([model.serviceevaluate count] > 1) {
        evaluateDevice = model.serviceevaluate[1];
    }
    [_evalutePersonView setData:_evaluteLogic
                       evaluate:evaluatePerson];
    [_evaluteDeviceView setData:_evaluteLogic
                       evaluate:evaluateDevice];
    _btnSend.hidden = !_evaluteLogic.canEdit;
    
    [_btnSend setTitleColor:[evaluteLogic hexTitleColor] forState:UIControlStateNormal];
    
    [self reloadFrame];
}

- (void)reloadFrame {

    // 人员评价View的Frame
    CGRect rectPerson = _evalutePersonView.frame;
    rectPerson.size.height = [_evalutePersonView getMaxY];
    _evalutePersonView.frame = rectPerson;

    CGFloat y = CGRectGetMaxY(_evalutePersonView.frame);

    // 设备评价View的Frame
    CGRect rectDevice = _evaluteDeviceView.frame;
    rectDevice.origin.y = y + 16;
    rectDevice.size.height = [_evaluteDeviceView getMaxY];
    _evaluteDeviceView.frame = rectDevice;
    
    CGRect rect = _bodyView.frame;

    // 发送按钮的位置
    y = CGRectGetMaxY(_evaluteDeviceView.frame);
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

#pragma mark - Button clicks
- (void)onSendEvaluateClick {
    
    ServiceevaluateModel *evaluate = [[ServiceevaluateModel alloc] init];
    evaluate.type = DQEvaluateTypeDevice;
    evaluate.projectid = [NSString stringWithFormat:@"%ld", _evaluteLogic.projectid];
    evaluate.deviceid = [NSString stringWithFormat:@"%ld", _evaluteLogic.device.deviceid];
    evaluate.pleased = _evalutePersonView.isSatisfy ? 1 : 0;
    evaluate.complete = _evalutePersonView.starFirst;
    
    evaluate.skill = _evalutePersonView.starSecond;
    evaluate.service = _evalutePersonView.starThird;
    evaluate.complete = _evalutePersonView.starFirst;
    
    evaluate.state = _evaluteDeviceView.starFirst;
    evaluate.old = _evaluteDeviceView.starSecond;
    
    [[DQProjectInterface sharedInstance]
     dq_addEvaluateWithData:evaluate
     success:^(id result) {
         
         if ([result boolValue]) {
             [_evaluteLogic reloadTableData];
         }
         
     } failture:^(NSError *error) {
         
     }];
}

@end

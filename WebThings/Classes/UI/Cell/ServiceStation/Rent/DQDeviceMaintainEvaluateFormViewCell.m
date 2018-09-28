//
//  DQDeviceMaintainEvaluateFormViewCell.m
//  WebThings
//
//  Created by Eugene on 10/13/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQDeviceMaintainEvaluateFormViewCell.h"
#import "DQServiceEvaluateView.h"
#import "DQFormView.h"

#import "DQLogicMaintainModel.h"
#import "DQSubMaintainModel.h"


@interface DQDeviceMaintainEvaluateFormViewCell ()<DQFormViewDelegate>

@property (nonatomic, strong) DQFormView *formView;
@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) DQServiceEvaluateView *evaluteView;  // 人员评价
@property (nonatomic, strong) UIButton *sendButton; // 发送按钮

@property (nonatomic, strong) DQLogicMaintainModel *logicModel;

@end

@implementation DQDeviceMaintainEvaluateFormViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initEvaluateFormView];
    }
    return self;
}

- (void)initEvaluateFormView {
    
    // 表单view
    _formView = [[DQFormView alloc] initWithFrame:CGRectMake(16, 0, screenWidth - 75, 200)];
    _formView.delegate = self;
    _formView.isHiddenFoldBtn = YES;
    _formView.userInteractionEnabled = true;
    [self.contentView addSubview:_formView];
    
    _containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _containView.userInteractionEnabled = true;
    [_formView addFormSubView:_containView];
    
    _evaluteView = [[DQServiceEvaluateView alloc]
                    initWithFrame:CGRectMake(0, 0, screenWidth - 58 - 16, 215) type:DQEvaluateTypePersonInService];
    _evaluteView.titleStr = @"人员评价";
    [_containView addSubview:_evaluteView];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(0, self.frame.size.height - 44, self.frame.size.width, 44);
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sendButton setTitleColor:[UIColor colorWithHexString:COLOR_GREEN] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(submitPeopleEvaluation:) forControlEvents:UIControlEventTouchUpInside];
    [_containView addSubview:_sendButton];
 }

- (void)setData:(DQLogicServiceBaseModel *)data {
    _logicModel = (DQLogicMaintainModel *)data;
    
    DQLogicMaintainModel *maintainModel = (DQLogicMaintainModel *)data;
    
    _formView.logicServiceModel = data;
    _evaluteView.canEdit = maintainModel.canEdit;
    
    NSArray *evaluates = _logicModel.devieceOrderModel.evaluates;
    if (evaluates.count > 0) {
        ServiceevaluateModel *evaluateModel = [evaluates firstObject];
        [_evaluteView setData:data evaluate:evaluateModel];
    } else {
        [_evaluteView setData:data evaluate:nil];
    }
 
    [self reloadFrame];
}

- (void)reloadFrame {
    
    // 人员评价View的Frame
    CGRect rectPerson = _evaluteView.frame;
    rectPerson.size.height = [_evaluteView getMaxY];
    _evaluteView.frame = rectPerson;
    
    CGFloat y = CGRectGetMaxY(_evaluteView.frame);
    CGRect rect = _containView.frame;
    
    // 发送按钮的位置
    y = CGRectGetMaxY(_evaluteView.frame);
    if (_logicModel.canEdit) {
        _sendButton.hidden = NO;
        _sendButton.frame = CGRectMake(0, y, rect.size.width, 44);
        y += 44;
    } else {
        _sendButton.hidden = YES;
        y += 16;
    }
    rect.size.height = y;
    _containView.frame = rect;
    
    [_formView reloadFormSubView];
}

/** 提交服务评价 */
- (void)submitPeopleEvaluation:(id)sender {
    
    ServiceevaluateModel *evaluateModel = [[ServiceevaluateModel alloc] init];
    evaluateModel.pleased = _evaluteView.isSatisfy;
    evaluateModel.complete = _evaluteView.starFirst;
    evaluateModel.skill = _evaluteView.starSecond;
    evaluateModel.service = _evaluteView.starSecond;
    evaluateModel.note = _evaluteView.content;
    evaluateModel.type = [self getEvaluateType];
    evaluateModel.linkid = [NSString stringWithFormat:@"%ld",_logicModel.cellData.linkid];
    evaluateModel.projectid = [NSString stringWithFormat:@"%ld",_logicModel.projectid];
    evaluateModel.deviceid = [NSString stringWithFormat:@"%ld",_logicModel.device.deviceid];
    
    [[DQProjectInterface sharedInstance] dq_addEvaluateWithData:evaluateModel success:^(id result) {
        
        [_logicModel reloadTableData];
 
    } failture:^(NSError *error) {
    }];
}

- (DQEvaluateType)getEvaluateType {
    if (_logicModel.nodeType == DQFlowTypeFix) {
        return DQEvaluateTypeFix;
    } else if (_logicModel.nodeType == DQFlowTypeMaintain) {
        return DQEvaluateTypeMaintain;
    } else {
        return DQEvaluateTypeHeighten;
    }
}

@end

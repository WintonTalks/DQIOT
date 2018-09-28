//
//  DQDeviceMaintainApplyFormViewCell.m
//  WebThings
//
//  Created by Eugene on 10/10/17.
//  Copyright © 2017 machinsight. All rights reserved.
//  维保（维保、维修、加高） 设备维保单 维保申请

#import "DQDeviceMaintainApplyFormViewCell.h"
#import "DQDeviceRentCell.h"
#import "DQFormView.h"
#import "DQMaintenanceApplyFormView.h"
#import "DQLogicMaintainModel.h"

#import "DQDateSegmentView.h" // 时间分割view

@interface DQDeviceMaintainApplyFormViewCell ()<DQFormViewDelegate>

@property (nonatomic, strong) DQFormView *formView;
@property (nonatomic, strong) DQMaintenanceApplyFormView *applyFormView;
@property (nonatomic, strong) DQLogicMaintainModel *logicModel;
@property (nonatomic, strong) UIButton *foldFormBtn;
@property (nonatomic, strong) DQDateSegmentView *dateView;

@end

@implementation DQDeviceMaintainApplyFormViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initDeviceRentView];
    }
    return self;
}

- (void)initDeviceRentView {
    
    _dateView = [[DQDateSegmentView alloc] initWithFrame:CGRectMake(16, 16, 145, 28)];
    [self.contentView addSubview:_dateView];
    
    // 表单view
    _formView = [[DQFormView alloc] initWithFrame:CGRectMake(16, _dateView.bottom+16, screenWidth - 75, 200)];
    _formView.delegate = self;
    _formView.isHiddenFoldBtn = YES;
    [self.contentView addSubview:_formView];
    
    // 表单容器view
    _applyFormView = [[DQMaintenanceApplyFormView alloc] initWithFrame:CGRectMake(0, 0, _formView.width, 252)];
    
    __weak typeof(self) weakself = self;
    _applyFormView.reloadFrameBlock = ^ {
        weakself.applyFormView.frame = CGRectMake(16, 0, screenWidth - 75, weakself.applyFormView.formViewHeight);
        [weakself.formView reloadFormSubView];
         // 上传cell刷新事件
        if (weakself.reloadCellBlock != nil) {
            weakself.reloadCellBlock(nil);
        }
     };
    
    [_formView addFormSubView:_applyFormView];
    
    _foldFormBtn = [[UIButton alloc] init];
    _foldFormBtn.frame = CGRectMake(_formView.right, _formView.top, 58, 30);
    [_foldFormBtn setImage:[UIImage imageNamed:@"ic_station_fold"] forState:UIControlStateNormal];
    [_foldFormBtn addTarget:self action:@selector(onFoldFormCellClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_foldFormBtn];
}

/// 设置数据
- (void)setData:(DQLogicMaintainModel *)data {
    _logicModel = data;
 
    _foldFormBtn.hidden = YES;
    // 达到3个的时候且在商函通知一栏，显示下拉箭头
    if (data.cellData.enumstateid == DQEnumStateFixSubmitted ||
        data.cellData.enumstateid == DQEnumStateMaintainSubmitted ||
        data.cellData.enumstateid == DQEnumStateHeightenSubmitted) {
        _foldFormBtn.hidden = !data.canExpend;
    }
    _foldFormBtn.transform = CGAffineTransformMakeRotation(self.logicModel.isOpen ? 0 : M_PI);

    [self updateFormViewWithRole:data.cellData.isZulin];
}

- (void)updateFormViewWithRole:(BOOL)isZulin {
    
    DQServiceSubNodeModel *model = _logicModel.cellData;
    _dateView.dateString = model.sendtime;
    _dateView.frame = CGRectMake(16, 16, 155, 28);
    
    _applyFormView.logicApplyFormModel = _logicModel;
    _applyFormView.frame = CGRectMake(16, _dateView.bottom, screenWidth - 75, _applyFormView.formViewHeight + 10);
    
    _formView.logicServiceModel = _logicModel;
    [_formView reloadFormSubView];
}

#pragma mark - Private Methods
- (void)onFoldFormCellClick:(UIButton *)sender {
    
    BOOL isOpen = self.logicModel.isOpen;
    self.logicModel.isOpen = !isOpen;
    
    if (self.reloadCellBlock) {
        self.reloadCellBlock(self.logicModel.isOpen);
    }

}

#pragma mark - Delegate
/** 表单确认 */
- (void)formViewConfirm:(DQFormView *)formView {
    [_logicModel btnConfirmOrRefuteBack:YES];
}

/** 表单驳回 */
- (void)formViewIgnore:(DQFormView *)formView {
    [_logicModel btnConfirmOrRefuteBack:NO];
}

/** 表单折叠 */
- (void)formViewUnfold:(BOOL)isUnfold {
    
    //_logicModel.isOpen = isUnfold;
    [self updateFormViewWithRole:isUnfold];
    
    // 上传cell刷新事件
    if (self.reloadCellBlock != nil) {
        self.reloadCellBlock(nil);
    }
}

@end

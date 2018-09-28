//
//  DQFormConfirmView.m
//  WebThings
//
//  Created by Eugene on 27/09/2017.
//  Copyright © 2017 machinsight. All rights reserved.
//  前期沟通-》沟通表单 bottomView确认、驳回视图

#import "DQFormConfirmView.h"
#import "DQLogicServiceBaseModel.h"
#import "DQServiceSubNodeModel.h"

const NSInteger mergin = 16;

@interface DQFormConfirmView ()

/** 顶部分割线 */
@property (nonatomic, strong) UIView *topLineView;
/** 竖直分割 */
@property (nonatomic, strong) UIView *verticalLineView;
/** 确认 */
@property (nonatomic, strong) UIButton *sureButton;
/** 驳回 */
@property (nonatomic, strong) UIButton *ignoreButton;

@end

@implementation DQFormConfirmView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfirmView];
    }
    return self;
}

- (void)initConfirmView {
    
    [self addSubview:self.topLineView];
    [self addSubview:self.verticalLineView];
    [self addSubview:self.ignoreButton];
    [self addSubview:self.sureButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _topLineView.frame = CGRectMake(mergin, 0, self.width-mergin*2, 1);
}

#pragma mark - Public Metods
- (void)sureAction {
 
    self.confirmBlock();
}

- (void)ignoreAction {
    
    self.ignoreBlock();
}

#pragma mark - Setter
- (void)setLogicServiceBaseModel:(DQLogicServiceBaseModel *)logicServiceBaseModel {
    _logicServiceBaseModel = logicServiceBaseModel;
    
    DQServiceSubNodeModel *model = (DQServiceSubNodeModel *)logicServiceBaseModel.cellData;
    NSInteger stateID = model.enumstateid;
    if (stateID == 35 || stateID == 39 || stateID == 43 || stateID == 164) {// 设备维保单提交时，显示一个“提交”按钮
        [_sureButton setTitle:@"提交" forState:UIControlStateNormal];
        _sureButton.frame = CGRectMake(0, _topLineView.bottom, self.width, self.height);
    }
    else if (stateID == 164) {
        [_sureButton setTitle:@"发送" forState:UIControlStateNormal];
        _sureButton.frame = CGRectMake(0, _topLineView.bottom, self.width, self.height);
    }
    else if (stateID == DQEnumStateMaintainDonePass ||
             stateID == DQEnumStateFixDonePass ||
             stateID == DQEnumStateHeightenDonePass) {
        [_sureButton setTitle:@"完成并评价" forState:UIControlStateNormal];
    }
    else {
        _verticalLineView.frame = CGRectMake(self.width/2-2, self.height/2-10, 2, 20);
        _ignoreButton.frame = CGRectMake(0, _topLineView.bottom, _verticalLineView.left, self.height);
        _sureButton.frame = CGRectMake(self.width/2, _topLineView.bottom, _ignoreButton.width, self.height);
        if (stateID == 29) {
            [_sureButton setTitle:@"费用已缴清" forState:UIControlStateNormal];
            [_ignoreButton setTitle:@"费用未缴清" forState:UIControlStateNormal];
        }
    }
    
    if (logicServiceBaseModel.isClearBillColor) {
        self.backgroundColor = [UIColor clearColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setSureTitle:(NSString *)sureTitle {
    _sureTitle = sureTitle;
    [self.sureButton setTitle:sureTitle forState:UIControlStateNormal];
}

- (void)setIgnoreTitle:(NSString *)ignoreTitle {
    _ignoreTitle = ignoreTitle;
    
    [self.ignoreButton setTitle:ignoreTitle forState:UIControlStateNormal];
}

#pragma mark - Getter
- (UIView *)topLineView {
    
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    }
    return _topLineView;
}

- (UIView *)verticalLineView {
    
    if (!_verticalLineView) {
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    }
    return _verticalLineView;
}

- (UIButton *)sureButton {
    
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        _sureButton.titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor colorWithHexString:@"#407EE9"] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)ignoreButton {
    
    if (!_ignoreButton) {
        _ignoreButton = [[UIButton alloc] init];
        _ignoreButton.titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
        [_ignoreButton setTitle:@"驳回" forState:UIControlStateNormal];
        [_ignoreButton setTitleColor:[UIColor colorWithHexString:@"#407EE9"] forState:UIControlStateNormal];
        [_ignoreButton addTarget:self action:@selector(ignoreAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ignoreButton;
}

@end

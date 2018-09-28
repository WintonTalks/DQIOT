//
//  DQMaintenanceContinueFormView.m
//  WebThings
//
//  Created by Eugene on 10/11/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQMaintenanceContinueFormView.h"
#import "DQDeviceMaintainWorkerView.h"

#import "DQLogicMaintainModel.h"
#import "DQSubMaintainModel.h"
#import "DeviceMaintainorderModel.h"

#define kMargin 16
@interface DQMaintenanceContinueFormView ()

@property (nonatomic, strong) UILabel *titleLabel;/** 表单title */
@property (nonatomic, strong) UILabel *dateLabel;/** 维保表单日期 */

@property (nonatomic, strong) UILabel *managerLabel;/** 指派人 */
@property (nonatomic, strong) UILabel *workerLabel;/** 维保人 */
@property (nonatomic, strong) DQDeviceMaintainWorkerView *directorView;/** 负责人 */
@property (nonatomic, strong) DQDeviceMaintainWorkerView *workerView;/** 维保人 */
@property (nonatomic, strong) UIView *contentView;/** 维保人列表容器 */

@end

@implementation DQMaintenanceContinueFormView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initContinueFormView];
    }
    return self;
}

- (void)initContinueFormView {
    
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithHexString:@"BACFF2"].CGColor;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"维保进行中";
    _titleLabel.frame = CGRectMake(kMargin, kMargin, 100, 18);
    [self setLabel:_titleLabel alignment:NSTextAlignmentLeft textColor:nil font:14];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.text = @"2017/09/21 19:21";
    _dateLabel.frame = CGRectMake(_titleLabel.right, _titleLabel.top+2, self.width-_titleLabel.right-kMargin, 15);
    [self setLabel:_dateLabel alignment:NSTextAlignmentRight textColor:@"#797979" font:12];
    
    _managerLabel = [[UILabel alloc] init];
    _managerLabel.text = @"指派人";
    _managerLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom+10, 80, 15);
    [self setLabel:_managerLabel alignment:NSTextAlignmentLeft textColor:COLOR_BLACK font:12];
    
    _directorView = [[DQDeviceMaintainWorkerView alloc] init];
    _directorView.frame = CGRectMake(self.width-95-kMargin, _managerLabel.top, 95, 40);
    [self addSubview:_directorView];
    
    _workerLabel = [[UILabel alloc] init];
    _workerLabel.text = @"维保员";
    _workerLabel.frame = CGRectMake(_managerLabel.left, _directorView.bottom+10, 80, 15);
    [self setLabel:_workerLabel alignment:NSTextAlignmentLeft textColor:COLOR_BLACK font:12];
    
    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
}

- (void)setModel:(DQLogicMaintainModel *)model {
    _model = model;
    
    self.backgroundColor = model.hexBgColor;
    self.layer.borderColor = model.hexBorderColor.CGColor;
    _titleLabel.textColor = model.hexTitleColor;

    /** 维修、维保或加高model */
    DeviceMaintainorderModel *deviceModel = [self getDeviceModel];
    
    /** 进行中日期 */
    _dateLabel.text = deviceModel.sdate;
    
    /** 指派人 */
    UserModel *managerModel = [UserModel mj_objectWithKeyValues:deviceModel.manager];
    [self setWorkerView:_directorView value:managerModel];
    
    /** 工人列表 */
    _contentView.frame = CGRectMake(_directorView.left, _workerLabel.top, _directorView.width, (40+10)*deviceModel.workers.count);
    [_contentView removeAllSubviews];
    
    DQDeviceMaintainWorkerView * lastView = nil;
    NSArray *ary = [UserModel mj_objectArrayWithKeyValuesArray:deviceModel.workers];
    for (int index = 0; index < ary.count; index++) {
        
        int bottomMargin = (index > 0) ? 10 : 0;
        DQDeviceMaintainWorkerView *workerView = [[DQDeviceMaintainWorkerView alloc] init];
        workerView.frame = CGRectMake(0,(_directorView.height+bottomMargin)*index, _directorView.width, _directorView.height);
        UserModel *user = ary[index];
        [self setWorkerView:workerView value:user];
        [_contentView addSubview:workerView];
        lastView = workerView;
     }

    CGRect rect = self.frame;
    rect.size.height = CGRectGetMaxY(_contentView.frame);
    self.frame = rect;
}

- (DeviceMaintainorderModel *)getDeviceModel {
    
    DQSubMaintainModel *maintainModel = (DQSubMaintainModel *)_model.cellData;
    
    DeviceMaintainorderModel *deviceModel;
    if (_model.nodeType == DQFlowTypeFix) {
        deviceModel = maintainModel.devicerepairorder;
        _titleLabel.text = @"维修进行中";
        _workerLabel.text = @"维修员";
    } else if (_model.nodeType == DQFlowTypeHeighten) {
        deviceModel = maintainModel.deivieaddheight;
        _titleLabel.text = @"加高进行中";
        _workerLabel.text = @"加高员";
    } else if (_model.nodeType == DQFlowTypeMaintain) {
        deviceModel = maintainModel.deviceMaintainorder;
        _titleLabel.text = @"维保进行中";
        _workerLabel.text = @"维保员";
    }
    
    return deviceModel;
}


- (void)setWorkerView:(DQDeviceMaintainWorkerView *)workerView value:(UserModel *)user {
    
    workerView.numberLabel.textColor = _model.hexTitleColor;
    NSString *imageName = (_model.direction == DQDirectionLeft) ? @"ic_phone_left" : @"ic_phone_right";
    workerView.iconImageView.image = [UIImage imageNamed:imageName];
    workerView.numberLabel.text = user.dn;
    workerView.nameLabel.text = user.name;
}

- (void)setLabel:(UILabel *)label alignment:(NSTextAlignment)align textColor:(NSString *)hex font:(CGFloat)value {
    
    label.textAlignment = align;
    label.textColor = [UIColor colorWithHexString:hex];
    label.font = [UIFont dq_semiboldSystemFontOfSize:value];
    [self addSubview:label];
}

@end

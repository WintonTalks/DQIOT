//
//  DeviceWHDetailCell.m
//  WebThings
//  设备维保
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DeviceWHDetailCell.h"
#import "EMICardView.h"
#import "rightFooterView.h"
#import "leftFooterView.h"
#import "ServiceFinishBtn.h"
#import "ServiceDetailView.h"

@interface DeviceWHDetailCell()

@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWidth;
@property (weak, nonatomic) IBOutlet UIStackView *stackV;
@property (weak, nonatomic) IBOutlet UIView *bottomFatherV;
@property (nonatomic,strong) rightFooterView *rightFootV1;
@property (nonatomic,strong) leftFooterView *leftFootV1;
@property (nonatomic,strong) UIButton *finisgBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceVHei;//最下面的0间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *whnrFatherVHeight;
@property (weak, nonatomic) IBOutlet UILabel *whnrLab;

@end

@implementation DeviceWHDetailCell

+ (id)cellWithTableView:(UITableView *)tableview{
    DeviceWHDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:@"DeviceWHDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceWHDetailCell" owner:nil options:nil] objectAtIndex:0];
        cell.fatherVWidth.constant = 245*autoSizeScaleX;
    }else{
        if (cell.finisgBtn) {
            [cell.finisgBtn removeFromSuperview];
            cell.finisgBtn = nil;
        }
    }
    return cell;
}


- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model{
    self.baseServiceModel = model;
    if (!model.isNextSure) {
        _spaceVHei.constant = 15;
    }else{
        //此cell不存在驳回
        _spaceVHei.constant = 2;
    }
    if (model.direction == 0) {
        //0居左
        self.fatherVLeading.constant = 51;
    }else{
        //1居右
        self.fatherVLeading.constant = screenWidth-245*autoSizeScaleX-16;
    }
    
    for (int i = 0; i < _stackV.arrangedSubviews.count; i++) {
        if ([_stackV.arrangedSubviews[i] isKindOfClass:[ServiceDetailView class]]) {
            ServiceDetailView *item = _stackV.arrangedSubviews[i];
            switch (i) {
                case 0:
                    [item setViewValuesWithTitle:@"设备编号" WithContent:model.deviceMaintainorder.deviceno];
                    break;
                case 1:
                    [item setViewValuesWithTitle:@"安装地点" WithContent:model.deviceaddress];
                    break;
                case 2:
                    [item setViewValuesWithTitle:@"项目负责人" WithContent:model.deviceMaintainorder.chargeperson];
                    break;
                case 3:
                    [item setViewValuesWithTitle:@"联系电话" WithContent:model.deviceMaintainorder.linkdn];
                    break;
                case 4:
                    [item setViewValuesWithTitle:@"开始维保日期" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.deviceMaintainorder.sdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
                    break;
                case 5:
                    [item setViewValuesWithTitle:@"结束维保日期" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.deviceMaintainorder.edate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
                    break;
                default:
                    break;
            }
        }
    }
    if (model.direction == 0) {
        if (!_leftFootV1) {
            _leftFootV1 = [[leftFooterView alloc] init];
            [self.bottomFatherV addSubview:_leftFootV1];
        }
        _leftFootV1.frame = CGRectMake(0, 0, _bottomFatherV.frame.size.width, 40);
        [_leftFootV1 setViewValuesWithModel:model];
    } else {
        if (!_rightFootV1) {
            _rightFootV1 = [[rightFooterView alloc] initWithFrame:CGRectMake(0, 0, _bottomFatherV.frame.size.width, 40)];
            [self.bottomFatherV addSubview:_rightFootV1];
        }
        [_rightFootV1 setViewValuesWithModel:model];
    }
    
    // 租赁房和承租方都可发起设备维保
    if (model.iszulin && !model.isCEO && !model.isNextSure) {
        //已确认时间按钮
        if (!_finisgBtn) {
            _finisgBtn = [[UIButton alloc] init];
            _finisgBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            _finisgBtn.backgroundColor = [UIColor colorWithHexString:@"#3E7BE2"];
            _finisgBtn.layer.masksToBounds = YES;
            _finisgBtn.layer.cornerRadius = 2.0;
            [_finisgBtn setTag:0];//已确认时间并发起维保
            [_finisgBtn setTitle:@"已确认时间并发起维保" forState:UIControlStateNormal];
            [self.bottomFatherV addSubview:_finisgBtn];
        }
        _finisgBtn.frame = CGRectMake(12, 42, 200, 30);
    }
}

- (void)setAction1:(SEL)action1 target:(id)target{
    if (_finisgBtn) {
        [_finisgBtn addTarget:target action:action1 forControlEvents:UIControlEventTouchUpInside];
    }
}

@end

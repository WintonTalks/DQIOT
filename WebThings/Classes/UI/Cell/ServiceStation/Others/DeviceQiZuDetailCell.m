//
//  DeviceQiZuDetailCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DeviceQiZuDetailCell.h"
#import "EMICardView.h"
#import "rightFooterView.h"
#import "leftFooterView.h"
#import "ServiceBtnView.h"
#import "ServiceDetailView.h"
@interface DeviceQiZuDetailCell()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWidth;
@property (weak, nonatomic) IBOutlet UIStackView *sbxxStackV;//启租单信息
@property (weak, nonatomic) IBOutlet UIView *bottomFatherV;

@property (nonatomic,strong)rightFooterView *rightFootV1;
@property (nonatomic,strong)leftFooterView *leftFootV1;


@property (nonatomic,strong)ServiceBtnView *serviceBtnFatherV;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceVHei;//最下面的0间距
@end
@implementation DeviceQiZuDetailCell
+ (id)cellWithTableView:(UITableView *)tableview{
    DeviceQiZuDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:@"DeviceQiZuDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceQiZuDetailCell" owner:nil options:nil] objectAtIndex:0];
        cell.fatherVWidth.constant = 245*autoSizeScaleX;
    }else{
        if (cell.serviceBtnFatherV) {
            [cell.serviceBtnFatherV removeFromSuperview];
            cell.serviceBtnFatherV = nil;
        }
    }
    return cell;
}
- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model{
    if (model.isLastCommit) {
        _spaceVHei.constant = 15;
    }else{
        if (model.isLastSecondSure) {
            _spaceVHei.constant = 2;
        }else{
            _spaceVHei.constant = 0;
        }
        
    }
    
    if (model.direction == 0) {
        //0居左
        self.fatherVLeading.constant = 51;
    }else{
        //1居右
        self.fatherVLeading.constant = screenWidth-245*autoSizeScaleX-16;
    }
    
    for (int i = 0; i < _sbxxStackV.arrangedSubviews.count; i++) {
        if ([_sbxxStackV.arrangedSubviews[i] isKindOfClass:[ServiceDetailView class]]) {
            ServiceDetailView *item = _sbxxStackV.arrangedSubviews[i];
            switch (i) {
                case 0:
                    [item setViewValuesWithTitle:@"设备编号" WithContent:model.projectstartrenthistory.deviceno];
                    break;
                case 1:
                    [item setViewValuesWithTitle:@"安装地点" WithContent:model.deviceaddress];
                    break;
                case 2:
                    [item setViewValuesWithTitle:@"项目负责人" WithContent:model.projectstartrenthistory.chargeperson];
                    break;
                case 3:
                    [item setViewValuesWithTitle:@"联系电话" WithContent:model.projectstartrenthistory.linkman];
                    break;
                case 4:
                    [item setViewValuesWithTitle:@"启租日期" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.projectstartrenthistory.startdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
                    break;
                case 5:
                    [item setViewValuesWithTitle:@"产权备案号" WithContent:model.projectstartrenthistory.recordno];
                    break;
                case 6:
                    [item setViewValuesWithTitle:@"检测单位" WithContent:model.projectstartrenthistory.checkcompany];
                    break;
                case 7:
                    [item setViewValuesWithTitle:@"检测报告编号" WithContent:model.projectstartrenthistory.chckreportid];
                    
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
            _leftFootV1.sd_layout.topSpaceToView(self.bottomFatherV, 0).leftSpaceToView(self.bottomFatherV, 0).rightSpaceToView(self.bottomFatherV, 0).heightIs(40);
        }
        [_leftFootV1 setViewValuesWithModel:model];
        if (model.isLastCommit) {
            //确认驳回按钮
            if (!_serviceBtnFatherV) {
                _serviceBtnFatherV = [[ServiceBtnView alloc] init];
                [_serviceBtnFatherV setSureTag:11 againstTag:12];
                [self.bottomFatherV addSubview:_serviceBtnFatherV];
                _serviceBtnFatherV.sd_layout.topSpaceToView(self.leftFootV1, 0).leftSpaceToView(self.bottomFatherV, 0).rightSpaceToView(self.bottomFatherV, 0).heightIs(41);
            }
        }
    }else{
        if (!_rightFootV1) {
            _rightFootV1 = [[rightFooterView alloc] init];
            [self.bottomFatherV addSubview:_rightFootV1];
            _rightFootV1.sd_layout.topSpaceToView(self.bottomFatherV, 0).leftSpaceToView(self.bottomFatherV, 0).rightSpaceToView(self.bottomFatherV, 0).heightIs(40);
        }
        [_rightFootV1 setViewValuesWithModel:model];
        
    }
}
- (void)setAction1:(SEL)action1 Action2:(SEL)action2 target:(id)target{
    if (_serviceBtnFatherV) {
        [_serviceBtnFatherV setAction1:action1 Action2:action2 target:target];
    }
}
@end

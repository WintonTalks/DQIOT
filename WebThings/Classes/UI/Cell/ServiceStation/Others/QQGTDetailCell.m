//
//  QQGTDetailCell.m
//  WebThings
//
//  Created by machinsight on 2017/6/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "QQGTDetailCell.h"
#import "EMICardView.h"
#import "ServiceDetailView.h"
#import "rightFooterView.h"
#import "leftFooterView.h"
#import "ServiceBtnView.h"
#import "ServiceBohuiView.h"

@interface QQGTDetailCell()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWidth;
@property (weak, nonatomic) IBOutlet UIStackView *xmxxStackV;//项目信息
@property (weak, nonatomic) IBOutlet UILabel *xmfzrDnLab;//项目负责人手机号
@property (weak, nonatomic) IBOutlet UILabel *zjeLab;//总金额
@property (weak, nonatomic) IBOutlet UIStackView *sbxxStackV;//设备信息
@property (weak, nonatomic) IBOutlet UIView *bottomFatherV;

@property (nonatomic,strong)rightFooterView *rightFootV1;
@property (nonatomic,strong)leftFooterView *leftFootV1;


@property (nonatomic,strong)ServiceBtnView *serviceBtnFatherV;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceVHei;//最下面的0间距
@end
@implementation QQGTDetailCell

+ (id)cellWithTableView:(UITableView *)tableview{
    QQGTDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:@"QQGTDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QQGTDetailCell" owner:nil options:nil] objectAtIndex:0];
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
    for (int i = 0; i < _xmxxStackV.arrangedSubviews.count; i++) {
        if ([_xmxxStackV.arrangedSubviews[i] isKindOfClass:[ServiceDetailView class]]) {
            ServiceDetailView *item = _xmxxStackV.arrangedSubviews[i];
            switch (i) {
                case 0:
                    [item setViewValuesWithTitle:@"项目名称" WithContent:model.projecthistory.projectname];
                    break;
                case 1:
                    [item setViewValuesWithTitle:@"确认订单编号" WithContent:model.projecthistory.no];
                    break;
                case 2:
                    [item setViewValuesWithTitle:@"出租方" WithContent:model.projecthistory.providename];
                    break;
                case 3:
                    [item setViewValuesWithTitle:@"承租方" WithContent:model.projecthistory.needorgname];
                    break;
                case 4:
                    [item setViewValuesWithTitle:@"工程地点" WithContent:model.projecthistory.projectaddress];
                    break;
                case 5:
                    [item setViewValuesWithTitle:@"总包单位" WithContent:model.projecthistory.contractor];
                    break;
                case 6:
                    [item setViewValuesWithTitle:@"监理单位" WithContent:model.projecthistory.supervisor];
                    break;
                case 7:
                    [item setViewValuesWithTitle:@"预计进场时间" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.projecthistory.indate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
                    
                    break;
                case 8:
                    [item setViewValuesWithTitle:@"预计出场时间" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.projecthistory.outdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
                    break;
                case 9:
                    [item setViewValuesWithTitle:@"设备数量" WithContent:[NSString stringWithFormat:@"%ld",model.projecthistory.devicenum]];
                    break;
                case 10:
                    [item setViewValuesWithTitle:@"租金" WithContent:[NSString stringWithFormat:@"￥%@",[AppUtils formatMoney:model.projecthistory.rent]]];
                    break;
                case 11:
                    [item setViewValuesWithTitle:@"进出场费" WithContent:[NSString stringWithFormat:@"￥%@",[AppUtils formatMoney:model.projecthistory.intoutprice]]];
                    break;
                case 12:
                    [item setViewValuesWithTitle:@"司机工资" WithContent:[NSString stringWithFormat:@"￥%@",[AppUtils formatMoney:model.projecthistory.driverrent]]];
                    break;
                default:
                    break;
            }
        }
    }
    
    _xmfzrDnLab.text = model.projecthistory.dn;
    
    _zjeLab.text = [NSString stringWithFormat:@"￥%@",[AppUtils formatMoney:model.projecthistory.totalprice]];
    
    for (int i = 0; i < _sbxxStackV.arrangedSubviews.count; i++) {
        if ([_sbxxStackV.arrangedSubviews[i] isKindOfClass:[ServiceDetailView class]]) {
            ServiceDetailView *item = _sbxxStackV.arrangedSubviews[i];
            switch (i) {
                case 0:
                    [item setViewValuesWithTitle:@"设备品牌" WithContent:model.projecthistory.projectDevicehistory.brand];
                    break;
                case 1:
                    [item setViewValuesWithTitle:@"设备型号" WithContent:model.projecthistory.projectDevicehistory.model];
                    break;
                case 2:
                    [item setViewValuesWithTitle:@"预埋件安装时间" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.projecthistory.projectDevicehistory.beforehanddate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
                    break;
                case 3:
                    [item setViewValuesWithTitle:@"安装高度" WithContent:[NSString stringWithFormat:@"%.0f米",model.projecthistory.projectDevicehistory.high]];
                    break;
                case 4:
                    [item setViewValuesWithTitle:@"安装时间" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.projecthistory.projectDevicehistory.handdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
                    break;
                case 5:
                    [item setViewValuesWithTitle:@"租赁价格" WithContent:[NSString stringWithFormat:@"￥%@元",[AppUtils formatMoney:model.projecthistory.projectDevicehistory.rent]]];
                    break;
                case 6:
                    [item setViewValuesWithTitle:@"安装地点" WithContent:model.projecthistory.projectDevicehistory.installationsite];
                    break;
                case 7:
                    [item setViewValuesWithTitle:@"使用时间" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.projecthistory.projectDevicehistory.starttime WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
                    
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
        [_leftFootV1 setViewValuesWithModel:model];
        _leftFootV1.frame = CGRectMake(0, 0, _bottomFatherV.frame.size.width, 40);
        if (model.isLastCommit) {
            //确认驳回按钮
            if (!_serviceBtnFatherV) {
                _serviceBtnFatherV = [[ServiceBtnView alloc] init];
                [_serviceBtnFatherV setSureTag:1 againstTag:2];
                [self.bottomFatherV addSubview:_serviceBtnFatherV];
            }
            _serviceBtnFatherV.frame = CGRectMake(0, 40, _bottomFatherV.frame.size.width, 41);
        }
    }else{
        if (!_rightFootV1) {
            _rightFootV1 = [[rightFooterView alloc] init];
            [self.bottomFatherV addSubview:_rightFootV1];
        }
        _rightFootV1.frame = CGRectMake(0, 0, _bottomFatherV.frame.size.width, 40);
        [_rightFootV1 setViewValuesWithModel:model];
    }
    
}

- (void)setAction1:(SEL)action1 Action2:(SEL)action2 target:(id)target{
    if (_serviceBtnFatherV) {
        [_serviceBtnFatherV setAction1:action1 Action2:action2 target:target];
    }
}
@end

//
//  StopListCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "StopListCell.h"
#import "EMICardView.h"
#import "rightFooterView.h"
#import "leftFooterView.h"
#import "ServiceBtnView.h"
#import "ServiceDetailView.h"
@interface StopListCell()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWidth;
@property (weak, nonatomic) IBOutlet UIStackView *stackV;
@property (weak, nonatomic) IBOutlet UIView *bottomFatherV;

@property (nonatomic,strong)rightFooterView *rightFootV1;
@property (nonatomic,strong)leftFooterView *leftFootV1;


@property (nonatomic,strong)ServiceBtnView *serviceBtnFatherV;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceVHei;//最下面的0间距

@end
@implementation StopListCell

+ (id)cellWithTableView:(UITableView *)tableview{
    StopListCell *cell = [tableview dequeueReusableCellWithIdentifier:@"StopListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StopListCell" owner:nil options:nil] objectAtIndex:0];
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
    self.baseServiceModel = model;
    if (model.isLastCommit) {
        _spaceVHei.constant = 15;
    }else{
        if (model.isLastSecondSure) {
            _spaceVHei.constant = 2;
        }else{
            _spaceVHei.constant = 2;
        }
        
    }
    
    if (model.direction == 0) {
        //0居左
        self.fatherVLeading.constant = 51;
    } else {
        //1居右
        self.fatherVLeading.constant = screenWidth-245*autoSizeScaleX-16;
    }
    
    for (int i = 0; i < _stackV.arrangedSubviews.count; i++) {
        if ([_stackV.arrangedSubviews[i] isKindOfClass:[ServiceDetailView class]]) {
            ServiceDetailView *item = _stackV.arrangedSubviews[i];
            switch (i) {
                case 0:
                    [item setViewValuesWithTitle:@"设备编号" WithContent:model.dismantledevice.deviceno];
                    break;
                case 1:
                    [item setViewValuesWithTitle:@"安装地点" WithContent:model.deviceaddress];
                    break;
                case 2:
                    [item setViewValuesWithTitle:@"项目负责人" WithContent:model.dismantledevice.chargeperson];
                    break;
                case 3:
                    [item setViewValuesWithTitle:@"联系电话" WithContent:model.dismantledevice.linkdn];
                    break;
                case 4:
                    [item setViewValuesWithTitle:@"拆机日期" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.dismantledevice.cdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
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
//            _leftFootV1.sd_layout.topSpaceToView(self.bottomFatherV, 0).leftSpaceToView(self.bottomFatherV, 0).rightSpaceToView(self.bottomFatherV, 0).heightIs(40);
        }
        _leftFootV1.frame = CGRectMake(0, 0, _bottomFatherV.frame.size.width, 40);
        [_leftFootV1 setViewValuesWithModel:model];
        if (model.isLastCommit) {
            //费用缴清、未缴清按钮
            if (!_serviceBtnFatherV) {
                _serviceBtnFatherV = [[ServiceBtnView alloc] init];
                [_serviceBtnFatherV setSureTag:19 againstTag:20];
                [_serviceBtnFatherV setBtnTitle1:@"费用已缴清" Width1:110.f BtnTitle2:@"费用未缴清" Width2:110.f];
                [self.bottomFatherV addSubview:_serviceBtnFatherV];
//                _serviceBtnFatherV.sd_layout.topSpaceToView(self.leftFootV1, 0).leftSpaceToView(self.bottomFatherV, 0).rightSpaceToView(self.bottomFatherV, 0).heightIs(41);
            }
            _serviceBtnFatherV.frame = CGRectMake(0, 40, _bottomFatherV.frame.size.width, 41);
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

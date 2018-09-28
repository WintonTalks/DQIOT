//
//  DeviceGZDetailCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DeviceGZDetailCell.h"
#import "EMICardView.h"
#import "rightFooterView.h"
#import "leftFooterView.h"
#import "ServiceFinishBtn.h"
#import "ServiceDetailView.h"

@interface DeviceGZDetailCell()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWidth;
@property (weak, nonatomic) IBOutlet UIStackView *stackV;
@property (weak, nonatomic) IBOutlet UIView *bottomFatherV;

@property (nonatomic,strong)rightFooterView *rightFootV1;
@property (nonatomic,strong)leftFooterView *leftFootV1;

@property (nonatomic,strong)ServiceFinishBtn *finisgBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceVHei;//最下面的0间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wxLabHei;
@property (weak, nonatomic) IBOutlet UILabel *wxLab;

@end

@implementation DeviceGZDetailCell

+ (id)cellWithTableView:(UITableView *)tableview{
    DeviceGZDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:@"DeviceGZDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceGZDetailCell" owner:nil options:nil] objectAtIndex:0];
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
        self.fatherVLeading.constant = 50;
    }else{
        //1居右
        self.fatherVLeading.constant = screenWidth-245*autoSizeScaleX-16;
    }
    
    for (int i = 0; i < _stackV.arrangedSubviews.count; i++) {
        if ([_stackV.arrangedSubviews[i] isKindOfClass:[ServiceDetailView class]]) {
            ServiceDetailView *item = _stackV.arrangedSubviews[i];
            switch (i) {
                case 0:
                    [item setViewValuesWithTitle:@"设备编号" WithContent:model.devicerepairorder.deviceno];
                    break;
                case 1:
                    [item setViewValuesWithTitle:@"安装地点" WithContent:model.deviceaddress];
                    break;
                case 2:
                    [item setViewValuesWithTitle:@"项目负责人" WithContent:model.devicerepairorder.chargeperson];
                    break;
                case 3:
                    [item setViewValuesWithTitle:@"联系电话" WithContent:model.devicerepairorder.linkdn];
                    break;
                case 4:
                    [item setViewValuesWithTitle:@"开始维修日期" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.devicerepairorder.sdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
                    break;
                case 5:
                    [item setViewValuesWithTitle:@"结束维修日期" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.devicerepairorder.edate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
                    break;
//                case 6:
//                    [item setViewValuesWithTitle:@"维修内容" WithContent:model.devicerepairorder.text];
//                    break;
                default:
                    break;
            }
        }
    }
    
    _wxLab.text = model.devicerepairorder.text;
    _wxLabHei.constant = [AppUtils textHeightSystemFontString:_wxLab.text height:110.5*autoSizeScaleX font:_wxLab.font]+20;
    
    if (model.direction == 0) {
        
        if (!_leftFootV1) {
            _leftFootV1 = [[leftFooterView alloc] init];
            [self.bottomFatherV addSubview:_leftFootV1];
        }
        _leftFootV1.frame = CGRectMake(0, 0, _bottomFatherV.frame.size.width, 40);
        [_leftFootV1 setViewValuesWithModel:model];
        if (model.iszulin && !model.isCEO && !model.isNextSure) {
            //已确认时间按钮
            if (!_finisgBtn) {
                _finisgBtn = [[ServiceFinishBtn alloc] init];
                [_finisgBtn setSureTag:2];//已确认时间并发起维修
                [_finisgBtn setBtnTitle:@"已确认时间并发起维修" Width:190];
                [self.bottomFatherV addSubview:_finisgBtn];
            }
        }
        _finisgBtn.frame = CGRectMake(0, 0, _bottomFatherV.frame.size.width, 41);
    } else {
        
        if (!_rightFootV1) {
            _rightFootV1 = [[rightFooterView alloc] init];
            [self.bottomFatherV addSubview:_rightFootV1];
        }
        _rightFootV1.frame = CGRectMake(0, 0, _bottomFatherV.frame.size.width, 40);
        [_rightFootV1 setViewValuesWithModel:model];
    }
}

- (void)setAction1:(SEL)action1 target:(id)target{
    if (_finisgBtn) {
        [_finisgBtn setAction1:action1 target:target];
    }
}

- (CGFloat)cellHeight{
    //设备维修单提交";//39
    if (!self.baseServiceModel.isNextSure) {
        if (self.baseServiceModel.iszulin && !self.baseServiceModel.isCEO) {
            //多出15间隙与40按钮高度
            self.baseServiceModel.cellHeight = 375+_wxLabHei.constant;
            return self.baseServiceModel.cellHeight;
        }else{
            //多出15间隙
            self.baseServiceModel.cellHeight = 330+_wxLabHei.constant;
            return self.baseServiceModel.cellHeight;
        }
        
    }else{
        self.baseServiceModel.cellHeight = 330+_wxLabHei.constant;
        return self.baseServiceModel.cellHeight;
    }
}

@end

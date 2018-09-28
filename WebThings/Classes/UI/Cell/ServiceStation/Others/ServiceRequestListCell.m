//
//  ServiceRequestListCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceRequestListCell.h"
#import "EMICardView.h"
#import "rightFooterView.h"
#import "leftFooterView.h"
#import "ServiceFinishBtn.h"
#import "ServiceDetailView.h"

@interface ServiceRequestListCell()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWidth;
@property (weak, nonatomic) IBOutlet UIStackView *stackV;
@property (weak, nonatomic) IBOutlet UIView *bottomFatherV;

@property (nonatomic,strong)rightFooterView *rightFootV1;
@property (nonatomic,strong)leftFooterView *leftFootV1;


@property (nonatomic,strong)ServiceFinishBtn *finisgBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceVHei;//最下面的0间距
@end
@implementation ServiceRequestListCell

+ (id)cellWithTableView:(UITableView *)tableview{
    ServiceRequestListCell *cell = [tableview dequeueReusableCellWithIdentifier:@"ServiceRequestListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceRequestListCell" owner:nil options:nil] objectAtIndex:0];
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
                    [item setViewValuesWithTitle:@"设备编号" WithContent:model.deivieaddheight.deviceno];
                    break;
                case 1:
                    [item setViewValuesWithTitle:@"安装地点" WithContent:model.deviceaddress];
                    break;
                case 2:
                    [item setViewValuesWithTitle:@"项目负责人" WithContent:model.deivieaddheight.chargeperson];
                    break;
                case 3:
                    [item setViewValuesWithTitle:@"联系电话" WithContent:model.deivieaddheight.linkdn];
                    break;
                case 4:
                    [item setViewValuesWithTitle:@"开始加高日期" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.deivieaddheight.sdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
                    break;
                case 5:
                    [item setViewValuesWithTitle:@"结束加高日期" WithContent:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.deivieaddheight.edate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]];
                    break;
                case 6:
                    [item setViewValuesWithTitle:@"加高高度" WithContent:[NSString stringWithFormat:@"%ld米",model.deivieaddheight.high]];
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
            //_leftFootV1.sd_layout.topSpaceToView(self.bottomFatherV, 0).leftSpaceToView(self.bottomFatherV, 0).rightSpaceToView(self.bottomFatherV, 0).heightIs(40);
        }
        _leftFootV1.frame = CGRectMake(0, 0, self.bottomFatherV.size.width, 40);
        [_leftFootV1 setViewValuesWithModel:model];
        
        if (model.iszulin && !model.isCEO && !model.isNextSure) {
            //已确认时间按钮
            if (!_finisgBtn) {
                _finisgBtn = [[ServiceFinishBtn alloc] init];
                [_finisgBtn setSureTag:4];//已确认时间并发起加高
                [_finisgBtn setBtnTitle:@"已确认时间并发起加高" Width:190];
                [self.bottomFatherV addSubview:_finisgBtn];
                //_finisgBtn.sd_layout.topSpaceToView(self.leftFootV1, 0).leftSpaceToView(self.bottomFatherV, 0).rightSpaceToView(self.bottomFatherV, 0).heightIs(41);
            }
            _finisgBtn.frame = CGRectMake(0, CGRectGetMaxY(self.leftFootV1.frame), self.leftFootV1.size.width, 41);
        }
    } else {
        if (!_rightFootV1) {
            _rightFootV1 = [[rightFooterView alloc] init];
            [self.bottomFatherV addSubview:_rightFootV1];
            //_rightFootV1.sd_layout.topSpaceToView(self.bottomFatherV, 0).leftSpaceToView(self.bottomFatherV, 0).rightSpaceToView(self.bottomFatherV, 0).heightIs(40);
        }
        _leftFootV1.frame = CGRectMake(0, 0, self.bottomFatherV.size.width, 40);
        [_rightFootV1 setViewValuesWithModel:model];
    }
    
}

- (void)setAction1:(SEL)action1 target:(id)target{
    if (_finisgBtn) {
        [_finisgBtn setAction1:action1 target:target];
    }
    
    
}
@end

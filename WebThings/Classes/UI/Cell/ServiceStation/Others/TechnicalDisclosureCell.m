//
//  TechnicalDisclosureCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "TechnicalDisclosureCell.h"
#import "EMICardView.h"
#import "ServiceFinishedLeftView.h"
#import "ServiceFinishedRightView.h"
#import "rightFooterView.h"
#import "leftFooterView.h"
#import "ServiceBtnView.h"
#import "ServiceFinishBtn.h"

@interface TechnicalDisclosureCell()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWidth;


@property (weak, nonatomic) IBOutlet UIView *finishFatherV;
@property (weak, nonatomic) IBOutlet UIView *footFatherV;
@property (weak, nonatomic) IBOutlet UIView *btnFatherV;
@property (nonatomic,strong)ServiceFinishedRightView *rightFinishV1;
@property (nonatomic,strong)ServiceFinishedLeftView *leftFinishV1;
@property (nonatomic,strong)rightFooterView *rightFootV1;
@property (nonatomic,strong)leftFooterView *leftFootV1;


@property (nonatomic,strong)ServiceBtnView *serviceBtnFatherV;
@property (nonatomic,strong)ServiceFinishBtn *serviceFinishBtnFatherV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceVHei;//最下面的0间距
@end
@implementation TechnicalDisclosureCell

+ (id)cellWithTableView:(UITableView *)tableview{
    TechnicalDisclosureCell *cell = [tableview dequeueReusableCellWithIdentifier:@"TechnicalDisclosureCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TechnicalDisclosureCell" owner:nil options:nil] objectAtIndex:0];
        cell.fatherVWidth.constant = 245*autoSizeScaleX;
    }else{
        if (cell.serviceBtnFatherV) {
            [cell.serviceBtnFatherV removeFromSuperview];
            cell.serviceBtnFatherV = nil;
        }
        if (cell.serviceFinishBtnFatherV) {
            [cell.serviceFinishBtnFatherV removeFromSuperview];
            cell.serviceFinishBtnFatherV = nil;
        }
    }
    
    return cell;
}

- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model{
    self.baseServiceModel = model;
    if (model.isLastCommit || model.isNextForm) {
        _spaceVHei.constant = 15;
    }else{
        if (model.isLastSecondSure) {
            _spaceVHei.constant = 1;
        }else{
            _spaceVHei.constant = 1;
        }
    }
    
    if (model.direction == 0) {
        //0居左
        self.fatherVLeading.constant = 51;
    }else{
        //1居右
        self.fatherVLeading.constant = screenWidth-245*autoSizeScaleX-16;
    }
    
    if (model.direction == 0) {
        if (!_leftFinishV1) {
            _leftFinishV1 = [[ServiceFinishedLeftView alloc] init];
            [self.finishFatherV addSubview:_leftFinishV1];
            _leftFinishV1.sd_layout.topSpaceToView(self.finishFatherV, 0).leftSpaceToView(self.finishFatherV, 0).rightSpaceToView(self.finishFatherV, 0).bottomSpaceToView(self.finishFatherV, 0);
        }
        [_leftFinishV1 setViewValuesWithModel:model];
        if (!_leftFootV1) {
            _leftFootV1 = [[leftFooterView alloc] init];
            [self.footFatherV addSubview:_leftFootV1];
//            _leftFootV1.sd_layout.topSpaceToView(self.footFatherV, 0).leftSpaceToView(self.footFatherV, 0).rightSpaceToView(self.footFatherV, 0).bottomSpaceToView(self.footFatherV, 0);
        }
        _leftFootV1.frame = CGRectMake(0, 0, _footFatherV.frame.size.width, 40);
        [_leftFootV1 setViewValuesWithModel:model];
        if (model.isLastCommit || model.isNextForm) {
            //确认驳回按钮
            if (!_serviceBtnFatherV) {
                _serviceBtnFatherV = [[ServiceBtnView alloc] init];
                [self.btnFatherV addSubview:_serviceBtnFatherV];
//                _serviceBtnFatherV.sd_layout.topSpaceToView(self.btnFatherV, 0).leftSpaceToView(self.btnFatherV, 0).rightSpaceToView(self.btnFatherV, 0).bottomSpaceToView(self.btnFatherV, 0);
            }
            _serviceBtnFatherV.frame = CGRectMake(0, 10, _btnFatherV.frame.size.width, 40);
        }
        
    } else {
        if (!_rightFinishV1) {
            _rightFinishV1 = [[ServiceFinishedRightView alloc] init];
            [self.finishFatherV addSubview:_rightFinishV1];
            _rightFinishV1.sd_layout.topSpaceToView(self.finishFatherV, 0).leftSpaceToView(self.finishFatherV, 0).rightSpaceToView(self.finishFatherV, 0).bottomSpaceToView(self.finishFatherV, 0);
        }
        [_rightFinishV1 setViewValuesWithModel:model];
        if (!_rightFootV1) {
            _rightFootV1 = [[rightFooterView alloc] init];
            [self.footFatherV addSubview:_rightFootV1];
            _rightFootV1.sd_layout.topSpaceToView(self.footFatherV, 0).leftSpaceToView(self.footFatherV, 0).rightSpaceToView(self.footFatherV, 0).bottomSpaceToView(self.footFatherV, 0);
        }
        [_rightFootV1 setViewValuesWithModel:model];
    }
}

- (void)setAction1:(SEL)action1 Action2:(SEL)action2 target:(id)target{
    if (_serviceBtnFatherV) {
        [_serviceBtnFatherV setAction1:action1 Action2:action2 target:target];
    }
}

- (void)setBtnTag1:(NSInteger)tag1 Tag2:(NSInteger)tag2{
    if (_serviceBtnFatherV) {
        [_serviceBtnFatherV setSureTag:tag1 againstTag:tag2];
    }
}

@end

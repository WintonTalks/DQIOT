//
//  NoProblemRightCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NoProblemRightCell.h"
#import "EMICardView.h"
#import "ServiceFinishedRightView.h"
#import "rightFooterView.h"
#import "ServiceFinishBtn.h"

@interface NoProblemRightCell()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWidth;

@property (weak, nonatomic) IBOutlet ServiceFinishedRightView *finishV;
@property (weak, nonatomic) IBOutlet rightFooterView *footV;


@property (weak, nonatomic) IBOutlet ServiceFinishBtn *finisgBtn;
@end

@implementation NoProblemRightCell

+ (id)cellWithTableView:(UITableView *)tableview{
    NoProblemRightCell *cell = [tableview dequeueReusableCellWithIdentifier:@"NoProblemRightCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoProblemRightCell" owner:nil options:nil] objectAtIndex:0];
        cell.fatherVWidth.constant = 245*autoSizeScaleX;
    }

    return cell;
}


- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model{
    _finisgBtn.hidden = YES;
    
    self.baseServiceModel = model;
    
    if (model.direction == 0) {
        //0居左
        self.fatherVLeading.constant = 51;
    }else{
        //1居右
        self.fatherVLeading.constant = screenWidth-245*autoSizeScaleX-16;
    }
    
    [self.finishV setViewValuesWithModel:model];
    [self.footV setViewValuesWithModel:model];
    
    if ((model.enumstateid == 36 || model.enumstateid == 40 || model.enumstateid == 44) && model.iszulin && !model.isCEO && !model.isNextCommit) {
        _finisgBtn.hidden = NO;
            //tag1:我已完成维保140 enumstateid 36
            //3:我已完成维修140                40
            //5：我已完成加高140               44
            switch (model.enumstateid) {
                case 36:
                    [_finisgBtn setSureTag:1];
                    [_finisgBtn setBtnTitle:@"我已完成维保" Width:140];
                    break;
                case 40:
                    [_finisgBtn setSureTag:3];
                    [_finisgBtn setBtnTitle:@"我已完成维修" Width:140];
                    break;
                case 44:
                    [_finisgBtn setSureTag:5];
                    [_finisgBtn setBtnTitle:@"我已完成加高" Width:140];
                    break;
                default:
                    break;
            }
        
    }
    
    if (model.enumstateid == 31 && !model.isCEO && model.iszulin && model.isLast) {
        //停租单驳回
        _finisgBtn.hidden = NO;
        [_finisgBtn setSureTag:6];
        [_finisgBtn setBtnTitle:@"费用已缴清" Width:140];
    }
}


- (void)setAction1:(SEL)action1 target:(id)target{
    [_finisgBtn setAction1:action1 target:target];
    
}
@end

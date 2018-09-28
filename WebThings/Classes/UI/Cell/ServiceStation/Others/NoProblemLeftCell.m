//
//  NoProblemCell.m
//  WebThings
//
//  Created by machinsight on 2017/6/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NoProblemLeftCell.h"
#import "ServiceFinishedLeftView.h"
#import "leftFooterView.h"
#import "EMICardView.h"
@interface NoProblemLeftCell()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWidth;

@property (weak, nonatomic) IBOutlet ServiceFinishedLeftView *finishV;
@property (weak, nonatomic) IBOutlet leftFooterView *footV;

@end
@implementation NoProblemLeftCell

+ (id)cellWithTableView:(UITableView *)tableview{
    NoProblemLeftCell *cell = [tableview dequeueReusableCellWithIdentifier:@"NoProblemLeftCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoProblemLeftCell" owner:nil options:nil] objectAtIndex:0];
        cell.fatherVWidth.constant = 245*autoSizeScaleX;
    }

    return cell;
}


- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model{
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
}
@end

//
//  BaoHuiCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "BaoHuiCell.h"
#import "EMICardView.h"
#import "leftFooterView.h"
@interface BaoHuiCell()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWidth;
@property (weak, nonatomic) IBOutlet leftFooterView *footerV;
@end
@implementation BaoHuiCell

+ (id)cellWithTableView:(UITableView *)tableview{
    BaoHuiCell *cell = [tableview dequeueReusableCellWithIdentifier:@"BaoHuiCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BaoHuiCell" owner:nil options:nil] objectAtIndex:0];
        cell.fatherVWidth.constant = 245*autoSizeScaleX;
    }
    
    return cell;
}


- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model{
    if (model.direction == 0) {
        //0居左
        self.fatherVLeading.constant = 51;
    }else{
        //1居右
        self.fatherVLeading.constant = screenWidth-245*autoSizeScaleX-16;
    }
    [self.footerV setViewValuesWithModel:model];
}
@end

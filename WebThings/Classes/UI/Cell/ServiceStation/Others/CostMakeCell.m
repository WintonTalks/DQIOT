//
//  CostMakeCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CostMakeCell.h"
#import "EMICardView.h"
@interface CostMakeCell()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWid;
@property (weak, nonatomic) IBOutlet UILabel *jccfLab;//进出场费（￥0元）
@property (weak, nonatomic) IBOutlet UILabel *sjgzLab;
@property (weak, nonatomic) IBOutlet UILabel *zjLab;
@end
@implementation CostMakeCell
+ (id)cellWithTableView:(UITableView *)tableview{
    CostMakeCell *cell = [tableview dequeueReusableCellWithIdentifier:@"CostMakeCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CostMakeCell" owner:nil options:nil] objectAtIndex:0];
        cell.fatherVWid.constant = 245*autoSizeScaleX;
        cell.fatherVLeading.constant = 36+(screenWidth-36-245*autoSizeScaleX)/2;
    }
    return cell;
}

- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model{
    _jccfLab.text = [NSString stringWithFormat:@"进出场费（￥%.0f元）",model.pricelist.intoutprice];
    _sjgzLab.text = [NSString stringWithFormat:@"司机工资（￥%.0f元）",model.pricelist.driverrent];
    _zjLab.text = [NSString stringWithFormat:@"租金（￥%.0f元）",model.pricelist.realrent];
}
@end

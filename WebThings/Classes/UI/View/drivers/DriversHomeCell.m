//
//  DriversHomeCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/24.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DriversHomeCell.h"
@interface DriversHomeCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *noteLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@end
@implementation DriversHomeCell

+ (id)cellWithTableView:(UITableView *)tableview{
    DriversHomeCell *cell = [tableview dequeueReusableCellWithIdentifier:@"DriversHomeCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DriversHomeCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}


- (void)setViewWithValues:(DeviceModel *)model{
    _nameLab.text = model.deviceno;
    _addressLab.text = [NSString stringWithFormat:@"安装地点：%@",model.address];
    _noteLab.text = model.note;
    _timeLab.text = model.cdate;
}
@end

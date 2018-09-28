//
//  DriverProgressCell.m
//  WebThings
//
//  Created by machinsight on 2017/8/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DriverProgressCell.h"
@interface DriverProgressCell()
@property (weak, nonatomic) IBOutlet CKRippleButton *btn;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *dateImg;
@end
@implementation DriverProgressCell

+ (id)cellWithTableView:(UITableView *)tableview{
    DriverProgressCell *cell = [tableview dequeueReusableCellWithIdentifier:@"DriverProgressCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DriverProgressCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}


- (void)setViewValuesWithModel:(DWMsgModel *)model{
    if (model.isFirst) {
        [_btn setBackgroundImage:[UIImage imageNamed:@"ic_check_circle"] forState:UIControlStateNormal];
        _titleLab.textColor = [UIColor colorWithHexString:@"#3782E5"];
        _timeLab.textColor = [UIColor colorWithHexString:@"#3782E5"];
        _dateImg.image = [UIImage imageNamed:@"ic_date_blue"];
        _lineV.backgroundColor = [UIColor colorWithHexString:@"#3C7FE9"];
    }else{
        [_btn setBackgroundImage:[UIImage imageNamed:@"ic_check_circle_hui"] forState:UIControlStateNormal];
        _titleLab.textColor = [UIColor colorWithHexString:@"#3C4144"];
        _timeLab.textColor = [UIColor colorWithHexString:@"#78797A"];
        _dateImg.image = [UIImage imageNamed:@"ic_date"];
        _lineV.backgroundColor = [UIColor colorWithHexString:@"#9D9E9F"];
    }
    
    if (model.isLast) {
        _lineV.hidden = YES;
    }
    
    _titleLab.text = model.msg;
//    _timeLab.text = [DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.cdate WithOrignFormat:@"yyyy-MM-dd HH:mm:ss"];
    _timeLab.text = model.cdate;
}
@end

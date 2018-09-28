//
//  RobotRightCell.m
//  WebThings
//
//  Created by machinsight on 2017/6/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotRightCell.h"
@interface RobotRightCell()
@property (weak, nonatomic) IBOutlet UIView *bgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgVWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgVHeight;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@end
@implementation RobotRightCell

+ (id)cellWithTableView:(UITableView *)tableview{
    RobotRightCell *cell = [tableview dequeueReusableCellWithIdentifier:@"RobotRightCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotRightCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}


- (void)setValuesWithModel:(ChatModel *)model
{
    _contentLab.text = model.data;
//    CGSize realSize = [_contentLab boundingRectWithSize:CGSizeMake(240-24, 0)];
   
    CGFloat width = [AppUtils textWidthSystemFontString:_contentLab.text height:240-24 font:_contentLab.font];
    _bgVWidth.constant = width+26;
    _bgVHeight.constant = 22;
}

- (CGFloat)cellHeight{
    return _bgVHeight.constant+24;
}

@end

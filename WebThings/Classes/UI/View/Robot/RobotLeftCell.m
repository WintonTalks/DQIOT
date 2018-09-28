//
//  RobotLeftCell.m
//  WebThings
//
//  Created by machinsight on 2017/6/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotLeftCell.h"
@interface RobotLeftCell()
@property (weak, nonatomic) IBOutlet UIView *bgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgVWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgVHeight;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
    
@end
@implementation RobotLeftCell

+ (id)cellWithTableView:(UITableView *)tableview{
    RobotLeftCell *cell = [tableview dequeueReusableCellWithIdentifier:@"RobotLeftCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotLeftCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}


- (void)setValuesWithModel:(ChatModel *)model
{
    _contentLab.text = model.data;
    CGFloat height = [AppUtils textHeightSystemFontString:_contentLab.text height:240-24 font:_contentLab.font];
    CGFloat width = [AppUtils textWidthSystemFontString:_contentLab.text height:_contentLab.height font:_contentLab.font];
    _bgVWidth.constant = width+26;
    _bgVHeight.constant = height+22;
}

- (CGFloat)cellHeight{
    return _bgVHeight.constant+24;
}
@end

//
//  RobotContainerCell.m
//  WebThings
//
//  Created by machinsight on 2017/6/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotContainerCell.h"
#import "EMICardView.h"
@interface RobotContainerCell()
@property (weak, nonatomic) IBOutlet EMICardView *cardView;

@property (strong,nonatomic)UIView *childV;
@end
@implementation RobotContainerCell

+ (id)cellWithTableView:(UITableView *)tableview{
    RobotContainerCell *cell = [tableview dequeueReusableCellWithIdentifier:@"RobotContainerCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotContainerCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}


- (void)setView:(UIView *)childView{
    _childV = childView;
    [_cardView addSubview:childView];
    childView.sd_layout.leftSpaceToView(_cardView, 0).topSpaceToView(_cardView, 0).rightSpaceToView(_cardView, 0).bottomSpaceToView(_cardView, 0);
}

- (CGFloat)cellHeight
{
    return _childV.frame.size.height+24;
}
@end

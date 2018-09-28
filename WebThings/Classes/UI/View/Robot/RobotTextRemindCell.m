//
//  RobotTextRemindCell.m
//  WebThings
//
//  Created by machinsight on 2017/7/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotTextRemindCell.h"
@interface RobotTextRemindCell()
@property (weak, nonatomic) IBOutlet UITextView *tv;

@end
@implementation RobotTextRemindCell

+ (id)cellWithTableView:(UITableView *)tableview{
    RobotTextRemindCell *cell = [tableview dequeueReusableCellWithIdentifier:@"RobotTextRemindCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotTextRemindCell" owner:nil options:nil] objectAtIndex:0];
        [cell setGradient];
        [cell.tv setText:@"\n\n你好吗\n\n我很好\n\n我叫machinsight\n\n他叫金鑫楠\n\n我们是同事\n\n树上有10只鸟\n\n开枪打死一只\n\n请问还剩几只\n\n答案就是\n\n一只不剩\n\n"];
    }
    return cell;
}

- (void)setGradient{
    //实现背景渐变 //初始化我们需要改变背景色的UIView，并添加在视图上
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.tv.bounds;
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.tv.layer addSublayer:gradientLayer];
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"FFFFFF" alpha:0.0].CGColor, (__bridge id)[UIColor colorWithHexString:@"FFFFFF" alpha:1.0].CGColor];
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = @[@(0.0f), @(1.0f)];

}

- (CGFloat)cellHeight
{
    return 424;
}
@end

//
//  RobotRemindView.m
//  WebThings
//
//  Created by machinsight on 2017/8/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotRemindView.h"
@interface RobotRemindView()
@property (weak, nonatomic) IBOutlet UITextView *tv;
@end
@implementation RobotRemindView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"RobotRemindView" owner:nil options:nil] objectAtIndex:0];
    self.frame = frame;
    if (self) {
        [self setGradient];
        [self.tv setText:@"\n\n你可以让我做这些\n\nXX设备启动租赁\n\nXX设备锁机\n\nXX设备故障\n\nXX设备停止租赁\n\nXX设备维修\n\nXX设备维保\n\nXX设备加高\n\nXX设备日报\n\n打电话给\n\n提醒\n\n你好\n\n"];
    }
    return self;
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
@end

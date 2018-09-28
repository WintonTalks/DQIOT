//
//  ChangeAnchorPoint.m
//  WebThings
//
//  Created by machinsight on 2017/6/20.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ChangeAnchorPoint.h"

@implementation ChangeAnchorPoint
//支点
+ (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}
//恢复默认支点
+ (void)setDefaultAnchorPointforView:(UIView *)view
{
    [self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:view];
}
@end

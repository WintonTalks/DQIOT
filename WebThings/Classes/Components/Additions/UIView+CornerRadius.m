//
//  UIView+CornerRadius.m
//  taojin
//
//  Created by machinsight on 17/3/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)
- (void)withRadius:(CGFloat)radius{
    self.clipsToBounds = YES;
    self.layer.masksToBounds  =YES;
    self.layer.cornerRadius = radius;
}

- (void)borderColor:(UIColor *)color{
    self.layer.borderColor = color.CGColor;
}

- (void)borderWid:(CGFloat)wid{
    self.layer.borderWidth = wid;
}

- (void)bezierPathWithRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


@end

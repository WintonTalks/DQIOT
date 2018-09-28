//
//  UIView+CornerRadius.h
//  taojin
//
//  Created by machinsight on 17/3/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (CornerRadius)

- (void)withRadius:(CGFloat)radius;

- (void)borderColor:(UIColor *)color;

- (void)borderWid:(CGFloat)wid;

/** 贝塞尔曲线画圆角
 * @param corners 那个角需要画圆
 # @param cornerRadii 圆角半径
 */
- (void)bezierPathWithRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

@end

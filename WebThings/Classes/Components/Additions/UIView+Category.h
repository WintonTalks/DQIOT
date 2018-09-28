//
//  UIView+Category.h
//
//
//  Created by Eugene on 2017/3/3.
//  Copyright © 2017年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

@property(assign, nonatomic) CGFloat centerX;
@property(assign, nonatomic) CGFloat centerY;

@property(assign, nonatomic) CGFloat top;
@property(assign, nonatomic) CGFloat left;
@property(assign, nonatomic) CGFloat bottom;
@property(assign, nonatomic) CGFloat right;

@property(assign, nonatomic) CGFloat width;
@property(assign, nonatomic) CGFloat height;

@property(assign, nonatomic) CGPoint origin;
@property(assign, nonatomic) CGSize  size;

/// mesonry 多视图等宽高间距布局
//- (void)distributeSpacingHorizontallyWith:(NSArray*)views;
//- (void)distributeSpacingVerticallyWith:(NSArray*)views;

/** 获取当前view 所在的ViewController */
- (UIViewController *)getCurrentViewController;
- (UIViewController *)getConfigViewController;

/// 移除所有子视图
- (void)removeAllSubviews;

/// 添加一组视图
- (void)addSubviewsWithArray:(NSArray *)subViews;

/// 设置圆角
- (void)radius:(float)radius borderWidth:(float)width borderColor:(UIColor *)color;

/** 设置指定view的圆角 */
- (void)radius:(float)radius corners:(UIRectCorner)corners;


/**
 添加阴影效果

 @param color 阴影的颜色
 @param offset 设置偏移
 @param radius 圆角
 */
- (void)configShadowView:(UIColor *)color
                  offset:(CGSize)offset
                  radius:(CGFloat)radius;

@end

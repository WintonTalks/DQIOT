//
//  UIView+Category.m
//
//
//  Created by Eugene on 2017/3/3.
//  Copyright © 2017年 Eugene. All rights reserved.
//

#import "UIView+Category.h"
//#import <Masonry.h>

@implementation UIView (Category)

#pragma mark - setter

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - getter

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGFloat)top {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)left {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGSize)size {
    return self.frame.size;
}

#pragma mark - masonry
//- (void) distributeSpacingHorizontallyWith:(NSArray*)views
//{
//    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
//    
//    for ( int i = 0 ; i < views.count+1 ; ++i )
//    {
//        UIView *v = [UIView new];
//        [spaces addObject:v];
//        [self addSubview:v];
//        
//        [v mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(v.mas_height);
//        }];
//    }
//    
//    UIView *v0 = spaces[0];
//    
//    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.centerY.equalTo(((UIView*)views[0]).mas_centerY);
//    }];
//    
//    UIView *lastSpace = v0;
//    for ( int i = 0 ; i < views.count; ++i )
//    {
//        UIView *obj = views[i];
//        UIView *space = spaces[i+1];
//        
//        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(lastSpace.mas_right);
//        }];
//        
//        [space mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(obj.mas_right);
//            make.centerY.equalTo(obj.mas_centerY);
//            make.width.equalTo(v0);
//        }];
//        
//        lastSpace = space;
//    }
//    
//    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right);
//    }];
//    
//}
//
//- (void) distributeSpacingVerticallyWith:(NSArray*)views
//{
//    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
//    
//    for ( int i = 0 ; i < views.count+1 ; ++i )
//    {
//        UIView *v = [UIView new];
//        [spaces addObject:v];
//        [self addSubview:v];
//        
//        [v mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(v.mas_height);
//        }];
//    }
//    
//    
//    UIView *v0 = spaces[0];
//    
//    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.centerX.equalTo(((UIView*)views[0]).mas_centerX);
//    }];
//    
//    UIView *lastSpace = v0;
//    for ( int i = 0 ; i < views.count; ++i )
//    {
//        UIView *obj = views[i];
//        UIView *space = spaces[i+1];
//        
//        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(lastSpace.mas_bottom);
//        }];
//        
//        [space mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(obj.mas_bottom);
//            make.centerX.equalTo(obj.mas_centerX);
//            make.height.equalTo(v0);
//        }];
//        
//        lastSpace = space;
//    }
//    
//    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom);
//    }];
//    
//}

#pragma mark - method
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentViewController {
    return [self getConfigViewController];
}

/**
 *  返回当前视图的控制器
 */
- (UIViewController *)getConfigViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)removeAllSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

#pragma mark - 添加一组子view：
- (void)addSubviewsWithArray:(NSArray *)subViews {
    
    for (UIView *view in subViews) {
        
        [self addSubview:view];
    }
}

///设置圆角
- (void)radius:(float)radius borderWidth:(float)width borderColor:(UIColor *)color {
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}

/** 设置指定view的圆角 */
- (void)radius:(float)radius corners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)configShadowView:(UIColor *)color
            offset:(CGSize)offset
            radius:(CGFloat)radius
{
    UIView * shadow = [[UIView alloc] initWithFrame:self.bounds];
    shadow.layer.shadowColor = color.CGColor;
    shadow.layer.shadowOffset = offset;
    shadow.layer.shadowOpacity = 1;
    shadow.layer.shadowRadius = radius;
    shadow.layer.cornerRadius = radius;
    shadow.clipsToBounds = false;
    [shadow addSubview: self];
}









@end

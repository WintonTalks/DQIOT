//
//  CXCliper.h
//  CXCliper
//
//  Created by 柴炫炫 on 16/5/10.
//  Copyright © 2016年 柴炫炫. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, GridCornerStyle) {
    GridCornerStyleCircle,
    GridCornerStyleLine
};


@interface CXCliper : UIView

@property (nonatomic) BOOL showShadow;                  // 是否显示阴影
@property (nonatomic) BOOL showGridCorner;              // 是否显示网格边角
@property (nonatomic) BOOL showGridLine;                // 是否显示网格线

@property (nonatomic, strong) UIColor *shadowColor;     // 阴影区域颜色
@property (nonatomic, strong) UIColor *gridLineColor;   // 网格线颜色
@property (nonatomic, strong) UIColor *gridCornerColor; // 网格边角颜色
@property (nonatomic, strong) UIColor *gridFillColor;   // 网格框填充颜色
@property (nonatomic, strong) UIColor *gridBorderColor; // 网格框边框颜色

@property (nonatomic) CGFloat gridHorizontalCount;      // 网格框水平方向个数
@property (nonatomic) CGFloat gridVerticalCount;        // 网格框垂直方向个数
@property (nonatomic) CGFloat gridLineWidth;            // 网格线宽度
@property (nonatomic) CGFloat gridCornerWidth;          // 网格边角线宽度
@property (nonatomic) CGFloat gridCornerHeight;         // 网格边角线高度
@property (nonatomic) CGFloat gridCornerRadius;         // 网格边角半径

@property (nonatomic) GridCornerStyle gridCornerStyle;  // 网格框边角样式


// 初始化剪切视图
- (id)initWithImageView:(UIImageView *)imageView;

// 获取剪切图片
- (UIImage *)getClipImage;
- (CGRect)getClipRect;
- (void)setClipRect:(CGRect)rect;

@end


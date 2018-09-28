//
//  UIButton+EdgeInsets.h
//  WebThings
//
//  Created by Eugene on 2017/9/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, TQButtonEdgeInsetsStyle) {
    TQButtonEdgeInsetsStyleTop, // image在上，label在下
    TQButtonEdgeInsetsStyleLeft, // image在左，label在右
    TQButtonEdgeInsetsStyleBottom, // image在下，label在上
    TQButtonEdgeInsetsStyleRight // image在右，label在左
};


@interface UIButton (EdgeInsets)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(TQButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 *  @param value titleLabel和imageView两者的在button中的偏移量（默认居中）
 *  @warning 此方法中参数value还不完善，慎用。可以使用上面👆的方法
 */
- (void)layoutButtonWithEdgeInsetsStyle:(TQButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space
                      contentViewOffset:(CGFloat)value;


@end

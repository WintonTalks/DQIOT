//
//  UIColor+Hex.h
//  SlideDemo
//
//  Created by WongSuechang on 15/3/26.
//  Copyright (c) 2015年 emi365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//返回一个CGColorRef,这类颜色用于边框颜色
+ (CGColorRef)cgcolorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (CGColorRef)cgcolorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end

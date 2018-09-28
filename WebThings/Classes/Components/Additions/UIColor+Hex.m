//
//  UIColor+Hex.m
//  SlideDemo
//
//  Created by WongSuechang on 15/3/26.
//  Copyright (c) 2015年 emi365. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

/**
 *  将十六进制的颜色代码转为UIColor
 *
 *  @param color 十六进制数字
 *  @param alpha 透明度
 *
 *  @return 所要的UIColor颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}
/**
 *  直接转为
 *
 *  @param color 十六进制数字
 *
 *  @return 所要的UIColor颜色
 */
//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
}



/**
 *  将十六进制的颜色代码转为UIColor
 *
 *  @param color 十六进制数字
 *  @param alpha 透明度
 *
 *  @return 所要的CGColorRef颜色
 */
+ (CGColorRef)cgcolorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //设置颜色样式为rgb模式
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return CGColorCreate(colorRef, (CGFloat[]){1,1,1,1});
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return CGColorCreate(colorRef, (CGFloat[]){1,1,1,1});
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return CGColorCreate(colorRef, (CGFloat[]){((float)r / 255.0f),((float)g / 255.0f),((float)b / 255.0f),alpha});
}

/**
 *  直接转为
 *
 *  @param color 十六进制数字
 *
 *  @return 所要的CGColorRef颜色
 */
//默认alpha值为1
+ (CGColorRef)cgcolorWithHexString:(NSString *)color
{
    return [self cgcolorWithHexString:color alpha:1.0f];
}
@end

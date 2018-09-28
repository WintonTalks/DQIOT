//
//  UIFont+Font.m
//  DQDemo
//
//  Created by Eugene on 2017/9/12.
//  Copyright © 2017年 Eugene. All rights reserved.
//
/** iOS 9.0以后系统自带苹方字体 PingFangSC */
#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0]

#import "UIFont+Font.h"

@implementation UIFont (Font)

#pragma mark - Public Methods
+ (UIFont *)dq_boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];;
}

+ (UIFont *)dq_semiboldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontWithName:@"PingFangSC-Semibold" size:fontSize];
}

+ (UIFont *)dq_mediumSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontWithName:@"PingFangSC-Medium" size:fontSize];
}

+ (UIFont *)dq_regularSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontWithName:@"PingFangSC-Regular" size:fontSize];
}

+ (UIFont *)dq_lightSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontWithName:@"PingFangSC-Light" size:fontSize];
}

+ (UIFont *)dq_thinSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontWithName:@"PingFangSC-Thin" size:fontSize];
}

+ (UIFont *)dq_ultraLightSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont systemFontWithName:@"PingFangSC-Ultralight" size:fontSize];
}

#pragma mark - Private Methods
+ (UIFont *)systemFontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    // iOS 9.0 之后才有的苹方字体，若为空，则可能系统低于9.0
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    if (font == nil) {
        return [UIFont systemFontOfSize:fontSize weight:[UIFont systemFontName:fontName]];
    }
    return font;
}

+ (CGFloat)systemFontName:(NSString *)fontName {
    
    if ([fontName isEqualToString:@"PingFangSC-Semibold"]) {
        return UIFontWeightSemibold;
    } else if ([fontName isEqualToString:@"PingFangSC-Medium"]) {
        return UIFontWeightMedium;
    } else if ([fontName isEqualToString:@"PingFangSC-Regular"]) {
        return UIFontWeightRegular;
    } else if ([fontName isEqualToString:@"PingFangSC-Light"]) {
        return UIFontWeightLight;
    } else if ([fontName isEqualToString:@"PingFangSC-Thin"]) {
        return UIFontWeightThin;
    } else if ([fontName isEqualToString:@"PingFangSC-Ultralight"]) {
        return UIFontWeightUltraLight;
    }
    return UIFontWeightRegular;
}

/** 
  family ：PingFang TC (繁体中文)
   font Name：PingFangTC-Medium
   font Name：PingFangTC-Regular
   font Name：PingFangTC-Light
   font Name：PingFangTC-Ultralight
   font Name：PingFangTC-Semibold
   font Name：PingFangTC-Thin
  family ：PingFang HK (港体中文)
   font Name：PingFangHK-Ultralight
   font Name：PingFangHK-Semibold
   font Name：PingFangHK-Thin
   font Name：PingFangHK-Light
   font Name：PingFangHK-Regular
   font Name：PingFangHK-Medium
  family ：PingFang SC (简体中文)
   font Name：PingFangSC-Ultralight
   font Name：PingFangSC-Regular
   font Name：PingFangSC-Semibold
   font Name：PingFangSC-Thin
   font Name：PingFangSC-Light
   font Name：PingFangSC-Medium
 */
@end

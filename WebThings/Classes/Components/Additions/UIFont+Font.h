//
//  UIFont+Font.h
//  DQDemo
//
//  Created by Eugene on 2017/9/12.
//  Copyright © 2017年 Eugene. All rights reserved.
///  拓展系统PingFang常用字体
#import <UIKit/UIKit.h>

@interface UIFont (Font)

/** bold 粗体 */
+ (UIFont *)dq_boldSystemFontOfSize:(CGFloat)fontSize;

/** semibold 半粗体,中粗字体 */
+ (UIFont *)dq_semiboldSystemFontOfSize:(CGFloat)fontSize;

/** medium 中黑字体 */
+ (UIFont *)dq_mediumSystemFontOfSize:(CGFloat)fontSize;

/** regular 常规字体 */
+ (UIFont *)dq_regularSystemFontOfSize:(CGFloat)fontSize;

/** light 细体*/
+ (UIFont *)dq_lightSystemFontOfSize:(CGFloat)fontSize;

/** thin 纤细体*/
+ (UIFont *)dq_thinSystemFontOfSize:(CGFloat)fontSize;

/** 极细体 */
+ (UIFont *)dq_ultraLightSystemFontOfSize:(CGFloat)fontSize;

@end

//
//  EMINavigationController.h
//  taojin
//
//  Created by machinsight on 17/3/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"
//#import "MaterialAppBar.h"
#import "UIBarButtonItem+Extension.h"
#import "EMIBaseViewController.h"

@interface EMINavigationController : UINavigationController

/**
 * 默认导航条
 * (barHeight)默认导航条高度69pt
 * barTitle 的Alignment默认为 MDCNavigationBarTitleAlignmentCenter
 */
+ (void)addAppBar:(EMIBaseViewController *)VC;

/**
 * 自定义导航条
 * (barHeight)默认导航条高度69pt
 * barTitle 的Alignment默认为 MDCNavigationBarTitleAlignmentCenter
 * @param VC 控制器
 * @param color 自定义导航下划线颜色
 */
+ (void)addAppBar:(EMIBaseViewController *)VC shadowColor:(UIColor *)color;

/**
 * 自定义导航条
 * barTitle 的Alignment默认为 MDCNavigationBarTitleAlignmentCenter
 * @param VC 控制器
 * @param barHeight bar的高度
 * @param color 自定义导航下划线颜色
 */
+ (void)addAppBar:(EMIBaseViewController *)VC barHeight:(CGFloat)barHeight shadowColor:(UIColor *)color;

/**
 * 自定义导航条 
 * (barHeight)默认导航条高度69pt
 * @param VC 控制器
 * @param titleAlignment bar中title的Alignment
 * @param color 自定义导航下划线颜色
 */
+ (void)addAppBar:(EMIBaseViewController *)VC barTitleAlignment:(MDCNavigationBarTitleAlignment)titleAlignment shadowColor:(UIColor *)color;

/**
 * 自定义导航条
 * @param VC 控制器
 * @param barHeight bar的高度
 * @param titleAlignment bar中title的Alignment
 * @param color 自定义导航下划线颜色
 */
+ (void)addAppBar:(EMIBaseViewController *)VC barHeight:(CGFloat)barHeight barTitleAlignment:(MDCNavigationBarTitleAlignment)titleAlignment shadowColor:(UIColor *)color;

/**
 app_bar 的navigationbar加阴影
 
 @param offset 偏移量
 @param radius 圆角
 @param color 颜色
 @param opacity 透明度
 */
+ (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity
                     aimView:(UIView *)aimView;

@end

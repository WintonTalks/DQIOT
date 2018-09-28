//
//  BJNoDataView.h
//  BJNoDataDemo
//
//  Created by zbj-mac on 16/3/25.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^iconClicked) ();
@interface BJNoDataView : UIView
#pragma mark----根据需求选择创建方式----
/**
 *  创建单例(全局实例一个对象)
 *
 *  @return BJNoDataView
 */
+(BJNoDataView*)shareNoDataView;
/**
 *  创建实例(全局可以实例多个对象)
 *
 *  @return BJNoDataView
 */
+(instancetype)noDataView;


#pragma mark----Method-----
/**
 *  展示在父视图的中心
 *
 *  @param aview 父视图
 *  @param icon  图片（默认no_data）
 */
-(void)showCenterWithSuperView:(UIView*)aview icon:(NSString*)icon;

/**
 *  展示
 *
 *  @param aview 父视图
 *  @param frame 在父视图中的frame
 *  @param icon  图片（默认no_data）
 */
-(void)showWithSuper:(UIView*)aview Frame:(CGRect)frame icon:(NSString*)icon;

/**
 *  展示在父视图的中心
 *
 *  @param aview       父视图
 *  @param icon        图片（默认no_data）
 *  @param iconClicked 图片点击回调
 *  @param text        文字
 */
-(void)showCenterWithSuperView:(UIView *)aview icon:(NSString *)icon Frame:(CGRect)frame iconClicked:(iconClicked)iconClicked WithText:(NSString *)text;

/**
 *  展示
 *
 *  @param aview       父视图
 *  @param frame       在父视图中的frame
 *  @param icon        图片（默认no_data）
 *  @param iconClicked 图片点击回调
 */
-(void)showWithSuper:(UIView*)aview Frame:(CGRect)frame icon:(NSString*)icon iconClicked:(iconClicked)iconClicked;

/**
 *  清除视图（推荐）
 */
-(void)clear;
/**
 *  彻底清除占位图
 */
-(void)wipeOut;

/**
 给label赋值

 @param str <#str description#>
 */
- (void)setLabText:(NSString *)str;
@end

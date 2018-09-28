//
//  BRStringPickerView.h
//  BRPickerViewDemo
//
//  Created by 孙文强 on 2017/9/6.
//  Copyright © 2017年 Happy Day. All rights reserved.
//

#import "BasePopUpView.h"

typedef void(^BRStringResultBlock)(id selectValue);

@interface BRStringPickerView : BasePopUpView

/**
 *  显示自定义字符串选择器
 *
 *  @param title            标题
 *  @param dataSource       数组数据源
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(NSArray *)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                      resultBlock:(BRStringResultBlock)resultBlock;

/**
 *  显示自定义字符串选择器
 *
 *  @param title            标题
 *  @param plistName        plist文件名
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                        plistName:(NSString *)plistName
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                      resultBlock:(BRStringResultBlock)resultBlock;

@end

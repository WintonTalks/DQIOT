//
//  BRDatePickerView.h
//  PickerDemo
//
//  Created by 孙文强 on 2017/9/6.
//  Copyright © 2017年 Happy Day. All rights reserved.
//

#import "BasePopUpView.h"

typedef void(^BRDateResultBlock)(NSString *selectValue);

@interface BRDatePickerView : BasePopUpView
/**
 *  显示时间选择器
 *
 *  @param title            标题
 *  @param type             类型（时间、日期、日期和时间、倒计时）
 *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
 *  @param minDateStr       最小时间（如：2015-08-28 00:00:00），可为空
 *  @param maxDateStr       最大时间（如：2018-05-05 00:00:00），可为空
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title dateType:(UIDatePickerMode)type defaultSelValue:(NSString *)defaultSelValue minDateStr:(NSString *)minDateStr maxDateStr:(NSString *)maxDateStr isAutoSelect:(BOOL)isAutoSelect resultBlock:(BRDateResultBlock)resultBlock;

+ (void)hidePickerView;

@end

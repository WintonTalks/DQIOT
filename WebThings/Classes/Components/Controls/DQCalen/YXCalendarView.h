//
//  YXCalendarView.h
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXMonthView.h"

typedef void(^RefreshH)(CGFloat viewH);

@interface YXCalendarView : UIView

@property (nonatomic, copy) SendSelectDate sendSelectDate;  //回传选择日期

/**
 实现该block滑动时更新控件高度
 */
@property (nonatomic, copy) RefreshH refreshH;

/**
 根据日期获取控件总高度
 
 @param date 日期
 @param type 类型
 @return return value description
 */
+ (CGFloat)getMonthTotalHeight:(NSDate *)date type:(CalendarType)type;

/**
 初始化方法
 
 @param frame 控件尺寸,高度可以调用该类计算方法计算
 @param date 日期
 @param type 类型
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame Date:(NSDate *)date Type:(CalendarType)type;

@end

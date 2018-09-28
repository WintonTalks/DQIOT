//
//  YXMonthView.h
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXDayCell.h"

typedef void(^SendSelectDate)(NSDate *selDate);

@interface YXMonthView : UIView

@property (nonatomic, strong) NSDate *currentDate;          //当前月份
@property (nonatomic, strong) NSDate *selectDate;           //选中日期
@property (nonatomic, copy) SendSelectDate sendSelectDate;  //回传选中日期
@property (nonatomic, assign) CalendarType type;            //日历模式
@property (nonatomic, strong) NSArray *eventArray;          //事件数组

- (instancetype)initWithFrame:(CGRect)frame Date:(NSDate *)date;

@end

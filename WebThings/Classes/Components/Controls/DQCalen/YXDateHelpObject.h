//
//  YXDateHelpObject.h
//  LaiApp_OC
//
//  Created by Jonas on 16/11/15.
//  Copyright © 2016年 Softtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDateHelpObject : NSObject

+ (YXDateHelpObject *)manager;

/**
 获取当前日期所在周最后一天(日-六 也就是周六)

 @param date 当前日期
 @return 返回日期
 */
- (NSDate *)getLastdayOfTheWeek:(NSDate *)date;

/**
 获取当天是周几

 @param date 当天日期
 @return 周数(1-7  ->  日-六)
 */
- (NSInteger)getNumberInWeek:(NSDate *)date;

/**
 返回传入时间月份第一天

 @param pDate 传入时间
 @return 第一天
 */
- (NSDate *)GetFirstDayOfMonth:(NSDate *)pDate;

/**
 * 时间返回字符串
 */
- (NSString *)getStrFromDateFormat:(NSString *)format Date:(NSDate *)date;

/**
 * 获取上个月的时间
 */
- (NSDate*)getPreviousMonth:(NSDate*)_date;

/**
 * 获取下一个月的时间
 */
- (NSDate*)getNextMonth:(NSDate*)_date;

/**
 * 获取本月第一天是星期几
 */
- (NSInteger)currentFirstDay:(NSDate *)date;

/**
 * 获取本月总天数
 */
- (NSInteger)currentMonthOfDay:(NSDate *)date;

/**
 * 判断两个月份是不是一样的
 */
- (BOOL)checkSameMonth:(NSDate*)_month1 AnotherMonth:(NSDate*)_month2;

/**
 * 获取一个月有多少行
 */
- (NSInteger)getRows:(NSDate *)myDate;

/**
 * 字符串返回时间
 */
- (NSDate *)getDataFromStrFormat:(NSString *)format String:(NSString *)str;

/**
 * 判断两天是不是同一天 //固定yyyy-mm-dd
 */
- (BOOL)checkSameDate:(NSString *)date1 AnotherDate:(NSDate *)date2;

/**
 * 判断两天是不是同一天
 */
- (BOOL)isSameDate:(NSDate *)date1 AnotherDate:(NSDate *)date2;

/**
 * 获取某天零点时间
 */
- (NSDate *)getStartDateWithDate:(NSDate *)date;

/**
 将时间字符串转换成新的时间字符串
 
 @param oldStrDate 旧的时间
 @param oldFormat 旧的格式
 @param newFormat 新的时间格式
 @return 返回
 */
- (NSString *)getStrDateFromStrDate:(NSString *)oldStrDate OldFormat:(NSString *)oldFormat ByNewFormat:(NSString *)newFormat;


/**
 获取某个时间前后时间

 @param currentDate 当前时间
 @param lead 距离时间 正数往后推  负数往前推
 @param timeType 时间类型(0-年  1-月 2-日 3-时 4-分 5-秒)
 @return 返回结果时间
 */
- (NSDate *)getEarlyOrLaterDate:(NSDate *)currentDate LeadTime:(NSInteger)lead Type:(NSInteger)timeType;



@end

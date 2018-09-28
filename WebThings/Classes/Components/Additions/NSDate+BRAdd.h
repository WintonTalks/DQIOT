//
//  NSDate+BRAdd.h
//  SHDoctor
//
//  Created by Mac mini on 15/10/21.
//  Copyright © 2015年 ECM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BRAdd)
//获取年月日
+ (NSInteger)year;
+ (NSInteger)month;
+ (NSInteger)day;

/**
 date转string
 */
+ (NSString *)dateForString:(NSDate *)anotherDay  format:(NSString *)formatterStr;

/**
 string转date
 */
+ (NSDate *)stringForDate:(NSString *)anotherString  format:(NSString *)formatterStr;

/** 获取当前的时间 */
+ (NSString *)currentDateString;

/**
 比较两个时间大小
 */
+ (int)compareOneDay:(NSString *)oneDay
      withAnotherDay:(NSString *)anotherDay
              format:(NSString *)formatterStr;

/**
 传入今天的时间，返回明天的时间/昨天时间
 */
+ (NSString *)getTomorrowDay:(NSString *)toDay withTomorrow:(BOOL)isTomorrow;

/** 根据日期字符串获取星期
 * 字符串的DateFormatter 必须为 @"yyyy/MM/dd"
 */
+ (NSString *)getWeekDay:(NSString*)dateString;

/**
 验证处理后台给到的时间字符串，防止崩溃

 @param time time
 @return string
 */
+ (NSString *)verifyDateForYMD:(NSString *)time;

/**
 把原有的日期字符串和format 改成指定的format
 */
+ (NSString *)getPointerTimeStringWithFormat:(NSString *)format originString:(NSString *)originStr orignFormat:(NSString *)originFormat;


@end

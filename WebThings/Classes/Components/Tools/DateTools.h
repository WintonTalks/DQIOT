//
//  DateTools.h
//  AnotherAudit
//
//  Created by machinsight on 17/2/17.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTools : NSObject
+(NSString *)caculateWeek:(NSString *)dateString;

+(NSString *)dateToString:(NSDate *) date;

+(NSString *)dateTimeToString:(NSDate *) date;


+(NSDate *)stringToDate:(NSString *)dateString;
+(NSDate *)stringToDateTime:(NSString *)dateString;


//返回前后十年的年份数组
+(NSMutableArray *)tenyearsFromNow;

//返回月份数组
+(NSMutableArray *)monthMax;

//返回最大天数数组
+(NSMutableArray *)dayMax;

//返回月份中的天数数组
+(NSMutableArray *)dayInMonth:(NSString *)month year:(NSString *)year;

//返回指定格式时间
+(NSString *)dateTopointedString:(NSDate *) date format:(NSString *)format;

/**
 *  计算两个日期之间间隔的天数
 *
 *  @param start 开始时间
 *  @param end       结束时间
 *
 *  
 */
+(NSInteger)daysBetween:(NSDate *)start and:(NSDate *)end;

/**
 *  获取指定日期之后几天的日期
 *
 *  @param nowDate  指定日期
 *  @param afterday 之后几天
 *
 *  @return 计算后的日期
 */
+ (NSDate *)dateAfterPointDate:(NSDate *)nowDate afterday:(NSInteger)afterday;

//根据源字符串和指定格式获取到处理后的字符串
+ (NSString *)getpointerTimeStrWithFormat:(NSString *)format WithOriginStr:(NSString *)originStr WithOrignFormat:(NSString *)originFormat;

+ (BOOL)date:(NSDate *)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate *)endDate;


+(NSDictionary *)pointedTimeDicWithCount:(int)index;


/**
 获取当前时间，字符串格式

 @return <#return value description#>
 */
+ (NSString *)currentDateString;


@end

//
//  NSDate+BRAdd.m


#import "NSDate+BRAdd.h"

@implementation NSDate (BRAdd)

+ (NSInteger)year
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

+ (NSInteger)month
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

+ (NSInteger)day
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

+ (NSString *)verifyDateForYMD:(NSString *)time
{
    NSDate *date = nil;
    date = [NSDate stringForDate:time format:@"yyyy/MM/dd hh:mm"];
    if (!date) {
        date = [NSDate stringForDate:time format:@"yyyy/MM/dd hh:mm:ss"];
    }
    if (!date) {
        date = [NSDate stringForDate:time format:@"yyyy/MM/dd"];
    }
    return [NSDate dateForString:date format:@"yyyy/MM/dd"];
}

/**
 date转string
 */
+ (NSString *)dateForString:(NSDate *)anotherDay format:(NSString *)formatterStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = formatterStr;
    return [dateFormatter stringFromDate:anotherDay];
}

/**
 string转date
 */
+ (NSDate *)stringForDate:(NSString *)anotherString  format:(NSString *)formatterStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = formatterStr;
    return [dateFormatter dateFromString:anotherString];
}

#pragma mark - 获取当前的时间
+ (NSString *)currentDateString {
    return [self currentDateStringWithFormat:@"yyyy/MM/dd"];
}

#pragma mark - 按指定格式获取当前的时间
+ (NSString *)currentDateStringWithFormat:(NSString *)formatterStr {
    // 获取系统当前时间
    NSDate *currentDate = [NSDate date];
    // 用于格式化NSDate对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置格式：yyyy-MM-dd HH:mm:ss
    formatter.dateFormat = formatterStr;
    // 将 NSDate 按 formatter格式 转成 NSString
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    // 输出currentDateStr
    return currentDateStr;
}

+ (int)compareOneDay:(NSString *)oneDay
      withAnotherDay:(NSString *)anotherDay
              format:(NSString *)formatterStr
{
    int c = 0;
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    [matter setDateFormat:formatterStr];
    NSDate *preDate = [matter dateFromString:oneDay];
    NSDate *linkDate = [matter dateFromString:anotherDay];
    NSComparisonResult result = [preDate compare:linkDate];
    switch (result) {
        case NSOrderedAscending: ///<
            c = -1;
            break;
        case NSOrderedDescending: // >
            c = 1;
            break;
        case NSOrderedSame: //=
            c = 0;
            break;
        default:
            break;
    }
    return c;
}

//根据date字符串获取星期
+ (NSString *)getWeekDay:(NSString*)dateString {
    
    NSString *verDateString = [self verifyDateForYMD:dateString];
    NSDate *date = [NSDate stringForDate:verDateString format:@"yyyy/MM/dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    NSString *week = @"";
    switch (comps.weekday) {
        case 2:
            week = @"星期一";
            break;
        case 3:
            week = @"星期二";
            break;
        case 4:
            week = @"星期三";
            break;
        case 5:
            week = @"星期四";
            break;
        case 6:
            week = @"星期五";
            break;
        case 7:
            week = @"星期六";
            break;
            break;
        default:
            week = @"星期日";
            break;
    }
    return week;
}


/**
 传入今天的时间，返回明天的时间/昨天时间
 
 @param toDay 时间字符串
 @param isTomorrow bool
 @return true:明天的时间  false : 昨天时间
 */
+ (NSString *)getTomorrowDay:(NSString *)toDay withTomorrow:(BOOL)isTomorrow
{
    NSDate *aDate = [self stringForDate:toDay format:@"yyyy/MM/dd"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    if (isTomorrow) {
        [components setDay:([components day]+1)];
    } else {
        [components setDay:([components day]-1)];
    }
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy/MM/dd"];
    return [dateday stringFromDate:beginningOfWeek];
}

+ (NSString *)getPointerTimeStringWithFormat:(NSString *)format originString:(NSString *)originStr orignFormat:(NSString *)originFormat {
    if (!originStr) { return nil; }
    NSString *str = @"";
    //是否是带T时间字符串
    if ([originStr rangeOfString:@"T"].location != NSNotFound) {
        NSMutableString *mutableStringWithT = [[NSMutableString alloc] initWithString:originStr];
        [mutableStringWithT replaceCharactersInRange:[mutableStringWithT rangeOfString:@"T"] withString:@" "];
        str = mutableStringWithT;
        mutableStringWithT = nil;
    } else {
        str = originStr;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:originFormat];
    NSDate *date = [formatter dateFromString:str];
    str = nil;
    [formatter setDateFormat:format];
    NSString *finalStr = [formatter stringFromDate:date];
    formatter = nil;
    return finalStr;
}

@end

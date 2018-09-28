//
//  RobotDateTime.m
//  WebThings
//
//  Created by Henry on 2017/8/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotDateTime.h"

@implementation RobotDateTime
+(NSString *)getDate:(NSString *)date time:(NSString *)time{
    if (date&&time&&![date isEqualToString:@""]&&![time isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@ %@",date,time];
    }
    return @"";
}

+(BOOL)checkEmpty:(NSArray *)array{
    if (array) {
        for (int i=0; i<array.count; i++) {
            NSString *str = array[i];
            if ([str isEqualToString:@""]) {
                return false;
            }
        }
        return true;
    }
    return false;
}

+(NSNumber *)strToInt:(NSString *)str{
    int num = [str intValue];
    return [NSNumber numberWithInt:num];
}
@end

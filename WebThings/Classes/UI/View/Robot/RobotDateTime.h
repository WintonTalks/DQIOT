//
//  RobotDateTime.h
//  WebThings
//
//  Created by Henry on 2017/8/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RobotDateTime : NSObject
+(NSString *)getDate:(NSString *)date time:(NSString *)time;

/**
 检测数组中的内容是否为空

 @param array <#array description#>
 @return <#return value description#>
 */
+(BOOL)checkEmpty:(NSArray *)array;

+(NSNumber *)strToInt:(NSString *)str;
@end

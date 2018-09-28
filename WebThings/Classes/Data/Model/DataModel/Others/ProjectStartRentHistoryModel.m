//
//  ProjectStartRentHistoryModel.m
//  WebThings
//
//  Created by machinsight on 2017/8/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ProjectStartRentHistoryModel.h"

@implementation ProjectStartRentHistoryModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

- (NSString *)startdate {
    return [_startdate dq_newTimeStringWithFormat:kString_DateNoTimeFormatter];
}

@end

//
//  DeviceModel.m
//  WebThings
//
//  Created by machinsight on 2017/7/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DeviceModel.h"
#import "NSString+Category.h"

@implementation DeviceModel
/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"warndata" : @"DeviceDataModel",
              @"addhigh" : @"DeviceDataModel"
              };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

// 时间做统一格式处理
- (NSString *)starttime {
    return [_starttime dq_newTimeStringWithFormat:kString_DateFormatter];
}

- (NSString *)cdate {
    return [_cdate dq_newTimeStringWithFormat:kString_DateFormatter];
}

- (NSString *)handdate {
    return [_handdate dq_newTimeStringWithFormat:kString_DateFormatter];
}

- (NSString *)beforehanddate {
    return [_beforehanddate dq_newTimeStringWithFormat:kString_DateFormatter];
}

@end

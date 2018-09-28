//
//  AddProjectModel.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddProjectModel.h"

@implementation AddProjectModel
/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"drivers" : @"DriverModel",
              @"detail" : @"DeviceTypeModel",
              @"projectDevice" : @"DeviceModel",
              @"devices" : @"DeviceTypeModel"
              };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\nprojectname=[%@],devices=[%@]\n,userid=[%ld],no=[%@]",
            _projectname,
            _detail,
            _userid,
            _no];
}

- (NSString *)indate {
    return [_indate dq_newTimeStringWithFormat:kString_DateFormatter];
}

- (NSString *)outdate {
    return [_outdate dq_newTimeStringWithFormat:kString_DateFormatter];
}

- (NSString *)ctime {
    return [_ctime dq_newTimeStringWithFormat:kString_DateFormatter];
}

- (NSString *)utime {
    return [_utime dq_newTimeStringWithFormat:kString_DateFormatter];
}

@end

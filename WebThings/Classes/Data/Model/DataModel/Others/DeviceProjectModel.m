//
//  DeviceProjectModel.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DeviceProjectModel.h"

@implementation DeviceProjectModel
/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"data" : @"DeviceModel"
              };
    
}
@end

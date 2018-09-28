//
//  DeviceMaintainorderModel.m
//  WebThings
//
//  Created by machinsight on 2017/8/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DeviceMaintainorderModel.h"

@implementation DeviceMaintainorderModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID": @"id"};//,@"finishOrder":@"finshorder"
}

//+ (instancetype)mj_objectWithKeyValues:(id)keyValues {
//    return @{@"finshorder":[DQFinishOrderModel class]};
//}

+ (NSDictionary *)objectClassInArray {
    return @{@"evaluates" : [ServiceevaluateModel class],@"workers":[UserModel class]};
}

@end

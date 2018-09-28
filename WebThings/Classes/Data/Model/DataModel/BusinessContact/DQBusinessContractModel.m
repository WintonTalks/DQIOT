//
//  DQBusinessContractModel.m
//  WebThings
//  接口返回的商务往来数据Model
//  Created by Heidi on 2017/10/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQBusinessContractModel.h"

@implementation DQBusinessContractModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"businessID": @"id"};
}

/// 实现该方法，说明数组中存储的模型数据类型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"detail" : [DQBusContDetailModel class]};
}

@end

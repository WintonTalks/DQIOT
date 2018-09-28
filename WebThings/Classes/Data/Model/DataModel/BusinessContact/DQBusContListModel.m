//
//  DQBusContListModel.m
//  WebThings
//  商务往来整改完成单数据Model
//  Created by Heidi on 2017/10/20.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQBusContListModel.h"

@implementation DQBusContListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"busID": @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"workers" : @"UserModel"};
}

@end

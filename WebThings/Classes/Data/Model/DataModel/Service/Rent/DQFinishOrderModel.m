//
//  DQFinishOrderModel.m
//  WebThings
//
//  Created by Eugene on 10/29/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQFinishOrderModel.h"

@implementation DQFinishOrderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"startDate":@"start",
             @"endDate":@"end"};
}

@end

//
//  IVEDataModel.m
//  WebThings
//
//  Created by machinsight on 2017/8/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "IVEDataModel.h"

@implementation IVEDataModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id",
             @"TypeID":@"typeid"};
}
@end

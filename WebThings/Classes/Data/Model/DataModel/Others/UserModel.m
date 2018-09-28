//
//  UserModel.m
//  WebThings
//
//  Created by machinsight on 2017/7/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

- (BOOL)isZuLin {
    if ([_type isEqualToString:@"租赁商"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isCEO {
    if ([_usertype isEqualToString:@"CEO"]) {
        //CEO只能看看，无操作权限
        return YES;
    }
    return NO;
}

@end

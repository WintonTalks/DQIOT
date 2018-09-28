//
//  ServiceNewsModel.m
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceNewsModel.h"

@implementation ServiceNewsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"msgattachmentList" : @"MsgattachmentListModel",
              @"project" : @"AddProjectModel"
              };
    
}
@end

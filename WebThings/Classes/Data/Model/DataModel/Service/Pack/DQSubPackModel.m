//
//  DQSubPackModel.m
//  WebThings
//  设备报装
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQSubPackModel.h"

@implementation DQSubPackModel

/// 实现该方法，说明数组中存储的模型数据类型
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"msgattachmentList" : @"MsgattachmentListModel"};
}

@end

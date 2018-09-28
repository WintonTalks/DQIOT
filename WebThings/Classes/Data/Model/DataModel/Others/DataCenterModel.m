//
//  DataCenterModel.m
//  WebThings
//
//  Created by machinsight on 2017/7/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DataCenterModel.h"

@implementation DataCenterModel
/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"warnlist" : @"WarningModel"
              };

}
@end

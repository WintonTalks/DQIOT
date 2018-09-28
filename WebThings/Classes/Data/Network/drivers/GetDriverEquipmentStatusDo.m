//
//  GetDriverEquipmentStatusDo.m
//  WebThings
//
//  Created by machinsight on 2017/7/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "GetDriverEquipmentStatusDo.h"
#import "DeviceModel.h"

@implementation GetDriverEquipmentStatusDo
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/getDriverEquipmentStatus.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"usertype":param[2]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSArray <DeviceModel *> *ma = [DeviceModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        if (!ma) {
            ma = [NSArray array];
        }
        [arr addObject:ma];
    }
    return arr; 
    
}
@end

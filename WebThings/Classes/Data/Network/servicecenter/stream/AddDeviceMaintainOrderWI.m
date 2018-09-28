//
//  AddDeviceMaintainOrderWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddDeviceMaintainOrderWI.h"

@implementation AddDeviceMaintainOrderWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/addDeviceMaintainOrder.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"projectid":param[2],@"deviceid":param[3],@"sdate":param[4],@"edate":param[5],@"text":param[6],@"usertype":param[7]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
//        [arr addObject:[param objectForKey:@"orderid"]];//维保单id
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"添加成功" actionTitle:@"" duration:3.0];
        [t show];
    }
    return arr;
    
}
@end

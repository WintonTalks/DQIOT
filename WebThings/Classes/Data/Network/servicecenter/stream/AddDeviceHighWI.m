//
//  AddDeviceHighWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddDeviceHighWI.h"

@implementation AddDeviceHighWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/addDeviceHigh.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"usertype":param[2],@"projectid":param[3],@"deviceid":param[4],@"sdate":param[5],@"edate":param[6],@"high":param[7]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
//        [arr addObject:[param objectForKey:@"highid"]];
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"添加成功" actionTitle:@"" duration:3.0];
        [t show];
    }
    return arr;
    
}
@end

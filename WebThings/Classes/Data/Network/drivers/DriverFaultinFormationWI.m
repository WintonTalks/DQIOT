//
//  DriverFaultinFormationWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DriverFaultinFormationWI.h"

@implementation DriverFaultinFormationWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/driverfaultinformation.do");
    }
    return self;
}

- (id)inBox:(id)param{
//    @"managerid":param[3],
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"usertype":param[2],@"warnid":param[4],@"text":param[5],@"projectid":param[6],@"projectdeviceid":param[7],@"deviceid":param[8]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
       
    }
    return arr;
    
}
@end

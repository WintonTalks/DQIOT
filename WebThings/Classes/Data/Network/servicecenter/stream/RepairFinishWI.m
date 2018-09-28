//
//  RepairFinishWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RepairFinishWI.h"

@implementation RepairFinishWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/repairFinish.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"projectid":param[2],@"deviceid":param[3],@"orderid":param[4],@"usertype":param[5]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:3.0];
        [t show];
    }
    return arr;
    
}
@end

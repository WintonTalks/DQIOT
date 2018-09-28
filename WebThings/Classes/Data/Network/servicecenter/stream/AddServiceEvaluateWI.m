//
//  AddServiceEvaluateWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddServiceEvaluateWI.h"

@implementation AddServiceEvaluateWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/addServiceEvaluate.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"projectid":param[2],@"deviceid":param[3],@"star":param[4],@"note":param[5],@"usertype":param[6]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
//        [arr addObject:[param objectForKey:@"evaluateid"]];
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"添加成功" actionTitle:@"" duration:3.0];
        [t show];
    }
    return arr;
    
}
@end

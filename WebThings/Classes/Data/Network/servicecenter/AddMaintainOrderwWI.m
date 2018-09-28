//
//  AddMaintainOrderwWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddMaintainOrderwWI.h"

@implementation AddMaintainOrderwWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/addmaintainorder.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"deviceid":param[2],@"deviceno":param[3],@"installationsite":param[4],@"chargeperson":param[5],@"text":param[6],@"sdate":param[7],@"edate":param[8]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSInteger wxid = [[param objectForKey:@"id"] integerValue];
        [arr addObject:@(wxid)];
    }
    return arr;
    
}
@end

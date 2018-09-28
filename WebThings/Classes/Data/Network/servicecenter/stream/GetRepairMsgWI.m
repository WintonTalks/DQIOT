//
//  GetRepairMsgWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "GetRepairMsgWI.h"
#import "GetMaintainMsgModel.h"

@implementation GetRepairMsgWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/getRepairMsg.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"projectid":param[2],@"deviceid":param[3]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSArray <GetMaintainMsgModel *> *m = [GetMaintainMsgModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        [arr safeAddObject:m];
    }
    return arr;
    
}
@end

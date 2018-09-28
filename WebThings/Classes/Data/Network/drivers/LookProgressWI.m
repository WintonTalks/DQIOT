//
//  LookProgressWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "LookProgressWI.h"
#import "DWMsgModel.h"

@implementation LookProgressWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/getMsgDeviceFlowList.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"usertype":param[2],@"projectid":param[3],@"deviceid":param[4],@"orderid":param[5],@"opttype":param[6]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSArray <DWMsgModel *> *ma = [DWMsgModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        if (!ma) {
            ma = [NSArray array];
        }
        if (ma.count>=1) {
            ma[0].isFirst = YES;
            ma[ma.count-1].isLast = YES;
        }
        [arr addObject:ma];//msg,date
    }
    return arr;
    
}
@end

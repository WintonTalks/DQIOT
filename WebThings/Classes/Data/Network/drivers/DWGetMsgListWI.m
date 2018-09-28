//
//  DWGetMsgListWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//  司机、工人获取消息列表

#import "DWGetMsgListWI.h"
#import "DWMsgModel.h"

@implementation DWGetMsgListWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/getMsgListByUserid.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"usertype":param[2],@"ishistory":param[3]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSArray <DWMsgModel *> *ma = [DWMsgModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        if (!ma) {
            ma = [NSMutableArray array];
        }
        [arr addObject:ma];
    }
    return arr;
    
}
@end

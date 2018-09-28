//
//  NoticeListWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NoticeListWI.h"
#import "DWMsgModel.h"

@implementation NoticeListWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/noticeList.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"usertype":param[2],@"noticetype":param[3],@"ishistory":param[4]};//0不包括，1包括
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSArray <DWMsgModel *> *ma = [DWMsgModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        if (!ma) {
            ma = [NSArray array];
        }
        [arr addObject:ma];
    }
    return arr;
    
}
@end

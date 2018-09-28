//
//  NoticetypeWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//  通知类型

#import "NoticetypeWI.h"
#import "DWMsgModel.h"

@implementation NoticetypeWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/noticetype.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"usertype":param[2]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSArray <DWMsgModel *> *m = [DWMsgModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        if (!m) {
            m = [NSArray array];
        }
        [arr addObject:m];
    }
    return arr;
    
}
@end

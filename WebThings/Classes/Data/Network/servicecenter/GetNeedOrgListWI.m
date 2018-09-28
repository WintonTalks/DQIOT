//
//  GetNeedOrgListWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "GetNeedOrgListWI.h"

@implementation GetNeedOrgListWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/getneedorgList.do");
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
        NSMutableArray *t = [param objectForKey:@"data"];
        NSMutableArray <CK_ID_NameModel *> *ma = [NSMutableArray array];
        for (id item in t) {
            CK_ID_NameModel *m = [[CK_ID_NameModel alloc] init];
            m.cid = [[item objectForKey:@"orgid"] intValue];
            m.cname = [item objectForKey:@"orgname"];
            m.pm = [UserModel mj_objectArrayWithKeyValuesArray:[item objectForKey:@"pm"]];
            [ma addObject:m];
        }
        [arr addObject:ma];
    }
    return arr;
    
}
@end

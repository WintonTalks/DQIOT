//
//  GetVroberreMindWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "GetVroberreMindWI.h"
#import "RemindModel.h"

@implementation GetVroberreMindWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/getVroberremind.do");
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
        NSArray <RemindModel *> *ma = [RemindModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        if (!ma) {
            ma = [NSArray array];
        }
        [arr addObject:ma];
    }
    return arr;
    
}
@end

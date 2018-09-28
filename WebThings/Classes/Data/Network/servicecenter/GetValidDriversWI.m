//
//  GetValidDriversWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/17.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "GetValidDriversWI.h"

@implementation GetValidDriversWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/getValidDrivers.do");
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
        NSArray <UserModel *> *ma = [UserModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        [arr safeAddObject:ma];
    }
    return arr;
    
}
@end

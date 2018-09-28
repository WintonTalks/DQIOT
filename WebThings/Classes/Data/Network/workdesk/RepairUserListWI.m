//
//  RepairUserListWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RepairUserListWI.h"

@implementation RepairUserListWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/repairUserList.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"projectid":param[2],@"usertype":param[3]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSArray <UserModel *> *m = [UserModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        [arr safeAddObject:m];
    }
    return arr;
    
}
@end

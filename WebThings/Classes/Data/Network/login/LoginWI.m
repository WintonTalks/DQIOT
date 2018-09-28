//
//  LoginWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/11.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "LoginWI.h"

@implementation LoginWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/login.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"username":param[0],@"password":param[1]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([[arr safeObjectAtIndex:0] integerValue] == 1) {
        UserModel *m = [UserModel mj_objectWithKeyValues:param];
        [arr safeAddObject:m];
    }
    return arr;
    
}
@end

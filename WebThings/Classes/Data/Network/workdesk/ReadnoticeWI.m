//
//  ReadnoticeWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ReadnoticeWI.h"

@implementation ReadnoticeWI
- (instancetype)init {
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/readnotice.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"usertype":param[2],@"noticeid":param[3]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:3.0];
        [t show];
    }
    return arr;
    
}
@end

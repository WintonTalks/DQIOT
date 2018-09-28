//
//  ObtainNumberWI.m
//  WebThings
//
//  Created by machinsight on 2017/8/19.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ObtainNumberWI.h"

@implementation ObtainNumberWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/obtainnumber.do");
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
        NSInteger num = [[param objectForKey:@"num"] integerValue];
        [arr addObject:@(num)];
    }
    return arr;
    
}
@end

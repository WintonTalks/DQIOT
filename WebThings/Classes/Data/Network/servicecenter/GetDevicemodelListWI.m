//
//  GetDevicemodelListWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "GetDevicemodelListWI.h"

@implementation GetDevicemodelListWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/getdevicemodelList.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"brand":param[2]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSMutableArray *t = [NSMutableArray array];
        for (id item in [param objectForKey:@"data"]) {
            [t addObject:@{@"id":[item objectForKey:@"modelid"]}];
            [t addObject:@{@"name":[item objectForKey:@"model"]}];
        }
        [arr addObject:t];
    }
    return arr;
    
}
@end

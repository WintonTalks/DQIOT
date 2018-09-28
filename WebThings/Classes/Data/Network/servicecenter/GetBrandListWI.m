//
//  GetBrandListWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "GetBrandListWI.h"

@implementation GetBrandListWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/getbrandList.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSMutableArray *t = [NSMutableArray array];
        for (id item in [param objectForKey:@"data"]) {
            [t addObject:@{@"name":[item objectForKey:@"brand"]}];
        }
        [arr addObject:t];
    }
    return arr;
    
}
@end

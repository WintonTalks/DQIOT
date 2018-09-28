//
//  GetdevicewarnListWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "GetdevicewarnListWI.h"
#import "WarningModel.h"

@implementation GetdevicewarnListWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/getdevicewarnList.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"deviceid":param[2]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSArray <WarningModel *> *ma = [WarningModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        [arr safeAddObject:ma];
    }
    return arr;
    
}
@end

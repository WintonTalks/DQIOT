//
//  ConverterWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ConverterWI.h"
#import "ConverterModel.h"

@implementation ConverterWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/converter.do");
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
        ConverterModel *m = [ConverterModel mj_objectWithKeyValues:param];
        [arr safeAddObject:m];
    }
    return arr;
    
}
@end

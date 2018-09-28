//
//  ProphaseCommunicateWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ProphaseCommunicateWI.h"
#import "ProphaseCommunicateModel.h"

@implementation ProphaseCommunicateWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/prophaseCommunicate.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"projectid":param[2],@"deviceid":param[3]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        ProphaseCommunicateModel *m = [ProphaseCommunicateModel mj_objectWithKeyValues:param];
        [arr safeAddObject:m];
    }
    return arr;
    
}
@end

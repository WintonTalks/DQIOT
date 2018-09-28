//
//  GetStartRentDataWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "GetStartRentDataWI.h"
#import "StartRentDataModel.h"

@implementation GetStartRentDataWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"getStartRentData.do");
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
        StartRentDataModel *m = [StartRentDataModel mj_objectWithKeyValues:param];
        [arr safeAddObject:m];
    }
    return arr;
    
}
@end

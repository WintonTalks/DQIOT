//
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "GetWarnMonitorWI.h"
#import "WarningModel.h"
#import "DataCenterModel.h"

@implementation GetWarnMonitorWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/getWarnMonitor.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"deviceid":param[2],@"usertype":param[3]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        DataCenterModel *ma = [DataCenterModel mj_objectWithKeyValues:param];
        [arr addObject:ma];
    }
    return arr;
    
}
@end

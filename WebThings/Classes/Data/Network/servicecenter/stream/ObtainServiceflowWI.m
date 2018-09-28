//
//  ObtainServiceflowWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ObtainServiceflowWI.h"
#import "ServiceCenterBaseModel.h"

@implementation ObtainServiceflowWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/obtainServiceflow.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"usertype":param[2],@"projectid":param[3],@"deviceid":param[4],@"projectdeviceid":param[5]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSArray <ServiceCenterBaseModel *> *ma = [ServiceCenterBaseModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        if (!ma) {
            ma = [NSArray array];
        }
        [arr addObject:ma];
    }
    return arr;
    
}
@end

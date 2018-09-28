//
//  ServiceNewsWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceNewsWI.h"
#import "ServiceCenterBaseModel.h"

@implementation ServiceNewsWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/getServiceMessageFlow.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"projectid":param[2],@"deviceid":param[3],@"flowtype":param[4],@"usertype":param[5],@"projectdeviceid":param[6]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSArray <ServiceCenterBaseModel *> *m = [ServiceCenterBaseModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"list"]];
        if (!m) {
            m = [NSArray array];
        }else{
            if (m.count >= 1) {
                m[m.count-1].isLast = YES;
            }            
            if (m.count >= 2) {
                if (m[m.count-1].enumstateid == 12 || m[m.count-1].enumstateid == 15|| m[m.count-1].enumstateid == 18|| m[m.count-1].enumstateid == 21|| m[m.count-1].enumstateid == 24|| m[m.count-1].enumstateid == 27|| m[m.count-1].enumstateid == 30|| m[m.count-1].enumstateid == 33|| m[m.count-1].enumstateid == 36|| m[m.count-1].enumstateid == 38|| m[m.count-1].enumstateid == 40|| m[m.count-1].enumstateid == 42|| m[m.count-1].enumstateid == 44|| m[m.count-1].enumstateid == 46|| m[m.count-1].enumstateid == 48) {
                    m[m.count-2].isLastSecondSure = YES;
                }
            }
            for (int i = 0; i < m.count; i++) {
                if (m[i].enumstateid == 35) {
                    if (i+1 < m.count && m[i+1].enumstateid == 36) {
                        m[i].isNextSure = YES;
                    }
                }
                if (m[i].enumstateid == 39) {
                    if (i+1 < m.count && m[i+1].enumstateid == 40) {
                        m[i].isNextSure = YES;
                    }
                }
                if (m[i].enumstateid == 43) {
                    if (i+1 < m.count && m[i+1].enumstateid == 44) {
                        m[i].isNextSure = YES;
                    }
                }
                
                if (m[i].enumstateid == 36) {
                    if (i+1 < m.count && m[i+1].enumstateid == 37) {
                        m[i].isNextCommit = YES;
                    }
                }
                if (m[i].enumstateid == 40) {
                    if (i+1 < m.count && m[i+1].enumstateid == 41) {
                        m[i].isNextCommit = YES;
                    }
                }
                if (m[i].enumstateid == 44) {
                    if (i+1 < m.count && m[i+1].enumstateid == 45) {
                        m[i].isNextCommit = YES;
                    }
                }
                
                if (m[i].enumstateid == 37) {
                    if (i+1 < m.count && m[i+1].enumstateid == 35) {
                        m[i].isNextForm = YES;
                    }
                }
                if (m[i].enumstateid == 41) {
                    if (i+1 < m.count && m[i+1].enumstateid == 39) {
                        m[i].isNextForm = YES;
                    }
                }
                if (m[i].enumstateid == 45) {
                    if (i+1 < m.count && m[i+1].enumstateid == 43) {
                        m[i].isNextForm = YES;
                    }
                }
                
            }
            
        }
        [arr addObject:m];
    }
    return arr;
}
@end

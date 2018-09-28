//
//  ProjectListWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/12.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ProjectListWI.h"
#import "AddProjectModel.h"

@implementation ProjectListWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/projectList.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSArray *a = param;
    if (a.count == 4) {
        NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"cdate":param[2],@"usertype":param[3]};
        return dic;
    }else{
        NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"usertype":param[2]};
        return dic;
    }
    
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSArray <AddProjectModel *> *m = [AddProjectModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        if (!m) {
            m = [NSArray array];
        }
        [arr addObject:m];
    }
    return arr;
    
}
@end

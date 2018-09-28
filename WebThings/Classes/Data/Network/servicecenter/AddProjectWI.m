//
//  AddProjectWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddProjectWI.h"
#import "AddProjectModel.h"


@implementation AddProjectWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/addproject.do");
    }
    return self;
}

- (id)inBox:(id)param{
    AddProjectModel *m = param;
    NSDictionary *dic = [m mj_keyValues];
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        NSInteger projectid = [[param objectForKey:@"projectid"] integerValue];
        [arr addObject:@(projectid)];
    }
    return arr;
    
}
@end

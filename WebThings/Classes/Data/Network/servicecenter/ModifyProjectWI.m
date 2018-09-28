//
//  ModifyProjectWI.m
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ModifyProjectWI.h"
#import "AddProjectModel.h"

@implementation ModifyProjectWI
- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/modifyproject.do");
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
    }
    return arr;
    
}
@end

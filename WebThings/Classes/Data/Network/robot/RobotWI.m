//
//  RobotWI.m
//  WebThings
//
//  Created by Henry on 2017/7/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotWI.h"
#import "ChatModel.h"
#import "CheckStringConfig.h"
#import "DeviceModel.h"
#import "DailyModel.h"
@implementation RobotWI

- (instancetype)init{
    self = [super init];
    if (self) {
        self.fullUrl = appendUrl(httpUrl, @"/robot.do");
    }
    return self;
}

- (id)inBox:(id)param{
    NSDictionary *dic = @{@"userid":param[0],@"type":param[1],@"usertype":param[2],@"inputmsg":param[3]};
    return dic;
}

- (id)unBox:(id)param{
    NSMutableArray *arr = [super unBox:param];
    if ([arr[0] integerValue] == 1) {
        ChatModel *m = [ChatModel mj_objectWithKeyValues:param];
//        [arr addObject:m];
        id data = [self getReturnData:m.checktype param:param];
        m.data = data;
        if (!m.data) {
            m.checktype = TYPE_TEXT;
            m.data = m.returnmsg;
            m.returnmsg = nil;
        }
        return m;
    }
    return nil;
}

-(id) getReturnData:(NSString *) type param:(id) param{
    if ([TYPE_REMIND isEqualToString:type]||[TYPE_TEXT isEqualToString:type]) {
        NSString *dataStr = [param objectForKey:@"data"];
        return dataStr;
    }else if([TYPE_LOCK isEqualToString:type]||[TYPE_START_RANT isEqualToString:type]||[TYPE_ADD_HEIGHT isEqualToString:type]||[TYPE_STOP_RANT isEqualToString:type]|[TYPE_REPAIR isEqualToString:type]||[TYPE_MAINTAIN isEqualToString:type]){
        DeviceModel *model = [DeviceModel mj_objectWithKeyValues:[param objectForKey:@"data"]];
        return model;
    }else if([TYPE_PHONE isEqualToString:type]){
        NSArray <UserModel *> *models = [UserModel mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        return models;
    }else if([TYPE_REPORT isEqualToString:type]){
        DailyModel *model = [DailyModel mj_objectWithKeyValues:[param objectForKey:@"data"]];
        return model;
    }else if([TYPE_IVE isEqualToString:type]){
        NSArray <NSString *> *models = [NSString mj_objectArrayWithKeyValuesArray:[param objectForKey:@"data"]];
        return models;
    }
    return nil;
}

@end

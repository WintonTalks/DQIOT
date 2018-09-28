//
//  CheckString.m
//  WebThings
//
//  Created by Henry on 2017/7/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CheckString.h"
#import "UserModel.h"
#import "RobotWI.h"
#import "ChatModel.h"
#import "DailyModel.h"
#import "TestData.h"
#import "CheckStringConfig.h"
@implementation CheckString

+(void)checkValue:(NSString *)message delegate:(id<OnCheckValueDelegate>) delegate{
    UserModel *user = [AppUtils readUser];
    RobotWI *webInterface = [[RobotWI alloc] init];
    NSArray *arr = @[[NSNumber numberWithInteger:user.userid],user.type,user.usertype,message];
    NSDictionary *param = [webInterface inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:webInterface.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        ChatModel *robotBean = [webInterface unBox:returnValue];
        if (delegate) {
            [delegate returnValue:robotBean];
        }
    } WithFailureBlock:^(NSError *error) {
    }];
//    if (delegate) {
//        ChatModel *robotBean = [[ChatModel alloc] init];
//        robotBean.checktype = TYPE_REPAIR;
//        robotBean.data = [CheckString getData:robotBean.checktype];
//        [delegate returnValue:robotBean];
//    }
}

+(id)getData:(NSString *)type{
    if([TYPE_REPORT isEqualToString:type]){
        return [TestData getDailyModel];
    }else if([TYPE_REMIND isEqualToString:type]){
        return @"请提醒我";
    }else if([TYPE_IVE isEqualToString:type]){
        return [TestData getIves];
    }else if([TYPE_START_RANT isEqualToString:type]){
        return [TestData getDeviceModel];
    }else if([TYPE_STOP_RANT isEqualToString:type]){
        return [TestData getDeviceModel];
    }else if([TYPE_ADD_HEIGHT isEqualToString:type]||[TYPE_MAINTAIN isEqualToString:type]||[TYPE_REPAIR isEqualToString:type]){
        return [TestData getDeviceModel];
    }
    return nil;
}


@end

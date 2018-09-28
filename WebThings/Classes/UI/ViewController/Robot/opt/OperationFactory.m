//
//  OperationFactory.m
//  WebThings
//
//  Created by Henry on 2017/7/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "OperationFactory.h"
#import "CheckStringConfig.h"
#import "XiaoWeiOperation.h"
#import "SayOperation.h"
#import "BaiduOperation.h"
#import "UserOperation.h"
#import "LockOperation.h"
#import "IVEOperation.h"
#import "RemindOPT.h"
#import "RemindReturnOPT.h"
#import "ReportOperation.h"
#import "StartRantOperation.h"
#import "StopRantOperation.h"
#import "AddHeightOperation.h"
#import "MaintainOperation.h"
#import "RepairOperation.h"
#import "EmptyOperation.h"
@implementation OperationFactory

+(id <OperationDelegate>)factory:(NSString *)type{
    if ([TYPE_XIAOWEI isEqualToString:type]||[TYPE_TEXT isEqualToString:type]) {
        XiaoWeiOperation *opt = [[XiaoWeiOperation alloc] init];
        return opt;
    }else if([TYPE_SAY isEqualToString:type]){
        SayOperation *opt = [[SayOperation alloc] init];
        return opt;
    }else if([TYPE_BAIDU isEqualToString:type]){
        BaiduOperation *opt = [[BaiduOperation alloc] init];
        return opt;
    }else if([TYPE_PHONE isEqualToString:type]){
        UserOperation *opt = [[UserOperation alloc] init];
        return opt;
    }else if([TYPE_LOCK isEqualToString:type]){
        LockOperation *opt = [[LockOperation alloc] init];
        return opt;
    }else if([TYPE_IVE isEqualToString:type]){
        IVEOperation *opt = [[IVEOperation alloc] init];
        return opt;
    }else if([TYPE_REMIND isEqualToString:type]){
        RemindOPT *opt = [[RemindOPT alloc] init];
        return opt;
    }else if([TYPE_REMIND_RETURN isEqualToString:type]){
        RemindReturnOPT *opt = [[RemindReturnOPT alloc] init];
        return opt;
    }else if([TYPE_REPORT isEqualToString:type]){
        ReportOperation *opt = [[ReportOperation alloc] init];
        return opt;
    }else if([TYPE_START_RANT isEqualToString:type]){
        StartRantOperation *opt = [[StartRantOperation alloc] init];
        return opt;
    }else if([TYPE_STOP_RANT isEqualToString:type]){
        StopRantOperation *opt = [[StopRantOperation alloc] init];
        return opt;
    }else if([TYPE_ADD_HEIGHT isEqualToString:type]){
        AddHeightOperation *opt = [[AddHeightOperation alloc] init];
        return opt;
    }else if([TYPE_MAINTAIN isEqualToString:type]){
        MaintainOperation *opt = [[MaintainOperation alloc] init];
        return opt;
    }else if([TYPE_REPAIR isEqualToString:type]){
        RepairOperation *opt = [[RepairOperation alloc] init];
        return opt;
    }else{
        EmptyOperation *opt = [[EmptyOperation alloc] init];
        return opt;
    }
}
@end

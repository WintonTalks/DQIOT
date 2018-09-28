//
//  WorkDeskOptFactory.m
//  WebThings
//
//  Created by machinsight on 2017/8/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "WorkDeskOptFactory.h"
#import "WorkDeskStrConfig.h"
#import "GZTZOperation.h"
#import "ZL_DDQR_CZ_SBCCOpt.h"
#import "CZ_SBWX_WH_JGOpt.h"
#import "CZ_DDQROpt.h"
#import "ZL_SBCCOpt.h"
#import "ZL_WH_JGYHSOpt.h"
#import "ZL_WXYHSOpt.h"
#import "ZL_WH_WX_JGFinishOpt.h"

@implementation WorkDeskOptFactory
+(id <WorkDeskDelegate>)factory:(DWMsgModel *)model{
    UserModel *u = [AppUtils readUser];
    BOOL iszulin;
    BOOL isceo;
    if ([u.type isEqualToString:@"租赁商"]) {
        iszulin = YES;
    }else{
        iszulin = NO;
    }
    if ([u.usertype isEqualToString:@"CEO"]) {
        isceo = YES;
    }else{
        isceo = NO;
    }
    
    if ([model.noticetype isEqualToString:Notice_GZTZ]) {
        GZTZOperation *opt = [[GZTZOperation alloc] init];
        return opt;
    }else if((iszulin && !isceo && [model.noticetype isEqualToString:Notice_DDQR]) || (!iszulin && [model.noticetype isEqualToString:Notice_SBCC])){
        ZL_DDQR_CZ_SBCCOpt *opt = [[ZL_DDQR_CZ_SBCCOpt alloc] init];
        return opt;
    }else if(!iszulin && ([model.noticetype isEqualToString:Notice_SBWH] || [model.noticetype isEqualToString:Notice_SBWX] || [model.noticetype isEqualToString:Notice_SBJG])){
        CZ_SBWX_WH_JGOpt *opt = [[CZ_SBWX_WH_JGOpt alloc] init];
        return opt;
    }else if(!iszulin && [model.noticetype isEqualToString:Notice_DDQR]){
        CZ_DDQROpt *opt = [[CZ_DDQROpt alloc] init];
        return opt;
    }else if(iszulin && !isceo && [model.noticetype isEqualToString:Notice_SBCC]){
        ZL_SBCCOpt *opt = [[ZL_SBCCOpt alloc] init];
        return opt;
    }else if(iszulin && !isceo && ( ([model.noticetype isEqualToString:Notice_SBWH] && !model.users.count) || ([model.noticetype isEqualToString:Notice_SBJG] && !model.users.count)  )){
        ZL_WH_JGYHSOpt *opt = [[ZL_WH_JGYHSOpt alloc] init];
        return opt;
    }else if(iszulin && !isceo && ([model.noticetype isEqualToString:Notice_SBWX] && !model.users.count)){
        ZL_WXYHSOpt *opt = [[ZL_WXYHSOpt alloc] init];
        return opt;
    }else if(iszulin && !isceo && ( ([model.noticetype isEqualToString:Notice_SBWH] && model.users.count) ||
                         ([model.noticetype isEqualToString:Notice_SBWX] && model.users.count) ||
                         ([model.noticetype isEqualToString:Notice_SBJG] && model.users.count)  )){
        ZL_WH_WX_JGFinishOpt *opt = [[ZL_WH_WX_JGFinishOpt alloc] init];
        return opt;
    }
    return nil;
}
@end

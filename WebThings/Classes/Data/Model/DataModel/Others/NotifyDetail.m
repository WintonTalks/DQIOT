//
//  NotifyDetail.m
//  WebThings
//
//  Created by machinsight on 2017/7/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "NotifyDetail.h"

@implementation NotifyDetail
+ (NotifyDetail *)getModel{
    NotifyDetail *model = [[NotifyDetail alloc] init];
    model.noticeid = 1;
    model.title = @"某某建筑公司";
    model.msg = @"项目名称1";
    model.cdate = @"2017/05/10 12:30";
    return model;
}
@end

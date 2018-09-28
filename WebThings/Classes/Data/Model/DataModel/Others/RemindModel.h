//
//  RemindModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//  日程

#import <Foundation/Foundation.h>
//提醒id:remindid
//提醒日期:date
//提醒消息:msg
//是否完成:isfinish “未完成“、”已完成“
@interface RemindModel : NSObject
@property (nonatomic, assign) NSInteger remindid;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *isfinish;
@end

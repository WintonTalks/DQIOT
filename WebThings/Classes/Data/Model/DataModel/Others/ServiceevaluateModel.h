//
//  ServiceevaluateModel.h
//  WebThings
//
//  Created by machinsight on 2017/8/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//  服务评价

#import <Foundation/Foundation.h>

@interface ServiceevaluateModel : NSObject
@property (nonatomic,strong) NSString *ctime;//": "2017/08/05 17:33:24",
@property (nonatomic,assign) NSInteger cuserid;//": 257,
@property (nonatomic,assign) NSInteger ID;//": 2,
@property (nonatomic,strong) NSString *note;//": "very good",   // 评价具体内容
@property (nonatomic,assign) NSInteger projectdeviceid;//": 11,
@property (nonatomic,assign) NSInteger star;//": 5,
@property (nonatomic,assign) NSInteger state;//": 48    // 运行情况5分制

@property (nonatomic, copy) NSString *projectid;
@property (nonatomic, copy) NSString *deviceid;
/**
 0-项目整体评价
 1-设备评价
 2-某个或某几个工人评价
    workerid有值
 3-加高评价linkid有值
 4-维修评价linkid有值
 5-维护评价linkid有值
 6-人员在项目整体中的整体评价
 7-业务站中的人员评价,不针对某个人,workerid为空,deviceid必传
 */
@property (nonatomic, assign) DQEvaluateType type;
@property (nonatomic, copy) NSString *assess;       // 评论内容
@property (nonatomic, copy) NSString *linkid;
@property (nonatomic, copy) NSString *workerid;
@property (nonatomic, assign) NSInteger pleased;    // 满意/不满意
@property (nonatomic, assign) NSInteger complete;   // 完成质量 5分制
@property (nonatomic, assign) NSInteger skill;      // 技能    5分制
@property (nonatomic, assign) NSInteger service;    // 服务态度 5分制
@property (nonatomic, assign) NSInteger old;        // 设备新旧 5分制
//@property (nonatomic, assign) NSInteger
//@property (nonatomic, assign) NSInteger

/** 拼接参数给接口调用 */
- (NSDictionary *)dq_apiParams;

@end

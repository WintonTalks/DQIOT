//
//  DeviceMaintainorderModel.h
//  WebThings
//
//  Created by machinsight on 2017/8/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//  设备维保单,维修单，加高单，拆除单

#import <Foundation/Foundation.h>
//#import "DQFinishOrderModel.h"

@interface DeviceMaintainorderModel : NSObject
@property (nonatomic, strong) NSString *address;//": "china设备维保单",
@property (nonatomic, strong) NSString *chargeperson;//": "客户项目经理",
@property (nonatomic, assign) NSInteger count;//": 0,
@property (nonatomic, strong) NSString *ctime;//": "2017/08/03 15:20:06",
@property (nonatomic, assign) NSInteger cuserid;//": 256,
@property (nonatomic, assign) NSInteger deviceid;//": 16,
@property (nonatomic, strong) NSString *devicemodel;//": "标准型",
@property (nonatomic, strong) NSString *deviceno;//": "ST0003",
@property (nonatomic, strong) NSString *edate;//": "2017/08/11 03:19:00",
@property (nonatomic, assign) NSInteger ID;//": 15,
@property (nonatomic, strong) NSString *linkdn;//": "18752837508",
@property (nonatomic, assign) NSInteger projectdeviceid;//": 11,
@property (nonatomic, strong) NSString *sdate;//": "2017/08/03 03:19:00",
@property (nonatomic, assign) NSInteger state;//": 37,
@property (nonatomic, strong) NSString *text;//": ""

@property (nonatomic, assign) NSInteger warnid;//": 9
@property (nonatomic, assign) NSInteger high;//": 2,
@property (nonatomic, strong) NSString *cdate;//": "2017/08/03 15:20:06",

@property (nonatomic, strong) NSDictionary *manager;// 负责人
@property (nonatomic, strong) NSArray <UserModel *>*workers;// 工作人员列表

@property (nonatomic, strong) NSDictionary *finshorder;
//@property (nonatomic, strong) NSArray *evaluates;// 评价

@property (nonatomic, strong) NSArray <ServiceevaluateModel *> *evaluates;// 评价

@end

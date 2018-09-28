//
//  DeviceModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceDataModel.h"
//{
//    设备id:deviceid
//    项目设备id:projectdeviceid
//    设备编号:deviceno
//    设备安装地点:installationsite
//    设备阶段:state,子状态
//
//    设备阶段:statedesc
//    租赁价格:price
//    预埋安装时间:beforehanddate
//    设备品牌:brand
//    安装高度:high
//    安装时间:handdate
//    使用时间:starttime
//    warndata：[{
//        "dataid":"告警ID"，
//        “desc":"告警描述"
//    }],
//addhigh:[{
//    "dataid":"加高ID",
//    "desc":"加高多少米"
//}]

//fidstate,大状态
//detailstate
//}]

@interface DeviceModel : NSObject
@property (nonatomic, assign) NSInteger deviceid;
@property (nonatomic, assign) NSInteger projectdeviceid;
@property (nonatomic, strong) NSString *deviceno;
@property (nonatomic, strong) NSString *installationsite;

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString *statedesc;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSString *beforehanddate;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, assign) NSInteger high;
@property (nonatomic, strong) NSString *handdate;
@property (nonatomic, strong) NSString *starttime;
@property (nonatomic, strong) NSArray *warndata;
@property (nonatomic, strong) NSArray *addhigh;

@property (nonatomic, assign) NSInteger projectid;//项目id
@property (nonatomic, assign) NSInteger modelid;//型号id
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *address;//地址


@property (nonatomic, assign) NSInteger fidstate;
@property (nonatomic, assign) NSInteger detailstate;//主流程状态
@property (nonatomic, assign) NSInteger driverstate;//司机状态0，32，33，34

@property (nonatomic, strong) NSString *note;//状态描述
@property (nonatomic, strong) NSString *cdate;//时间
@property (nonatomic, assign) NSInteger orderid;//：单据id
@property (nonatomic, assign) NSInteger opttype;//：操作类型3： 加高、2：维修、1：维保

@property (nonatomic, assign) NSInteger deviceheighten;
@property (nonatomic, assign) NSInteger devicemaintain;
@property (nonatomic, assign) NSInteger devicerepair;
@property (nonatomic, assign) NSInteger driverconfirm;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger installcount;
@property (nonatomic, assign) NSInteger lockid;
@property (nonatomic, assign) NSInteger needorgid;
@property (nonatomic, assign) NSInteger provideorgid;
@property (nonatomic, assign) NSInteger rent;
@property (nonatomic, assign) NSInteger projecthistoryid;
@property (nonatomic, assign) NSInteger isdel;

@property (nonatomic, assign) NSInteger isRobotClicked;//0,1

@property (nonatomic, assign) NSInteger driverrentType;//0可以放开的，1是要移除掉的
@property (nonatomic, strong) NSArray *workers;// 工作人员列表
@property (nonatomic, strong) NSDictionary *manager;// 负责人
@property (nonatomic, strong) NSDictionary *finshorder;// 完成单
@property (nonatomic, strong) NSArray *evaluates;// 评价

@end

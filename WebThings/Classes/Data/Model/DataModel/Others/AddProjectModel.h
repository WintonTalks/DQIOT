//
//  AddProjectModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DriverModel.h"
#import "DeviceTypeModel.h"
#import "DeviceModel.h"
//用户id:userid
//用户类型:type
//项目名称:projectname
//确认单编号:no
//承租方:needorgid
//出租方:provideorgid
//工作地点:projectaddress
//总包单位:contractor
//监理单位:supervisor
//租金:rent
//进出场费:intoutprice
//司机确认类型:drivertype 自己找司机 租赁方司机
//司机drivers:[{
//    司机姓名:name
//    身份证号:idcard
//    联系电话:dn
//    工资类型：（月工资、包干工资）:renttype
//    工资:rent
//    安全教育是否完成:issafeteach
//}]
//预计进场时间:indate
//预计出场时间:outdate
//备注:note
@interface AddProjectModel : NSObject
@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *usertype;
@property (nonatomic, strong) NSString *projectname;
@property (nonatomic, strong) NSString *no;

@property (nonatomic, assign) NSInteger needorgid;
@property (nonatomic, strong) NSString *needorgname;//租订方名字

@property (nonatomic, assign) NSInteger provideorgid;

@property (nonatomic, strong) NSString *projectaddress;
@property (nonatomic, strong) NSString *contractor;
@property (nonatomic, strong) NSString *supervisor;
@property (nonatomic, assign) NSInteger rent;
@property (nonatomic, assign) NSInteger intoutprice;
@property (nonatomic, strong) NSString *drivertype;
@property (nonatomic, strong) NSArray <DriverModel *> *drivers;
@property (nonatomic, strong) NSString *indate;
@property (nonatomic, strong) NSString *outdate;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSArray <DeviceTypeModel *> *detail;//设备列表
@property (nonatomic, assign) NSInteger realrent;//租金

@property (nonatomic, assign) NSInteger devicenum;//设备数量

@property (nonatomic, assign) NSInteger totalprice;//总金额

@property (nonatomic, assign) NSInteger realdriverrent;//司机费用
@property (nonatomic, assign) NSInteger driverrent;//司机费用

@property (nonatomic, assign) NSInteger projectid;//项目id

@property (nonatomic, assign) NSInteger installcount;//已安装数量

@property (nonatomic, assign) NSInteger cuserid;
@property (nonatomic, copy) NSString *dn;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger iscommit;
@property (nonatomic, assign) NSInteger needpm;
@property (nonatomic, strong) NSString *needpmname;
@property (nonatomic, strong) NSString *providename;
@property (nonatomic, strong) NSString *provideorgname;
@property (nonatomic, assign) NSInteger providepm;
@property (nonatomic, strong) NSString *realindate;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, assign) NSInteger uuserid;
@property (nonatomic, strong) NSString *utime;
@property (nonatomic, assign) NSInteger isdel;

@property (nonatomic, strong) DeviceModel *projectDevicehistory;
@property (nonatomic, strong) DeviceModel *projectDevice;


@property (nonatomic, assign) NSInteger pmid;
@property (nonatomic, strong) NSString *pmname;


@property (nonatomic, assign) NSInteger isfinish;//0未完成

// 概览接口新增
@property (nonatomic, strong) NSArray <DeviceTypeModel *> *devices;

@end

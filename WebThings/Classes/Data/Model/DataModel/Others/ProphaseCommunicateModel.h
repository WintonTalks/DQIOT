//
//  ProphaseCommunicateModel.h
//  WebThings
//
//  Created by machinsight on 2017/7/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//  前期沟通单据

#import <Foundation/Foundation.h>
#import "AddProjectModel.h"
#import "DeviceProjectModel.h"

//{
//    用户id:userid
//    用户类型:type
//    项目id:projectid
//    设备id:deviceid
//}
//{
//project:{
//    项目id:projectid
//    项目名称:projectname
//    确认单编号:no
//    承租方:needorgid
//    出租方:provideorgid
//    工作地点:projectaddress
//    总包单位:contractor
//    监理单位:supervisor
//    租金:rent
//    进出场费:intoutprice
//    司机确认类型:drivertype
//    司机drivers:[{
//        司机姓名:name
//        身份证号:idcard
//        联系电话:dn
//        工资类型：（月工资、包干工资）renttype
//        工资:rent
//        安全教育是否完成:issafeteach
//    }]
//    预计进场时间:indate
//    预计出场时间:outdate
//    备注:note
//}
//devices:[{
//    项目id:projectid
//    设备id:我觉得不需要
//    用户类型：我觉得不需要
//    设备品牌：brand
//    设备型号：model
//    设备数量：devicecount
//    预埋安装时间：beforehanddate
//    安装高度：high
//    安装时间:handdate
//    安装地点:address
//    使用时间:starttime
//}]
//    人员:{cuser:
//        人员id:userid
//        人员名称:name
//        人员职务:usertype
//        人员头像地址:headimg
//        日期:cdate
//    }
//    isshowbutton:显示确认驳回按钮 0不显示 1显示}




@interface ProphaseCommunicateModel : NSObject
@property (nonatomic, strong) AddProjectModel *project;
@property (nonatomic, strong) NSArray <DeviceProjectModel *> *devices;
@property (nonatomic, strong) DeviceProjectModel *cuser;
@property (nonatomic, assign) NSInteger isshowbutton;
@end

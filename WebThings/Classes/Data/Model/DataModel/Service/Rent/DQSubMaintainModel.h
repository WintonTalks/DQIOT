//
//  DQSubMaintainModel.h
//  WebThings
//  设备维保
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQSubMaintainModel_h
#define DQSubMaintainModel_h
#import "DQEnum.h"

#import "DQServiceSubNodeModel.h"
#import "ServiceevaluateModel.h"

@class DeviceMaintainorderModel;

@interface DQSubMaintainModel : DQServiceSubNodeModel

@property (nonatomic, strong) ServiceevaluateModel *serviceevaluate; // 服务评价
@property (nonatomic, strong) ProjectStartRentHistoryModel *projectstartrenthistory; // 设备启租单
@property (nonatomic, strong) DeviceMaintainorderModel *deviceMaintainorder; // 设备维保单
@property (nonatomic, strong) DeviceMaintainorderModel *devicerepairorder; // 设备维修单
@property (nonatomic, strong) DeviceMaintainorderModel *deivieaddheight; // 设备加高单

@end
/**维保单
 @"设备编号":model.deviceMaintainorder.deviceno
 @"安装地点":model.deviceaddress
 @"项目负责人":model.deviceMaintainorder.chargeperson
 @"联系电话":model.deviceMaintainorder.linkdn
 @"开始维保日期":[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.deviceMaintainorder.sdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]
 @"结束维保日期":[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.deviceMaintainorder.edate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]
 */

/** 维修单
 @"设备编号":model.devicerepairorder.deviceno
 @"安装地点":model.deviceaddress
 @"项目负责人":model.devicerepairorder.chargeperson
 @"联系电话":model.devicerepairorder.linkdn
 @"开始维修日期":[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.devicerepairorder.sdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]
 @"结束维修日期":[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.devicerepairorder.edate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]
 @"维修内容":model.devicerepairorder.text
 */

/** 加高单
 @"设备编号":model.deivieaddheight.deviceno
 @"安装地点":model.deviceaddress
 @"项目负责人":model.deivieaddheight.chargeperson
 @"联系电话":model.deivieaddheight.linkdn
 @"开始加高日期":[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.deivieaddheight.sdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]
 @"结束加高日期":[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.deivieaddheight.edate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]
 @"加高高度":[NSString stringWithFormat:@"%ld米",model.deivieaddheight.high]
 */

#endif /* DQSubMaintainModel_h */

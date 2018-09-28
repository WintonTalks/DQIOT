//
//  DQSubRentModel.h
//  WebThings
//  设备启租
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQSubRentModel_h
#define DQSubRentModel_h
#import "DQEnum.h"

#import "DQServiceSubNodeModel.h"

@class DeviceMaintainorderModel;
@class ProjectStartRentHistoryModel;

@interface DQSubRentModel : DQServiceSubNodeModel

@property (nonatomic, strong) ProjectStartRentHistoryModel *projectstartrenthistory;//设备启租单
@property (nonatomic, strong) DeviceMaintainorderModel *devicerepairorder;          //设备维修单
@property (nonatomic, strong) DeviceMaintainorderModel *deivieaddheight;            //设备加高单
@property (nonatomic, strong) DeviceMaintainorderModel *dismantledevice;            //设备拆除单

@end

#endif /* DQSubRentModel_h */

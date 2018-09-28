//
//  DQSubFixModel.h
//  WebThings
//  设备维修
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQSubFixModel_h
#define DQSubFixModel_h
#import "DQEnum.h"

#import "DQServiceSubNodeModel.h"

@class DeviceMaintainorderModel;

@interface DQSubFixModel : DQServiceSubNodeModel

@property (nonatomic, strong) ProjectStartRentHistoryModel *projectstartrenthistory;//设备启租单
@property (nonatomic, strong) DeviceMaintainorderModel *devicerepairorder;          //设备维修单

@end

#endif /* DQSubFixModel_h */

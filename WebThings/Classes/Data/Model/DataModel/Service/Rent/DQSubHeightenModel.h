//
//  DQSubHeightenModel.h
//  WebThings
//  设备加高
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQSubHeightenModel_h
#define DQSubHeightenModel_h
#import "DQEnum.h"

#import "DQServiceSubNodeModel.h"

@class DeviceMaintainorderModel;

@interface DQSubHeightenModel : DQServiceSubNodeModel

@property (nonatomic, strong) ProjectStartRentHistoryModel *projectstartrenthistory;//设备启租单
@property (nonatomic, strong) DeviceMaintainorderModel *deivieaddheight;            //设备加高单

@end

#endif /* DQSubHeightenModel_h */

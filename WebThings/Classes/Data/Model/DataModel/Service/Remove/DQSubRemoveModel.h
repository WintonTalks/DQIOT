//
//  DQSubRemoveModel.h
//  WebThings
//  设备拆除
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQSubRemoveModel_h
#define DQSubRemoveModel_h
#import "DQEnum.h"

#import "DQServiceSubNodeModel.h"

@class DeviceMaintainorderModel;
@class PriceListModel;

@interface DQSubRemoveModel : DQServiceSubNodeModel

@property (nonatomic, strong) PriceListModel *pricelist;    //费用
@property (nonatomic, strong) DeviceMaintainorderModel *dismantledevice;//设备拆除单

@end

#endif /* DQSubRemoveModel_h */

//
//  DQDeviceDetailViewController.h
//  WebThings
//  设备详情
//  Created by machinsight on 2017/7/6.
//  Copyright © 2017年 machinsight. All rights reserved.
//

@class AddProjectModel;
@class DeviceTypeModel;

@interface DQDeviceDetailViewController : EMIBaseViewController

@property(nonatomic, strong) DeviceTypeModel *device;
@property(nonatomic, strong) AddProjectModel *project;

@end

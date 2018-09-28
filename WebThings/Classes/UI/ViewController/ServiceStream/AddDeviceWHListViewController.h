//
//  AddDeviceWHListViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//  新增设备维保单

#import "EMIBaseViewController.h"
#import "DeviceModel.h"

@interface AddDeviceWHListViewController : EMIBaseViewController
{
    NSString *_minDate;
    NSString *_maxDate;
}

@property (nonatomic, strong) DeviceModel *dm;
@property (nonatomic, assign) NSInteger projectid;

@end

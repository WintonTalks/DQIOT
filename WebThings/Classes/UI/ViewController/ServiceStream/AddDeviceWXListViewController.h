//
//  AddDeviceWXListViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "DeviceModel.h"

@interface AddDeviceWXListViewController : EMIBaseViewController
@property (nonatomic, strong) DeviceModel *dm;
@property (nonatomic, assign) NSInteger projectid;

@property (nonatomic, assign) NSInteger deviceid;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *brand_model;

@property (nonatomic, strong) NSString *warnname;
@property (nonatomic, assign) NSInteger warnid;
@end

//
//  ServiceStreamViewController.h
//  WebThings
//
//  Created by machinsight on 2017/6/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "DeviceModel.h"
#import "AddProjectModel.h"

@interface ServiceStreamViewController : EMIBaseViewController
@property (nonatomic, assign) NSInteger projectid;
@property (nonatomic, strong) NSString *drivertype;
@property (nonatomic, strong) AddProjectModel *projectModel;
@property (nonatomic, strong) DeviceModel *dm;
@end

//
//  AddDeviceViewController.h
//  WebThings
//
//  Created by machinsight on 2017/6/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "DeviceModel.h"
@class AddDeviceViewController;

@interface AddDeviceViewController : EMIBaseViewController
@property (nonatomic,   copy) void (^AddDeviceSubmitBlock)(NSMutableArray *addList);
@property (nonatomic, strong) NSMutableArray <DeviceModel *> *dataArr;
@property (nonatomic, assign) NSInteger projectid;

@end

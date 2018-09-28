//
//  DriversFindProgressViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/24.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "DeviceModel.h"

@interface DriversFindProgressViewController : EMIBaseViewController
@property (nonatomic, strong) DeviceModel *dm;
@property (nonatomic, assign) NSInteger projectid;
@end

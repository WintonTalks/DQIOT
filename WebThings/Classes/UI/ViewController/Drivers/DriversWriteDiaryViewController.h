//
//  DriversWriteDiaryViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/24.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "DeviceModel.h"

@interface DriversWriteDiaryViewController : EMIBaseViewController
@property (nonatomic, assign) NSInteger projectid;//项目id
@property (nonatomic, strong) NSString *projectname;//项目名称
@property (nonatomic, strong) NSMutableArray <DeviceModel *> *deviceData;
@end

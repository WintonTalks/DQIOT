//
//  DQDeviceSearchViewController.h
//  WebThings
//
//  Created by Eugene on 10/23/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"

@interface DQDeviceSearchViewController : EMIBaseViewController

/** 搜索过滤item的数据源 */
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger projectid;
@property (nonatomic, strong) NSString *drivertype;
@property (nonatomic, strong) AddProjectModel *projectModel;

@end

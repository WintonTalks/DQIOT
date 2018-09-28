//
//  DQProjectManangeController.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"
#import "AddProjectModel.h"

@interface DQProjectManangeController : EMIBaseViewController
@property (nonatomic, assign) NSInteger projectid;
@property (nonatomic, assign) NSInteger iscommit;
@property (nonatomic, strong) NSString *drivertype;
@property (nonatomic, strong) AddProjectModel *projectModel;

@end

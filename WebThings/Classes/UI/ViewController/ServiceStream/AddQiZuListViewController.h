//
//  AddQiZuListViewController.h
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//  新增启租单

#import "EMIBaseViewController.h"
#import "DeviceModel.h"
#import "DQSubRentModel.h"

@interface AddQiZuListViewController : EMIBaseViewController
@property (nonatomic,assign) NSInteger isAdd;//0新增 1修改
@property (nonatomic,strong) DeviceModel *dm;
@property (nonatomic, assign) NSInteger projectid;

@property (nonatomic,strong) DQSubRentModel *portalModel;
@end

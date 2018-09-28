//
//  DQHireFormViewController.h
//  WebThings
//
//  Created by Eugene on 10/23/17.
//  Copyright © 2017 machinsight. All rights reserved.
//  起租单修改、创建、结束页面

#import "EMIBaseViewController.h"
#import "DeviceModel.h"
#import "DQSubRentModel.h"

@interface DQHireFormViewController : EMIBaseViewController

@property (nonatomic, assign) DQEnumState rentFormStyle;/** 单子状态 */
@property (nonatomic, strong) DeviceModel *dm;/** 设备信息 */
@property (nonatomic, assign) NSInteger projectid;/** 项目ID */

/** 获取历史启租单，为了展示和修改 */
@property (nonatomic, strong) DQSubRentModel *portalModel;

@end

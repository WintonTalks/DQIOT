//
//  DQServiceStationDetailController.h
//  WebThings
//  业务站二级页面
//  Created by Heidi on 2017/9/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceStationDetailController_h
#define DQServiceStationDetailController_h

#import "EMIBaseViewController.h"
#import "DQLogicMaintainModel.h"

@class DeviceModel;

@interface DQServiceStationDetailController : EMIBaseViewController
<UITableViewDelegate,UITableViewDataSource,DQLogicServiceDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_mainTable;
    
    NSMutableArray *_foldSections;
}

@property (nonatomic, strong) DeviceModel *device;
@property (nonatomic, assign) NSInteger projectid;
@property (nonatomic, copy) NSString *flowTypeName;

@end

#endif /* DQServiceStationDetailController_h */

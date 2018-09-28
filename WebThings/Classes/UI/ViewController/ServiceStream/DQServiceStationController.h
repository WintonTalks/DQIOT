//
//  DQServiceStationController.h
//  WebThings
//  业务站主页
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceStationController_h
#define DQServiceStationController_h

#import "EMIBaseViewController.h"
#import "DQServiceEvaluateFooterView.h"

@class DeviceModel;
@class AddProjectModel;
@class DQLogicServiceBaseModel;
@class DQServiceNodeModel;
@class DQServiceSubNodeModel;

@interface DQServiceStationController : EMIBaseViewController
<UITableViewDelegate,
UITableViewDataSource,
DQEvaluateFooterDelegate,
DQLogicServiceDelegate>
{
    UIScrollView *_bodyScroll;
    UITableView *_mainTable;
    
    NSMutableArray<DQServiceNodeModel *> *_sectionArray;    
    NSMutableArray<DQLogicServiceBaseModel *> *_stateArray;
    
    NSInteger _openSection;             // 打开的section，-1则为全关闭
    NSInteger _lastSection;             // 上次打开的
    NSInteger _currentStep;             // 进行到哪一步
    
    DQServiceEvaluateFooterView *_evaluteView;  // 服务评价
    BOOL _isNotFirst;                           // 用来记录第一次加载数据，不执行展开动画，否则有崩溃
}

@property (nonatomic, assign) NSInteger projectid;
@property (nonatomic, strong) NSString *drivertype;
@property (nonatomic, strong) AddProjectModel *projectModel;
@property (nonatomic, strong) DeviceModel *dm;

@end

#endif /* DQServiceStationController_h */

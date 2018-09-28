//
//  DWDCSearchController.m
//  WebThings
//  数据中心搜索
//  Created by Heidi on 2017/9/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQDCSearchController.h"

#import "DiaryViewController.h"
#import "DQDeviceDetailViewController.h"
#import "EMINavigationController.h"

#import "DQDataCenterView.h"
#import "MDSnackbar.h"
#import "MDCAppBar.h"

#import "DeviceTypeModel.h"
#import "AddProjectModel.h"

@implementation DQDCSearchController

#pragma mark - Init
/// 初始化View
- (void)initSubviews {
    
    CGRect rect = self.view.frame;
    __weak typeof(DQDCSearchController) *weakSelf = self;
    _dcView = [[DQDataCenterView alloc] initWithFrame:
               CGRectMake(0, 64, rect.size.width, screenHeight - 64)
                                      refreshSelector:nil
               target:self];
    _dcView.reportClick = ^(id result) {
        [MobClick event:@"dc_search_report"];

        [weakSelf pushToReportCtl:result];
    };
    _dcView.deviceClick = ^(id result1, id result2) {
        [MobClick event:@"dc_search_device"];

        [weakSelf pushToDeviceCtl:result1 device:result2];
    };
    [self.view addSubview:_dcView];
        
    _searchBar = [[EMI_MaterialSeachBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
    _searchBar.delegate = self;
    [_searchBar becomeFirstResponder];
    [self.view addSubview:_searchBar];
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DeviceCenterSearchViewController"];
    
    // 隐藏导航条
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"DeviceCenterSearchViewController"];
    [self.navigationController setNavigationBarHidden:NO];
    
}

#pragma mark - Custom
// 跳转到设备报告页
- (void)pushToReportCtl:(DeviceTypeModel *)device {
    NSInteger deviceID = device.deviceid;
    if (deviceID == 0) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请先选择设备" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    DiaryViewController *VC = [DiaryViewController new];
    VC.deviceId = deviceID;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)pushToDeviceCtl:(AddProjectModel *)project device:(DeviceTypeModel *)device {
    DQDeviceDetailViewController *ctl = [[DQDeviceDetailViewController alloc] init];
    ctl.device = device;
    ctl.project = project;
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark - 
/** 点击搜索后调用 */
- (void)EMI_MaterialSeachBarReturnKeyClicked:(NSString *)text {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (AddProjectModel *proj in _dataArray) {
        NSPredicate *preicate = [NSPredicate predicateWithFormat:@"deviceno CONTAINS[c] %@", text];
        // 过滤数据
        NSArray *result = [proj.devices filteredArrayUsingPredicate:preicate];
        if ([result count] > 0) {
            proj.devices = result;
            [array addObject:proj];
        }
    }
    [_dcView handleResultData:array];
}

/** 放弃搜索后调用 */
- (void)EMI_MaterialSeachBarDismissed {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

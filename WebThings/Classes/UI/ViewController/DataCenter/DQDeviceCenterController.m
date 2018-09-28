//
//  DQDeviceCenterController.m
//  WebThings
//  设备中心主页
//  Created by Heidi on 2017/9/6.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQDeviceCenterController.h"

#import "DQDeviceDetailViewController.h"
#import "DiaryViewController.h"
#import "DQDCSearchController.h"

#import "DQDataCenterView.h"

#import "AddProjectModel.h"

@interface DQDeviceCenterController ()
{
    DQDataCenterView *_dcView;
}

@property (nonatomic, strong) UIBarButtonItem *navigationTitle;
@end

@implementation DQDeviceCenterController

#pragma mark - Init
/// 初始化View
- (void)initSubviews
{
    // 导航栏下留下5像素的空白，让导航条给人69的错觉
    UIView *topMarginView = [[UIView alloc] init];
    topMarginView.frame = CGRectMake(0, 64, screenWidth, 5);
    topMarginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topMarginView];
    
    CGRect rect = self.view.frame;
    __weak typeof(DQDeviceCenterController) *weakSelf = self;
    _dcView = [[DQDataCenterView alloc]
               initWithFrame:CGRectMake(0, self.navigationBarHeight+5, rect.size.width, rect.size.height-64-49)
               refreshSelector:@selector(requestProjectList)
               target:self];
    _dcView.reportClick = ^(id result) {
        [MobClick event:@"dc_report"];

        [weakSelf pushToReportCtl:result];
    };
    _dcView.deviceClick = ^(id result1, id result2) {
        [MobClick event:@"dc_device"];

        [weakSelf pushToDeviceCtl:result1 device:result2];
    };
    [self.view addSubview:_dcView];
    
    //[EMINavigationController addAppBar:self barTitleAlignment:MDCNavigationBarTitleAlignmentLeading shadowColor:[UIColor whiteColor]];
}

/// 初始化NavitionItem
- (void)initNavigationItems {
    
    self.navigationItem.leftBarButtonItem = self.navigationTitle;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(navItemClick) image:[UIImage imageNamed:@"business_nav_search_icon"]];
}

#pragma mark - Handle data
/// 请求项目列表
- (void)requestProjectList {
    [[DQBusinessInterface sharedInstance]
     dq_getDataListWithMonth:nil
     success:^(id result) {
         [_dcView endRefresh];

         if ([result isKindOfClass:[NSArray class]]) {
             [_dcView handleResultData:result];
         }
         
     } failture:^(NSError *error) {
         [_dcView endRefresh];
     }];
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

#pragma mark - View life cycle
- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    
    [self initNavigationItems];
    [self initSubviews];
    [self requestProjectList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES];
    [MobClick beginLogPageView:@"DeviceCenter"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"DeviceCenter"];
}

#pragma mark - Button clicks
/// 导航栏右侧搜索按钮
- (void)navItemClick {
    [MobClick event:@"dc_search"];
    
    DQDCSearchController *searchCtl = [[DQDCSearchController alloc] init];
    searchCtl.dataArray = [_dcView dataArray];
    [self.navigationController pushViewController:searchCtl animated:YES];
}

#pragma mark - Getter
- (UIBarButtonItem *)navigationTitle {
    
    if (!_navigationTitle) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
        titleLabel.text = @"设备中心";
        titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:18];
        titleLabel.textColor = [UIColor colorWithHexString:@"#1D1D1D"];
        _navigationTitle = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    }
    return _navigationTitle;
}
@end

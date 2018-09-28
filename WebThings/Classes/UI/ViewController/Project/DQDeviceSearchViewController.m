//
//  DQDeviceSearchViewController.m
//  WebThings
//
//  Created by Eugene on 10/23/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQDeviceSearchViewController.h"
#import "DQServiceStationController.h" // 业务站
#import "DQDeviceListCell.h" // 设备cell
#import "DeviceModel.h" // 设备model

#import "CKAlertContainerView.h"
#import "CKAlertView.h"
#import "ProjectListWI.h"
#import "DeleteProjectWI.h"
#import "AddProjectModel.h"
#import "ObtainNumberWI.h"


#import "EMI_MaterialSeachBar.h"
@interface DQDeviceSearchViewController ()
<UITableViewDelegate,
UITableViewDataSource,
CKAlertViewDelegate,
EMI_MaterialSeachBarDelegate,
EMIBaseViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EMI_MaterialSeachBar *searchBar;
@property (nonatomic, strong) NSMutableArray <DeviceModel *>*resultAry;

@end

@implementation DQDeviceSearchViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSearchView];
        // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DeviceSearchViewController"];
    
        // 隐藏导航条
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"DeviceSearchViewController"];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)initSearchView {
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
}

#pragma make - CKAlertViewDelegate
- (void)ckalert_sureBtnClicked:(CKAlertView *)sender {
    //[self fetchDeleteProject:sender.tag];
}

#pragma mark - EMI_MaterialSeachBarDelegate
/** 点击搜索后调用 */
- (void)EMI_MaterialSeachBarReturnKeyClicked:(NSString *)text {
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"deviceno CONTAINS[c] %@", text];
    //过滤数据
    self.resultAry = [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:preicate]];
    
    [self.tableView reloadData];
}

/** 放弃搜索后调用 */
- (void)EMI_MaterialSeachBarDismissed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _resultAry.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 124;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 16)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DQDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceListIdentifier"];
    if (!cell) {
        cell = [[DQDeviceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeviceListIdentifier"];
    }
    DeviceModel *model = [_resultAry safeObjectAtIndex:indexPath.section];
    [cell configDeviceListWithModel:model];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) { return nil;}
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, screenWidth, 16);
    headerView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    
    return headerView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [MobClick event:@"business_device_service_stream"];
    if (_resultAry[indexPath.section].fidstate == 0) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"设备尚未确认" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    //服务站
    DQServiceStationController *serviceVC = [[DQServiceStationController alloc] init];
    serviceVC.dm = [_resultAry safeObjectAtIndex:[indexPath section]];
    serviceVC.projectModel = _projectModel;
    serviceVC.projectid = _projectid;
    serviceVC.drivertype = _drivertype;
    [self.navigationController pushViewController:serviceVC animated:true];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isZuLin] && ![self isCEO]) {
        return YES;
    }
    return NO;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editAct = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [MobClick event:@"device_modify_project"];
    }];
    
    UITableViewRowAction *deleteAct = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [MobClick event:@"device_delete_project"];
        
        CKAlertContainerView *containerV = [[CKAlertContainerView alloc] init];
        CKAlertView *alv = [[CKAlertView alloc] initWithFrame:CGRectMake(0, 0, 298, 175)];
        alv.delegate = self;
        alv.tag = indexPath.section;
        [alv setTitle:@"删除项目" Content:@"是否确认删除选中的项目？"];
        [containerV addView:alv];
        [containerV show];
    }];
    return @[deleteAct,editAct];
}

#pragma mark - Http
/** 删除设备 */
- (void)fetchDeleteDeviceHttp:(NSInteger)index {
    
}

#pragma mark - Getter
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, screenWidth,screenHeight-66)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (EMI_MaterialSeachBar *)searchBar {
    
    if (!_searchBar) {
        _searchBar = [[EMI_MaterialSeachBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
        _searchBar.delegate = self;
        _searchBar.palceHodlerString = @"请输入设备号";
        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}

@end

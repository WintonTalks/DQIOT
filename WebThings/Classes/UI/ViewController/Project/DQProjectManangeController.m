//
//  DQProjectManangeController.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQProjectManangeController.h"
#import "DQDeviceHeaderMentView.h"
#import "DQDeviceListView.h"
#import "DQUserManageMentView.h"
#import "DQBusinessDealingsView.h"

#import "AddDeviceViewController.h"
#import "EditDeviceViewController.h"
#import "DQServiceStationController.h"
#import "DQAttenRecordController.h"//考勤记录
#import "DQAttendanceController.h" //考勤
#import "DQQualificationRecordController.h"//资质记录
#import "DQAddNewUserController.h"//添加人员
#import "DQDeriveTrainingController.h"//培训
#import "DQTrainingRecodingController.h"//培训记录
#import "DQEvaluationViewController.h"//评价
#import "BRDatePickerView.h"

#import "DQDeviceSearchViewController.h"// 设备搜索
#import "DQPhotoActionSheetManager.h"

@interface DQProjectManangeController ()
<DQDeviceListViewDelegate,
DQUserManageMentViewDelegate,
EMIBaseViewControllerDelegate,
EMI_MaterialSeachBarDelegate,
DQAddNewUserControllerDelegate>
{
    DriverModel *_selectUserModel; //记录当前操作培训、上传、考勤的人员model
}
@property (nonatomic, strong) UIScrollView *infoView;
@property (nonatomic, strong) DQDeviceHeaderMentView *headerMentView;
@property (nonatomic, strong) DQDeviceListView *deviceListView;
@property (nonatomic, strong) DQUserManageMentView *userManageView;
@property (nonatomic, strong) DQBusinessDealingsView *businessView;
/** 搜索栏 */
@property (nonatomic, strong) EMI_MaterialSeachBar *searchBar;
@property (nonatomic, strong) UIBarButtonItem *navigationTitle;

@property (nonatomic, strong) NSMutableArray <DeviceModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray <DeviceModel *> *searchArray;
//选择照片
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;

@end

@implementation DQProjectManangeController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"项目管理";
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initChooseDeviceNavBar];
    [self fetchDeviceList];
    [self fetchGetUserListApi];
    MJWeakSelf;
    _headerMentView = [[DQDeviceHeaderMentView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight + 2, screenWidth, 50)];
    _headerMentView.headerMentBlock = ^(NSInteger index) {
        if (index == 1) {
            weakSelf.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:weakSelf action:@selector(onSearchClicked) image:[UIImage imageNamed:@"top_search"]];
        } else {
            weakSelf.navigationItem.rightBarButtonItem = nil;
        }
        [weakSelf checkMentView:index];
    };
    [self.view addSubview:_headerMentView];
    [self.view addSubview:self.infoView];
    [self.infoView addSubview:self.userManageView];
    [self.infoView addSubview:self.deviceListView];
    [self.infoView addSubview:self.businessView];
    if ([self isZuLin] && ![self isCEO]) {
    } else {
        [self.userManageView addManageDeriveUserButton];
        [self.deviceListView configAdjustmentView];
    }
}

- (void)initChooseDeviceNavBar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popViewController) image:[UIImage imageNamed:@"back"]];
}

- (void)popViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSInteger index = self.infoView.contentOffset.x / screenWidth;
    if (index == 2) {   // 商务往来刷新
        [_businessView reloadData];
    }
}

#pragma mark -
- (void)checkMentView:(NSInteger)index
{
    [self.infoView setContentOffset:CGPointMake(index*screenWidth, 0)];
}

#pragma mark -DQDeviceListViewDelegate
- (void)didSelectedServiceStation:(DQDeviceListView *)deviceView
                        indexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"business_device_service_stream"];
    if (_searchArray[indexPath.section].fidstate == 0) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"设备尚未确认" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    //服务站
    self.pushType = 3;
    DQServiceStationController *serviceVC = [[DQServiceStationController alloc] init];
    serviceVC.dm = [_searchArray safeObjectAtIndex:[indexPath section]];
    serviceVC.projectModel = _projectModel;
    serviceVC.projectid = _projectid;
    serviceVC.drivertype = _drivertype;
    [self.navigationController pushViewController:serviceVC animated:true];
}

#pragma mark- DQUserManageMentViewDelegate
- (void)didManageMentView:(DQUserManageMentView *)mentView
                    index:(NSInteger)index
                     type:(DQUserManageMentViewType)type
                userModel:(DriverModel *)userModel
{
    if (type == KDQUserManageMentViewStyle) {
        switch (index) {
            case 1: {//考勤
                DQAttenRecordController *attenRecordVC = [DQAttenRecordController new];
                attenRecordVC.projectid = self.projectid;
                [self.navigationController pushViewController:attenRecordVC animated:true];
            } break;
            case 2: {//资质
                DQQualificationRecordController *qualifiController = [DQQualificationRecordController new];
                qualifiController.projectID = self.projectid;
                [self.navigationController pushViewController:qualifiController animated:true];
            } break;
            case 3: {//培训记录
                DQTrainingRecodingController *recodingVC = [DQTrainingRecodingController new];
                recodingVC.projectID = self.projectid;
                [self.navigationController pushViewController:recodingVC animated:true];
            } break;
            case 4: {//人员评价
                DQEvaluationViewController *evaluaVC = [[DQEvaluationViewController alloc] init];
                evaluaVC.type = KDQEvaluationPersonStyle;
                evaluaVC.projectID = self.projectid;
                [self.navigationController pushViewController:evaluaVC animated:true];
            } break;
            default:
                break;
        }
    } else {
        _selectUserModel = userModel;
        switch (index) {
            case 1: {//考勤
                DQAttendanceController *attenVC = [DQAttendanceController new];
                attenVC.projectid = self.projectid;
                attenVC.workerid = userModel.workcategoryid;
                [self.navigationController pushViewController:attenVC animated:true];
            } break;
            case 2: {//上传
                [self showWithPreview:true];
            } break;
            case 3: {//培训
                DQDeriveTrainingController *traningVC = [DQDeriveTrainingController new];
                traningVC.name = userModel.name;
                traningVC.projectID = self.projectid;
                traningVC.workerid = userModel.workcategoryid;
                [self.navigationController pushViewController:traningVC animated:true];
            } break;
            case 4: {//评价
                DQEvaluationViewController *evaluaVC = [[DQEvaluationViewController alloc] init];
                evaluaVC.type = KDQEvaluationDeriveStyle;
                evaluaVC.projectID = self.projectid;
                evaluaVC.workerid = userModel.workcategoryid;
                evaluaVC.name = userModel.name;
                [self.navigationController pushViewController:evaluaVC animated:true];
            } break;
            default:
                break;
        }
    }
}

- (void)didSelectedNewDeviceVC:(DQDeviceListView *)deviceView
{
    [MobClick endEvent:@"business_device_new_project"];
    self.pushType = 3;
    MJWeakSelf;
    AddDeviceViewController *deviceListVC = [AddDeviceViewController new];
    deviceListVC.AddDeviceSubmitBlock = ^(NSMutableArray *addList){
        [weakSelf didSubmitDeviceClicked:addList];
    };
    deviceListVC.projectid = _projectid;
    [self.navigationController pushViewController:deviceListVC animated:true];
}

- (void)didEditUserFixClicked:(DQUserManageMentView *)mentView
                    userModel:(DriverModel *)model
{
  //编辑司机信息
    DQAddNewUserController *newUserController = [DQAddNewUserController new];
    newUserController.delegate = self;
    newUserController.type = KDQModifyUserAddNewStyle;
    newUserController.userModel = model;
    newUserController.projectID = self.projectid;
    newUserController.projectname = self.projectModel.projectname;
    [self.navigationController pushViewController:newUserController animated:true];
}

/** 获取设备列表 **/
- (void)didConfigDeviceList
{
    [self fetchDeviceList];
}

//判断是否租订商,CEO只能看看，无操作权限
- (BOOL)didExpandIsCEO
{
    if ([self isZuLin] && ![self isCEO]) {
        return true;
    }
    return false;
}

/** 侧滑编辑或者删除设备 **/
- (void)didSwipeOptaionStyle:(DQDeviceListView *)deviceView
                        type:(DQDeviceListViewType)type
                   indexPath:(NSIndexPath *)indexPath
{
    if (type == KDQDeviceListViewEditStyle) { //编辑
        [MobClick event:@"business_device_edit"];
        DeviceModel *dm = [_searchArray safeObjectAtIndex:indexPath.section];
        EditDeviceViewController *deviceVC = [EditDeviceViewController new];
        deviceVC.dm = dm;
        deviceVC.projectid = self.projectid;
        deviceVC.basedelegate = self;
        deviceVC.fromWho = 1;
        deviceVC.state = dm.detailstate;
        [self.navigationController pushViewController:deviceVC animated:YES];
    } else {//删除设备
        [MobClick event:@"business_device_del"];
        UIAlertAction *infoAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self fetchDeleteDevice:indexPath.section];
        }];
        [infoAction setValue:[UIColor colorWithHexString:COLOR_TITLE_GRAY] forKey:@"titleTextColor"];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [cancelAction setValue:[UIColor colorWithHexString:COLOR_BLUE] forKey:@"titleTextColor"];
        
        NSString *text = @"是否删除设备?";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:text preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:infoAction];
        [alertController addAction:cancelAction];
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:text];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont dq_mediumSystemFontOfSize:16] range:NSMakeRange(0, text.length)];
        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        
        UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topRootViewController.presentedViewController)
        {
            topRootViewController = topRootViewController.presentedViewController;
        }
        [topRootViewController presentViewController:alertController animated:true completion:nil];
    }
}

// 添加人员
- (void)didAddNewUserMentView:(DQUserManageMentView *)mentView
{
    DQAddNewUserController *newUserController = [DQAddNewUserController new];
    newUserController.delegate = self;
    newUserController.type = KDQAddNewUserAddNewStyle;
    newUserController.projectID = self.projectid;
    newUserController.projectname = self.projectModel.projectname;
    [self.navigationController pushViewController:newUserController animated:true];
}

- (BOOL)didUserManageExpandIsCEO
{
    if ([self isZuLin] && ![self isCEO]) {
        return true;
    }
    return false;
}

#pragma mark-DQAddNewUserControllerDelegate
- (void)didConfigUserClicked:(DQAddNewUserController *)newUserVC
{
  //修改人员返回clicked
    [self fetchGetUserListApi];
}

#pragma mark - Private Methods
- (void)onSearchClicked
{
//    [MobClick event:@"business_item_search"];
//
//    if (!_searchBar) {
//        _searchBar = [[EMI_MaterialSeachBar alloc] init];
//        _searchBar.delegate = self;
//    }
//    [_searchBar showWithFatherV:self.appBar.headerViewController.headerView];
    
    DQDeviceSearchViewController *searchView = [[DQDeviceSearchViewController alloc] init];
    searchView.dataArray = self.dataArray;
    searchView.projectModel = _projectModel;
    searchView.projectid = _projectid;
    searchView.drivertype = _drivertype;
    [self.navigationController pushViewController:searchView animated:YES];
}

#pragma EMI_MaterialSeachBarDelegate
- (void)EMI_MaterialSeachBarReturnKeyClicked:(NSString *)text{
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"deviceno CONTAINS[c] %@", text];
    //过滤数据
    self.searchArray= [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:preicate]];
    [self.deviceListView reloadTableView:self.searchArray];
}

/**
 请求设备列表
 */
- (void)fetchDeviceList
{
    [[DQDeviceInterface sharedInstance] dq_getConfigDeviceList:self.projectid success:^(id result) {
        if (result) {
            self.dataArray = result;
            if (_dataArray.count > 0) {
                self.searchArray = self.dataArray;
                [[BJNoDataView shareNoDataView] clear];
                self.deviceListView.mTableView.hidden = false;
                [self.deviceListView reloadTableView:result];
            } else {
                [[BJNoDataView shareNoDataView] showCenterWithSuperView:self.view icon:@"ic_empty02" Frame:CGRectMake(0, 0, screenWidth, screenHeight) iconClicked:^{
                    //图片点击回调
                    [self fetchDeviceList];
                } WithText:@"暂时没有可查询的设备"];
                self.deviceListView.mTableView.hidden = true;
                return;
            }
        }
    } failture:^(NSError *error) {
        [self.deviceListView.mTableView.mj_header endRefreshing];
    }];
}

/**
 设备确认
 */
- (void)fetchConfirm:(NSMutableArray *)deviceIDList
{
//    NSMutableArray *projectdeviceids = [NSMutableArray array];
//    for (DeviceModel *item in _dataArray) {
//        [projectdeviceids safeAddObject:@(item.projectdeviceid)];
//    }
//    if (!projectdeviceids.count) {
//        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"暂无可确认设备" actionTitle:@"" duration:3.0];
//        [t show];
//        return;
//    }
    
    [[DQDeviceInterface sharedInstance] dq_getDeviceFirm:@(_projectid) deviceList:deviceIDList success:^(id result) {
        if (result) {
            //成功
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"设备确认提交成功" actionTitle:@"" duration:3.0];
            [t show];
//            [self fetchDeviceList];
        }
    } failture:^(NSError *error) {
        
    }];
}

/**
 删除项目设备
 */
- (void)fetchDeleteDevice:(NSInteger)index
{
    DeviceModel *tempM = (DeviceModel *)[_dataArray safeObjectAtIndex:index];
    [[DQDeviceInterface sharedInstance] dq_getDeleteProjectDevice:tempM.projectdeviceid success:^(id result) {
        if (result) {
            //成功
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"删除成功" actionTitle:@"" duration:3.0];
            [t show];
            //刷新表格
//            [self.dataArray safeRemoveObjectAtIndex:index];
//            _searchArray = _dataArray;
//            [self.deviceListView reloadTableView:self.dataArray];
            [self fetchDeviceList];
        }
        
    } failture:^(NSError *error) {
        
    }];
}

///人员列表API
- (void)fetchGetUserListApi
{
    [[DQProjectInterface sharedInstance] dq_getUserList:_projectid suc:^(id result) {
        if (result) {
            [self.userManageView configUserListClicked:result];
        }
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark - 资质上传 接口
- (void)showWithPreview:(BOOL)preview
{
    [self.lastSelectPhotos removeAllObjects];
    MJWeakSelf;
    DQPhotoActionSheetManager *manager = [[DQPhotoActionSheetManager alloc] init];
    [manager dq_showPhotoActionSheetWithController:self
                                  showPreviewPhoto:preview
                                 didSelectedImages:^(NSArray<UIImage *> *images) {
                                     
                                     weakSelf.lastSelectPhotos = [NSMutableArray arrayWithArray:images];
                                     
                                     [manager dq_uploadImageApi:^(NSArray <NSString *> *imagesUrl) {
                                         [weakSelf upLoadPhotoImageAPI:imagesUrl];
                                     }];
                                     
                                 }];
}

- (void)upLoadPhotoImageAPI:(NSArray <NSString *> *)images
{
    //   //上传图片
    [[DQProjectInterface sharedInstance] dq_getPersonQualification:self.projectid workerid:_selectUserModel.workerid credentials:images success:^(id result) {
        if (result) {
            [self.userManageView configAlubmPhoto:self.lastSelectPhotos];
        }
    } failture:^(NSError *error) {
    }];
}

#pragma mark -新增设备提交返回, 直接发送给承租商
- (void)didSubmitDeviceClicked:(NSMutableArray *)addList
{ //新增设备提交返回
  //直接发送给承租商
//导航飞机取消
//    [self fetchDeviceList];
//    [self fetchConfirm];
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_queue_t disqueue = dispatch_get_global_queue(0,0);
    dispatch_group_enter(dispatchGroup);
    dispatch_group_async(dispatchGroup, disqueue , ^{
        dispatch_group_leave(dispatchGroup);
        [self fetchDeviceList];
    });
    dispatch_group_enter(dispatchGroup);
    dispatch_group_async(dispatchGroup, disqueue , ^{
        dispatch_group_leave(dispatchGroup);
        [self fetchConfirm:addList];
    });
    dispatch_group_notify(dispatchGroup, disqueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    });
}

- (UIScrollView *)infoView
{
    if (!_infoView) {
        _infoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _headerMentView.bottom, screenWidth, screenHeight-_headerMentView.bottom)];
        _infoView.backgroundColor = [UIColor clearColor];
        _infoView.showsVerticalScrollIndicator = false;
        _infoView.showsHorizontalScrollIndicator = false;
        _infoView.bounces = true;
        _infoView.scrollEnabled = false;
        _infoView.contentSize = CGSizeMake(screenWidth*3, screenHeight-_headerMentView.bottom);
        if (@available(iOS 11.0, *)) {
            _infoView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _infoView.contentInset = UIEdgeInsetsMake(64,0,0,0);
            _infoView.scrollIndicatorInsets = _infoView.contentInset;
        }
    }
    return _infoView;
}

- (DQDeviceListView *)deviceListView
{
    if (!_deviceListView) {
        _deviceListView = [[DQDeviceListView alloc] initWithFrame:CGRectMake(self.infoView.width, 0, self.infoView.width, self.infoView.height-8)];
        _deviceListView.delegate = self;
    }
    return _deviceListView;
}

- (DQUserManageMentView *)userManageView
{
    if (!_userManageView) {
        _userManageView = [[DQUserManageMentView alloc] initWithFrame:CGRectMake(0, 0, self.infoView.width, self.infoView.height - 8)];
        _userManageView.delegate = self;
        _userManageView.projectID = self.projectid;
        _userManageView.projectName = self.projectModel.projectname;
    }
    return _userManageView;
}

- (DQBusinessDealingsView *)businessView
{
    if (!_businessView) {
        _businessView  = [[DQBusinessDealingsView alloc] initWithFrame:CGRectMake(self.infoView.width*2, 0, self.infoView.width, screenHeight-_headerMentView.bottom)];
        _businessView.navCtl = self.navigationController;
        _businessView.projectID = _projectid;

    }
    return _businessView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSMutableArray *)searchArray
{
    if (!_searchArray) {
        _searchArray = [NSMutableArray new];
    }
    return _searchArray;
}

- (NSMutableArray *)lastSelectAssets
{
    if (!_lastSelectAssets) {
        _lastSelectAssets = [NSMutableArray new];
    }
    return _lastSelectAssets;
}

- (NSMutableArray *)lastSelectPhotos
{
    if (!_lastSelectPhotos) {
        _lastSelectPhotos = [NSMutableArray new];
    }
    return _lastSelectPhotos;
}

@end

//
//  DriversNewsViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/24.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DriversNewsViewController.h"
#import "DriversHomeCell.h"
#import "DriversWriteDiaryViewController.h"
#import "DriversFindProgressViewController.h"
#import "DriversBaoGuZViewController.h"
#import "DeviceModel.h"
#import "GetDriverEquipmentStatusDo.h"
#import "GetProjectByDriverrentWI.h"
#import "DeviceModel.h"

@interface DriversNewsViewController (){
    NSInteger projectid;
    NSString *projectname;
    NSMutableArray <DeviceModel *> *deviceData;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *frbBtn;
@property (weak, nonatomic) IBOutlet UIButton *bgzBtn;

@property(nonatomic,strong)NSMutableArray <DeviceModel *> *dataArray;
@end

@implementation DriversNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self initArr];
    [self initView];
    //[EMINavigationController addAppBar:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //KVO
    [self addObserver:self forKeyPath:@"dataArray" options:NSKeyValueObservingOptionNew context:nil];
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    //[self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initArr{
}

- (void)initView{
    CKRefreshHeader *ckh = [CKRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
    _tableView.mj_header = ckh;
    [_tableView.mj_header beginRefreshing];
    
    [self fetchProject];
}
#pragma 下拉刷新
- (void)loadNewData:(CKRefreshHeader *)sender{
    [self fetchList];
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DriversHomeCell *cell = [DriversHomeCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewWithValues:_dataArray[indexPath.section]];
    return cell;
    
}
#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //查进度
    DriversFindProgressViewController *VC = [AppUtils VCFromSB:@"Drivers" vcID:@"DriversFindProgressVC"];
    VC.dm = _dataArray[indexPath.section];
    VC.projectid = projectid;
    [self.navigationController pushViewController:VC animated:YES];
    
    [MobClick event:@"driver_process"];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else{
        return 15;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 122;
    
}

- (IBAction)frbBtnClicked:(id)sender {
    [MobClick event:@"driver_add_diary"];

    DriversWriteDiaryViewController *VC = [AppUtils VCFromSB:@"Drivers" vcID:@"DriversWriteDiaryVC"];
    VC.projectid = projectid;
    VC.projectname = projectname;
    VC.deviceData = deviceData;
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)bgzBtnClicked:(id)sender {
    [MobClick event:@"driver_add_trouble"];
    DriversBaoGuZViewController *VC = [AppUtils VCFromSB:@"Drivers" vcID:@"DriversBaoGuZVC"];
    VC.projectid = projectid;
    VC.projectname = projectname;
    VC.deviceData = deviceData;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark-----KVO回调----
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (![keyPath isEqualToString:@"dataArray"]) {
        return;
    }
    if ([self.dataArray count]==0) {//无数据
        [[BJNoDataView shareNoDataView] showCenterWithSuperView:self.view icon:@"ic_empty04" Frame:CGRectMake(0, 0, screenWidth, screenHeight-206) iconClicked:^{
            //图片点击回调
            //            [self loadData];//刷新数据
            [self fetchList];
        } WithText:@"暂时没有可查询的工作通知"];
        self.tableView.hidden  = YES;
        return;
    }
    //有数据
    [[BJNoDataView shareNoDataView] clear];
    self.tableView.hidden  = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除通知
    //移除KVO
    [self removeObserver:self forKeyPath:@"dataArray"];
}

/**
 刷新数据
 */
- (void)loadData{
    NSMutableArray*mut=[[NSMutableArray alloc] init];
    for (int i=0; i<2; i++) {
        //  [self.dataArray addObject:[NSString stringWithFormat:@"第%d条数据",i]];//不会触发KVO
    }
    self.dataArray=mut;//数组指针改变 触发KVO
    [_tableView reloadData];
}

/**
 请求列表
 */
- (void)fetchList{
    GetDriverEquipmentStatusDo *lwi = [[GetDriverEquipmentStatusDo alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            self.dataArray = temp[1];
            [_tableView reloadData];
        }
        [_tableView.mj_header endRefreshing];
    } WithFailureBlock:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
}


/**
 请求项目，只有一条记录
 */
- (void)fetchProject{
    GetProjectByDriverrentWI *lwi = [[GetProjectByDriverrentWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            projectid = [temp[1] integerValue];
            projectname = temp[2];
            [self fetchDevice];
            
        }
    } WithFailureBlock:^(NSError *error) {
    }];
}

/**
 获取设备
 */
- (void)fetchDevice
{
    [[DQDeviceInterface sharedInstance] dq_getConfigDeviceList:projectid success:^(id result) {
        if (result) {
            deviceData = result;
            for (NSInteger i = deviceData.count -1; i >= 0; i--) {
                DeviceModel *model = [deviceData safeObjectAtIndex:i];
                if (model.driverrentType == 1) {
                     [deviceData safeRemoveObjectAtIndex:i];
                }
            }
        }
    } failture:^(NSError *error) {
        
    }];
    
}


@end

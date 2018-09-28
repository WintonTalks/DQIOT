//
//  WorkNoticeViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "WorkNoticeViewController.h"
#import "DQWorkerNoticeListCell.h" // 工人通知列表

#import "WorkersButtonCell.h"
#import "WorkHistoryNoticeViewController.h"
#import "DWGetMsgListWI.h"
#import "DWMsgModel.h"
#import "ReadnoticeWI.h"
#import "UpdateMsgIsreadByIdWI.h"

static NSString * const cellIdentifier = @"DQWorkerNoticeListCell";

@interface WorkNoticeViewController ()<WorkersButtonCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray<DWMsgModel *> *dataArray;

@end

@implementation WorkNoticeViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知";

    [self initWorkerViewNav];
    [self initWorkerNoticeView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //KVO
    [self addObserver:self forKeyPath:@"dataArray" options:NSKeyValueObservingOptionNew context:nil];
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    //[self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除通知
    //移除KVO
    [self removeObserver:self forKeyPath:@"dataArray"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWorkerViewNav {
    //[EMINavigationController addAppBar:self];
}

- (void)initWorkerNoticeView {
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DQWorkerNoticeListCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    // 刷新
    CKRefreshHeader *ckh = [CKRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
    _tableView.mj_header = ckh;
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - Private Methods
/**
 历史通知
 @param sender sender
 */
- (IBAction)showHistory:(UIButton *)sender {
    
    [MobClick event:@"worker_history_notice"];
    WorkHistoryNoticeViewController *VC = [AppUtils VCFromSB:@"Workers" vcID:@"WorkHistoryNoticeVC"];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 下拉刷新
- (void)loadNewData:(CKRefreshHeader *)sender {
    [self fetchList];
}

#pragma mark - WorkersBTnCellDelegate
- (void)leftBtnClickedWithIndex:(NSInteger)index WithModel:(DWMsgModel *)model {
    [MobClick event:@"worker_read_notice"];
    [self fetchReadWithIndex:index];
}

- (void)rightBtnClickedWithIndex:(NSInteger)index WithModel:(DWMsgModel *)model {
    [self fetchFinishWithIndex:index];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        DQWorkerNoticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.noticeModel = _dataArray[indexPath.section];
        return cell;
    } else {
        WorkersButtonCell *cell = [WorkersButtonCell cellWithTableView:tableView];
        cell.index = indexPath.section;
        [cell setViewValues:_dataArray[indexPath.section]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        if (section == 0) {
            return 0;
        } else {
            return 15;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 125;
    } else {
        return 52;
    }
}

#pragma mark - KVO回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:@"dataArray"]) {
        return;
    }
    if ([self.dataArray count]==0) {//无数据
        [[BJNoDataView shareNoDataView] showCenterWithSuperView:self.view icon:@"ic_empty04" Frame:CGRectMake(0, 0, screenWidth, screenHeight-50) iconClicked:^{
            //图片点击回调
            // [self loadData];//刷新数据
            [self fetchList];
        } WithText:@"暂时没有可查询的工作通知"];
        self.tableView.hidden  = YES;
        return;
    }
    //有数据
    [[BJNoDataView shareNoDataView] clear];
    self.tableView.hidden  = NO;
}

#pragma mark - Http Request
/**
 刷新数据
 */
- (void)loadData {
    NSMutableArray*mut=[[NSMutableArray alloc] init];
    for (int i=0; i<2; i++) {
        //  [self.dataArray addObject:[NSString stringWithFormat:@"第%d条数据",i]];//不会触发KVO
    }
    self.dataArray=mut;//数组指针改变 触发KVO
    [_tableView reloadData];
}

/**
 列表
 */
- (void)fetchList {
    DWGetMsgListWI *lwi = [[DWGetMsgListWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,@(0)];
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
 阅读
 */
- (void)fetchReadWithIndex:(NSInteger)index {
    if ([_dataArray[index].isread isEqualToString:@"已读"]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请勿重复操作" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    ReadnoticeWI *lwi = [[ReadnoticeWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,@(_dataArray[index].noticeid)];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:3.0];
            [t show];
            _dataArray[index].isread = @"已读";
            [_tableView reloadData];
        }
    } WithFailureBlock:^(NSError *error) {
    }];
}

/**
 完成
 */
- (void)fetchFinishWithIndex:(NSInteger)index {
    if ([_dataArray[index].isread isEqualToString:@"已完成"]) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请勿重复操作" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    UpdateMsgIsreadByIdWI *lwi = [[UpdateMsgIsreadByIdWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,@(_dataArray[index].noticeid)];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:3.0];
            [t show];
            _dataArray[index].isfinish = @"已完成";
            [_dataArray removeObjectAtIndex:index];
            [_tableView reloadData];
        }
    } WithFailureBlock:^(NSError *error) {
    }];
}

@end

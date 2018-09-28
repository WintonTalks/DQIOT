//
//  WorkHistoryNoticeViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "WorkHistoryNoticeViewController.h"
#import "DQWorkerNoticeListCell.h" // 工人通知列表
#import "WorkDeskListCell.h"
#import "DWGetMsgListWI.h"

static NSString * const cellIdentifier = @"DQWorkerHistoryNoticeListCell";

@interface WorkHistoryNoticeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSMutableArray <DWMsgModel *> *dataArray;
@end

@implementation WorkHistoryNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"历史通知";
    [self initView];
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

- (void)initView {
    
    //[EMINavigationController addAppBar:self];

    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DQWorkerNoticeListCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    CKRefreshHeader *ckh = [CKRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
    _tableView.mj_header = ckh;
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - 下拉刷新
- (void)loadNewData:(CKRefreshHeader *)sender {
    [self fetchList];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DQWorkerNoticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.noticeModel = _dataArray[indexPath.section];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

#pragma mark - KVO回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:@"dataArray"]) {
        return;
    }
    if ([self.dataArray count]==0) {//无数据
        [[BJNoDataView shareNoDataView] showCenterWithSuperView:self.view icon:@"ic_empty04" Frame:CGRectMake(0, 0, screenWidth, screenHeight-50) iconClicked:^{
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

#pragma mark - Http Request
/**
 列表
 */
- (void)fetchList {
    DWGetMsgListWI *lwi = [[DWGetMsgListWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,@(1)];
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

@end

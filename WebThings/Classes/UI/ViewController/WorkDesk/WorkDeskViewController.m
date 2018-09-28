//
//  WorkDeskViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "WorkDeskViewController.h"
#import "WorkDeskListCell.h"
#import "NotifyDetailViewController.h"
#import "NoticetypeWI.h"
#import "NoticeListWI.h"
#import "ReadnoticeWI.h"

@interface WorkDeskViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <DWMsgModel *> *dataArray;
@property (nonatomic, strong) UIBarButtonItem *readBtnItem;
@end

@implementation WorkDeskViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"消息中心";
    self.view.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    
    [self initWorkDeskNav];

    [self initWorkDeskView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 每次进入当前页面时刷新数据
    [self fetchWorkDeskNoticeList];
    
    //KVO
    [self addObserver:self forKeyPath:@"dataArray" options:NSKeyValueObservingOptionNew context:nil];
    if (!_dataArray.count) {
        self.dataArray = [NSMutableArray array];
        [self reloadHeight];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除KVO
    [self removeObserver:self forKeyPath:@"dataArray"];
}

- (void)initWorkDeskView {
    
    [self initRefreshHeaderView];
}

- (void)initWorkDeskNav {
    
    self.navigationItem.rightBarButtonItem = self.readBtnItem;
}

- (void)onAllReadClicked {
    
    [MobClick event:@"workDesk_msg_all_read"];
    // 遍历所有消息 取出未读集合 然后标记全部已读
    NSMutableArray *unreadArray = [[NSMutableArray alloc] init];
    [_dataArray enumerateObjectsUsingBlock:^(DWMsgModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.isread isEqualToString:@"未读"]) {
            [unreadArray addObject:obj];
        }
        
        // 遍历结束且遍历后的结果集大于零，则执行全部阅读事件
        if (((_dataArray.count-1) == idx)) {
            if (unreadArray.count > 0) {
                [self markMessageWithNotices:unreadArray];
            } else {
                MDSnackbar *alert = [[MDSnackbar alloc] initWithText:@"您的消息已经读完了" actionTitle:@"" duration:1.5];
                [alert show];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 下拉刷新
- (void)initRefreshHeaderView {
    CKRefreshHeader *ckh = [CKRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadWorkDeskNewData:)];
    _tableView.mj_header = ckh;
}

- (void)loadWorkDeskNewData:(CKRefreshHeader *)sender {
    [self fetchWorkDeskNoticeList];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkDeskListCell *cell = [WorkDeskListCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewValues:_dataArray[indexPath.row]];
    // [cell hideCardV];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [MobClick event:@"workDesk_msg_single_read"];
    
    [self markMessageWithNotices:_dataArray[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - KVO回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (![keyPath isEqualToString:@"dataArray"]) {
        return;
    }
    if ([self.dataArray count] == 0) { //无数据
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [[BJNoDataView shareNoDataView] showCenterWithSuperView:self.view icon:@"ic_empty04" Frame:CGRectMake(0, 0, screenWidth, screenHeight-50) iconClicked:^{
            //图片点击回调
            [self fetchWorkDeskNoticeList];
        } WithText:@"暂时没有可查询的工作通知"];
        self.tableView.hidden  = YES;
        return;
    }
    //有数据
    [[BJNoDataView shareNoDataView] clear];
    self.tableView.hidden  = NO;
    
    [self.dataArray enumerateObjectsUsingBlock:^(DWMsgModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.isread isEqualToString:@"未读"]) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            *stop = YES;
        }
    }];
}

#pragma mark - Http Request
/** 通知列表请求 */
- (void)fetchWorkDeskNoticeList {
    
    DQBusinessInterface *interface = [DQBusinessInterface sharedInstance];
    [interface dq_getWorkbenchNoticeMessageWithParam:@{@"msgtype":@"未读",@"page":@"1"} success:^(id result) {
        self.dataArray = [NSObject changeType:result];
        [self.tableView reloadData];
        [self reloadHeight];
        [self.tableView.mj_header endRefreshing];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

/** 标记单个消息已读和标记全部已读 */
- (void)markMessageWithNotices:(id)notices {
    
    if ([notices isKindOfClass:[NSArray class]]) {
        
        NSArray *msgNotices = notices;
        // 截掉最后一个 “,” 逗号
        NSString *noticeId = [[NSString alloc] init];
        for (int j = 0; j < msgNotices.count; j++) {
            DWMsgModel *model = msgNotices[j];
            noticeId = [noticeId stringByAppendingFormat:@"%ld,",model.noticeid];
        }
        if ([noticeId hasSuffix:@","]) {
            noticeId = [noticeId substringToIndex:noticeId.length-1];
        }
        
        [self markReadMessageWithNoticeId:noticeId successBlock:^{
            [self reloadMessageNotices:notices];
        }];
    } else if ([notices isKindOfClass:[DWMsgModel class]]) {
        
        DWMsgModel *msgModel = notices;
        // 避免重复操作
        if ([msgModel.isread isEqualToString:@"已读"]) {
//            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请勿重复操作" actionTitle:@"" duration:1.5];
//            [t show];
            return;
        }
        
        NSString *noticeId = [NSString stringWithFormat:@"%ld",msgModel.noticeid];
        __weak typeof(self) weakself = self;
        [self markReadMessageWithNoticeId:noticeId successBlock:^{
            for (int j = 0; j < weakself.dataArray.count; j++) {
                DWMsgModel *model = weakself.dataArray[j];
                if (msgModel.noticeid == model.noticeid) {
                    weakself.dataArray[j].isread = @"已读";
                }
            }
            [weakself.tableView reloadData];
        }];
    } else if ([notices isKindOfClass:[NSNull class]] || !notices) {
        
    }
    
}

/** 标记已读网络请求 */
- (void)markReadMessageWithNoticeId:(NSString *)noticeId successBlock:(void(^)())success {
    
    ReadnoticeWI *lwi = [[ReadnoticeWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype,noticeId];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            MDSnackbar *alert = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:1.5];
            [alert show];
        }
        success();
    } WithFailureBlock:^(NSError *error) {
    }];
    
}

/** 刷新表全部标记已读 */
- (void)reloadMessageNotices:(NSArray *)notices {
    
    [notices enumerateObjectsUsingBlock:^(DWMsgModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (int j = 0; j < _dataArray.count; j++) {
            DWMsgModel *model = _dataArray[j];
            if (obj.noticeid == model.noticeid) {
                _dataArray[j].isread = @"已读";
            }
        }
        if ((notices.count-1) == idx) {
            [_tableView reloadData];
        }
    }];
}

- (void)reloadHeight {
    if (100*_dataArray.count > screenHeight-64) {
        _fatherVHeight.constant = screenHeight-70;
    } else {
        _fatherVHeight.constant = 100*_dataArray.count;
    }
}

#pragma mark - Getter
- (UIBarButtonItem *)readBtnItem {
    if (!_readBtnItem) {
//        UIButton *readBtn = [[UIButton alloc] init];
//        readBtn.frame = CGRectMake(0, 0, 80, 40);
//        readBtn.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:12];
//        [readBtn setTitle:@"全部已读" forState:UIControlStateNormal];
//        [readBtn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
//        [readBtn addTarget:self action:@selector(onAllReadClicked) forControlEvents:UIControlEventTouchUpInside];
        _readBtnItem = [UIBarButtonItem itemWithTarget:self action:@selector(onAllReadClicked) title:@"全部已读"];
    }
    return _readBtnItem;
}


@end

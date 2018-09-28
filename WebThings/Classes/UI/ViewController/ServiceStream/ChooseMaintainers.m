//
//  ChooseMaintainers.m
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ChooseMaintainers.h"
#import "ChoosePeopleCell.h"
#import "EMICardView.h"
#import "RepairUserListWI.h"

@interface ChooseMaintainers ()<EMI_MaterialSeachBarDelegate,ChoosePeopleCellDelegate>
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <UserModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray <UserModel *> *searchArray;
/**
 搜索栏
 */
@property (nonatomic, strong) EMI_MaterialSeachBar *searchBar;

@property (nonatomic, strong) NSMutableArray <UserModel *> *selectedArr;
@end

@implementation ChooseMaintainers

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _thistitle;
    
    if (!_dm) {
        _dm = [[DeviceModel alloc] init];
        _dm.deviceid = _deviceid;
    }
    [self initArr];
    [self initView];
    //[EMINavigationController addAppBar:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initArr{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
        self.searchArray = [NSMutableArray array];
        self.selectedArr = [NSMutableArray array];
    }
    [self reloadHeight];
    [self fetchList];
}

- (void)initView
{
    UIBarButtonItem *rightNav = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavClicked2) image:[UIImage imageNamed:@"ic_done"]];
    self.navigationItem.rightBarButtonItem = rightNav;
}

#pragma 完成
- (void)rightNavClicked2
{
    for (UserModel *item in _searchArray) {
        if (item.isSelected) {
            [_selectedArr addObject:item];
        }
    }
    if (_selectedArr.count == 0) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请至少选择一名人员" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if ([_thistitle isEqualToString:@"选择维保人员"]) {
        [self fetch_ConfirmStartMaintainWI];
    }else if([_thistitle isEqualToString:@"选择维修人员"]){
        [self fetch_ConfirmStartRepairWI];
    }else if([_thistitle isEqualToString:@"选择加高人员"]){
        [self fetch_ConfirmAddHighWI];
    }
}

/**
 确认时间并发起维保
 */
- (void)fetch_ConfirmStartMaintainWI
{
    NSMutableArray *peopleList = [UserModel mj_keyValuesArrayWithObjectArray:_selectedArr];
    NSDictionary *dic = @{@"userid" : @(self.baseUser.userid),
                          @"type" : [NSObject changeType:self.baseUser.type],
                          @"projectid" : @(_projectid),
                          @"deviceid" : @(_dm.deviceid),
                          @"orderid" : @(_billid),
                          @"people" : peopleList,
                          @"usertype" : [NSObject changeType:self.baseUser.usertype]};

    [[DQServiceInterface sharedInstance] dq_getConfigStartMaintain:dic success:^(id result) {
        if (result != nil) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:3.0];
            [t show];

            [self.navigationController popViewControllerAnimated:YES];
            if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
                [self.basedelegate didPopFromNextVC];
            }
        }
        
    } failture:^(NSError *error) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"网络异常" actionTitle:@"" duration:3.0];
        [t show];
    }];
}

/**
 确认时间并发起维修
 */
- (void)fetch_ConfirmStartRepairWI
{
    NSMutableArray *peopleList = [UserModel mj_keyValuesArrayWithObjectArray:_selectedArr];
    NSDictionary *dic = @{@"userid" : @(self.baseUser.userid),
                          @"type" : self.baseUser.type,
                          @"projectid" : @(_projectid),
                          @"deviceid" : @(_dm.deviceid),
                          @"orderid" : @(_billid),
                          @"people" : peopleList,
                          @"usertype" : self.baseUser.usertype};

    [[DQServiceInterface sharedInstance] dq_getConfigStartRepair:dic success:^(id result) {
        if (result) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"操作成功" actionTitle:@"" duration:3.0];
            [t show];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
                [self.basedelegate didPopFromNextVC];
            }
        } else {
        
        }
    } failture:^(NSError *error) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"网络异常" actionTitle:@"" duration:3.0];
        [t show];
    }];
}

/**
 确认时间并发起加高
 */
- (void)fetch_ConfirmAddHighWI
{
    NSMutableArray *peopleArr = [UserModel mj_keyValuesArrayWithObjectArray:_selectedArr];
    [[DQServiceInterface sharedInstance] dq_getConfigAddHeight:@(_projectid) deviceid:@(_dm.deviceid) highid: @(_billid) people:peopleArr success:^(id result) {
        if (result != nil) {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.basedelegate && [self.basedelegate respondsToSelector:@selector(didPopFromNextVC)]) {
                [self.basedelegate didPopFromNextVC];
            }
        }
    } failture:^(NSError *error) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"网络异常" actionTitle:@"" duration:3.0];
        [t show];
    }];
}
/*
#pragma 搜索，发送
- (UIBarButtonItem *)rightNavBtns{
    
    UIView *rightBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 68, 0)];
    rightBarView.backgroundColor = [UIColor clearColor];
    CKRippleButton *btn1 = [[CKRippleButton alloc] init];
    [btn1 setRippleColor:[UIColor colorWithHexString:@"#CDCECE"]];
    [rightBarView addSubview:btn1];
    [btn1 addTarget:self action:@selector(rightNavClicked1) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"top_search"] forState:UIControlStateNormal];
    btn1.sd_layout.centerYEqualToView(rightBarView).leftSpaceToView(rightBarView, 0).heightIs(20).widthIs(20);
    
    CKRippleButton *btn2 = [[CKRippleButton alloc] init];
    [btn2 setRippleColor:[UIColor colorWithHexString:@"#CDCECE"]];
    [rightBarView addSubview:btn2];
    [btn2 addTarget:self action:@selector(rightNavClicked2) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"ic_done"] forState:UIControlStateNormal];
    btn2.sd_layout.centerYEqualToView(rightBarView).leftSpaceToView(btn1, 15).heightIs(20).widthIs(20);
    
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:rightBarView];
    
    self.navigationItem.rightBarButtonItem = bar;
    
    return self.navigationItem.rightBarButtonItem;
}

#pragma 搜索
- (void)rightNavClicked1{
    if (!_searchBar) {
        _searchBar = [[EMI_MaterialSeachBar alloc] init];
        _searchBar.delegate = self;
    }
    [_searchBar showWithFatherV:self.appBar.headerViewController.headerView];
}
#pragma EMI_MaterialSeachBarDelegate
- (void)EMI_MaterialSeachBarReturnKeyClicked:(NSString *)text{
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", text];
    //过滤数据
    self.searchArray= [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:preicate]];
    [self reloadHeight];
    [_tableView reloadData];
}
*/

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoosePeopleCell *cell = [ChoosePeopleCell cellWithTableView:tableView];
    cell.thisIndexPath = indexPath;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setViewValues:[_searchArray objectAtIndex:indexPath.row]];
    return cell;
}
- (void)cellcekBtnClicked:(CKCheckBoxButton *)sender indexPath:(NSIndexPath *)indexPath{
    _searchArray[indexPath.row].isSelected = sender.isOn;
}
#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

/**
 请求列表
 */
- (void)fetchList
{
    RepairUserListWI *lwi = [[RepairUserListWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,@(_projectid),self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            self.dataArray = temp[1];
            self.searchArray = self.dataArray;
            [self reloadHeight];
            [_tableView reloadData];
        }
        
    } WithFailureBlock:^(NSError *error) {
    }];
}

//刷新高度
- (void)reloadHeight
{
    if (60*_searchArray.count+21 < screenHeight-89) {
        _fatherVHeight.constant = 60*_searchArray.count+21;
    }else{
        _fatherVHeight.constant = screenHeight-89;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

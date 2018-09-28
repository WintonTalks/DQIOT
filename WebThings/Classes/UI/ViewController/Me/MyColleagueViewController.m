//
//  MyColleagueViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/4.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "MyColleagueViewController.h"
#import "ChoosePeopleCell.h"

@interface MyColleagueViewController ()
<EMI_MaterialSeachBarDelegate,
UITableViewDelegate,
UITableViewDataSource>
{
    CGFloat _fatherVHeight;
    UITableView *_mTableView;
}
@property (nonatomic, strong) NSMutableArray <UserModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray <UserModel *> *searchArray;
/**搜索栏*/
@property(nonatomic,strong)EMI_MaterialSeachBar *searchBar;
@end

@implementation MyColleagueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"项目团队";
    [self initArr];
    [self initView];
}

- (void)initArr
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
        self.searchArray = [NSMutableArray array];
    }
    [self reloadHeight];
    [self fetchList];
}

- (void)initView
{
//    UIBarButtonItem *rightNav = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"top_search"] style:UIBarButtonItemStylePlain target:self action:@selector(rightNavItemClicked)];
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavItemClicked) image:[UIImage imageNamed:@"top_search"]];

    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, screenWidth, screenHeight-74) style:UITableViewStylePlain];
    _mTableView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.separatorColor = [UIColor clearColor];
    _mTableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:_mTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (IS_IOS10) {
        UIEdgeInsets inset = _mTableView.contentInset;
        inset.top = 0;
        _mTableView.contentInset = inset;
    }
}

- (void)rightNavItemClicked
{
    [MobClick event:@"usercenter_my_search"];
    if (!_searchBar) {
        _searchBar = [[EMI_MaterialSeachBar alloc] init];
        _searchBar.delegate = self;
    }
    [_searchBar showWithFatherV:self.appBar.headerViewController.headerView];
}
#pragma EMI_MaterialSeachBarDelegate
- (void)EMI_MaterialSeachBarReturnKeyClicked:(NSString *)text
{
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", text];
    //过滤数据
    self.searchArray= [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:preicate]];
    [self reloadHeight];
    [_mTableView reloadData];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChoosePeopleCell *cell = [ChoosePeopleCell cellWithTableView:tableView];
    cell.cekBtn.hidden  = YES;
    cell.phoneBtn.hidden = NO;
    [cell setViewValues:[_searchArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

/**
 请求列表
 */
- (void)fetchList
{
    [[DQMyCenterInterface sharedInstance] dq_getMyColleagueListApi:self.baseUser success:^(id result) {
        self.searchArray = result;
        [self reloadHeight];
        [_mTableView reloadData];
    } failture:^(NSError *error) {
        
    }];
}

//刷新高度
- (void)reloadHeight
{
    if (60*_searchArray.count+21 < screenHeight-89) {
        _fatherVHeight = 60*_searchArray.count+21;
    }else{
        _fatherVHeight = screenHeight-89;
    }
    _mTableView.height = _fatherVHeight;
}

@end

//
//  ChooseDriversViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/17.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ChooseDriversViewController.h"
#import "ChoosePeopleCell.h"
#import "GetValidDriversWI.h"
#import "EMICardView.h"

@interface ChooseDriversViewController ()<EMI_MaterialSeachBarDelegate>
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <UserModel *> *dataArray;
@property(nonatomic,strong)NSMutableArray <UserModel *> *searchArray;
/**
 搜索栏
 */
@property(nonatomic,strong)EMI_MaterialSeachBar *searchBar;
@end

@implementation ChooseDriversViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"司机列表";
    
    [self initView];
    //[EMINavigationController addAppBar:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //KVO
    [self addObserver:self forKeyPath:@"dataArray" options:NSKeyValueObservingOptionNew context:nil];
    [self initArr];
    //[self.navigationController setNavigationBarHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initArr{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
        self.searchArray = [NSMutableArray array];
    }
    [self reloadHeight];
    [self fetchList];
}
- (void)initView { 
    [self rightNavBtn];
}

- (UIBarButtonItem *)rightNavBtn{
    UIBarButtonItem *rightNav = [UIBarButtonItem itemWithTarget:self action:@selector(rightNavClicked) image:[UIImage imageNamed:@"top_search"]];
    self.navigationItem.rightBarButtonItem = rightNav;
    return rightNav;
}

- (void)rightNavClicked{
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
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoosePeopleCell *cell = [ChoosePeopleCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.jobLab.hidden = YES;
    cell.cekBtn.hidden = YES;
    [cell setViewValues:[_searchArray objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserModel *m = [_searchArray objectAtIndex:indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(didPopWithDriverModel:)]) {
        [_delegate didPopWithDriverModel:m];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


/**
 请求列表
 */
- (void)fetchList{
    GetValidDriversWI *lwi = [[GetValidDriversWI alloc] init];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,self.baseUser.usertype];
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
- (void)reloadHeight{
    if (60*_searchArray.count+21 < screenHeight-89) {
        _fatherVHeight.constant = 60*_searchArray.count+21;
    }else{
        _fatherVHeight.constant = screenHeight-89;
    }
}

#pragma mark-----KVO回调----
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (![keyPath isEqualToString:@"dataArray"]) {
        return;
    }
    if ([self.dataArray count]==0) {//无数据
        [[BJNoDataView shareNoDataView] showCenterWithSuperView:self.view icon:@"ic_empty06" Frame:CGRectMake(0, 0, screenWidth, screenHeight) iconClicked:^{
            //图片点击回调
            //            [self loadData];//刷新数据
            [self fetchList];
        } WithText:@"当前没有司机"];
        self.fatherV.hidden  = YES;
        //        self.topCalendarFatherV.hidden = YES;
        return;
    }
    //有数据
    [[BJNoDataView shareNoDataView] clear];
    self.fatherV.hidden  = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除通知
    //移除KVO
    [self removeObserver:self forKeyPath:@"dataArray"];
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

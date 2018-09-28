//
//  DQBusinessSearchController.m
//  WebThings
//
//  Created by Eugene on 2017/9/19.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQBusinessSearchController.h"
#import "BusinessCenterCell.h"

#import "AddProjectViewController.h"
#import "CKAlertContainerView.h"
#import "DQProjectManangeController.h"
#import "CKAlertView.h"
#import "ProjectListWI.h"
#import "DeleteProjectWI.h"
#import "AddProjectModel.h"
#import "ObtainNumberWI.h"

#import "EMI_MaterialSeachBar.h"

@interface DQBusinessSearchController ()<UITableViewDelegate,UITableViewDataSource,CKAlertViewDelegate,EMI_MaterialSeachBarDelegate,EMIBaseViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EMI_MaterialSeachBar *searchBar;
@property (nonatomic, strong) NSMutableArray *resultAry;

@end

@implementation DQBusinessSearchController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSearchView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ProjectCenter"];

    // 隐藏导航条
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ProjectCenter"];
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)initSearchView {
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];

    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
}

#pragma make - CKAlertViewDelegate
- (void)ckalert_sureBtnClicked:(CKAlertView *)sender {
    [self fetchDeleteProject:sender.tag];
}

#pragma mark - EMI_MaterialSeachBarDelegate
/** 点击搜索后调用 */
- (void)EMI_MaterialSeachBarReturnKeyClicked:(NSString *)text {
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"projectname CONTAINS[c] %@", text];
    // 过滤数据
    _resultAry = [NSMutableArray arrayWithArray:[self.dateArray filteredArrayUsingPredicate:preicate]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 49;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BusinessCenterCell *cell = [BusinessCenterCell cellWithTableView:tableView];
    [cell setViewWithValues:(AddProjectModel *)_resultAry[indexPath.section]];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) { return nil;}
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, screenWidth, 49);
    headerView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    
    return headerView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DQProjectManangeController *VC = [DQProjectManangeController new];
    AddProjectModel *m = (AddProjectModel *)_resultAry[indexPath.section];
    VC.projectid = m.projectid;
    VC.drivertype = m.drivertype;
    VC.projectModel = m;
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 224;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isZuLin] && ![self isCEO]) {
        return YES;
    }
    return NO;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editAct = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [MobClick event:@"business_modify_project"];
        
        AddProjectViewController *VC = [[AddProjectViewController alloc] init];
        VC.isNew = 1;
        VC.pmodel = _resultAry[indexPath.section];
        VC.basedelegate = self;
        [self.navigationController pushViewController:VC animated:YES];
    }];
    
    UITableViewRowAction *deleteAct = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"    " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [MobClick event:@"business_delete_project"];
        
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
- (void)fetchDeleteProject:(NSInteger)index {
    
    DeleteProjectWI *lwi = [[DeleteProjectWI alloc] init];
    AddProjectModel *tempM = (AddProjectModel *)_resultAry[index];
    NSArray *arr = @[@(self.baseUser.userid),self.baseUser.type,@(tempM.projectid),self.baseUser.usertype];
    NSDictionary *param = [lwi inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:lwi.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSArray *temp = [lwi unBox:returnValue];
        if ([temp[0] integerValue] == 1) {
            //成功
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"删除成功" actionTitle:@"" duration:3.0];
            [t show];
            //刷新表格
            [self.resultAry removeObjectAtIndex:index];
            [self.tableView reloadData];
        }
        
    } WithFailureBlock:^(NSError *error) {
    }];
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
        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}
@end

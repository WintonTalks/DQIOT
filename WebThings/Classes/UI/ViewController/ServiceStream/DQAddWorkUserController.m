//
//  DQAddWorkUserController.m
//  WebThings
//
//  Created by winton on 2017/10/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQAddWorkUserController.h"
#import "DQCheckWorkUserCell.h"

@interface DQAddWorkUserController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *checkUserArray;
@property (nonatomic, strong) NSMutableArray *dataUserArray;
@end

@implementation DQAddWorkUserController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择工作人员";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popViewController) image:ImageNamed(@"back")];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onConfirmClick) title:@"确认"];
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    _mTableView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.separatorColor = [UIColor clearColor];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mTableView.contentInset = UIEdgeInsetsMake(64,0,0,0);
        _mTableView.scrollIndicatorInsets = _mTableView.contentInset;
    }
    [self.view addSubview:_mTableView];
    [self fetchUserList];
}

- (void)fetchUserList
{
    [[DQServiceInterface sharedInstance] dq_getRepairUserList:self.projectID suc:^(id result) {
        if (result) {
            self.dataUserArray = result;
            [self.mTableView reloadData];
        }
    } failture:^(NSError *error) {
        
    }];
}


#pragma mark -UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataUserArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 8)];
    infoView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    return infoView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DQCheckWorkUserCell *workUserCell = [tableView dequeueReusableCellWithIdentifier:@"workUserCellIdentifier"];
    if (!workUserCell) {
        workUserCell = [[DQCheckWorkUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"workUserCellIdentifier"];
    }
    MJWeakSelf;
    UserModel *um = [self.dataUserArray safeObjectAtIndex:indexPath.row];
    workUserCell.selectIndexPath = indexPath;
    [workUserCell configCormit:[self versionCheckUserName:um]];
    [workUserCell configCheckWorkModel:um];
    workUserCell.cellSelectedUserBlock = ^(NSIndexPath *selectIndexPath) {
        [weakSelf onTouchCheckUserCell:selectIndexPath];
    };
    return workUserCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserModel *um = [self.dataUserArray safeObjectAtIndex:indexPath.row];
    if (self.type == KDQAddWorkUserRadioStyle) {
        if ([self versionCheckUserName:um]) {
            [self.checkUserArray removeObject:um];
        } else {
            [self.checkUserArray removeAllObjects];
            [self.checkUserArray safeAddObject:um];
        }
    } else {
        if ([self versionCheckUserName:um]) {
            [self.checkUserArray removeObject:um];
        } else {
            [self.checkUserArray safeAddObject:um];
        }
    }
    [self.mTableView reloadData];
}

- (void)onTouchCheckUserCell:(NSIndexPath *)indexPath
{
    UserModel *um = [self.dataUserArray safeObjectAtIndex:indexPath.row];
    if (self.type == KDQAddWorkUserRadioStyle) {
        if ([self versionCheckUserName:um]) {
            [self.checkUserArray removeObject:um];
        } else {
            [self.checkUserArray removeAllObjects];
            [self.checkUserArray safeAddObject:um];
        }
    } else {
        if ([self versionCheckUserName:um]) {
            [self.checkUserArray removeObject:um];
        } else {
            [self.checkUserArray safeAddObject:um];
        }
    }
    [self.mTableView reloadData];
}

- (BOOL)versionCheckUserName:(UserModel *)model
{
    if (!self.checkUserArray.count) {
        return false;
    }
    for (UserModel *um in self.checkUserArray) {
        if (um.userid == model.userid) {
            return true;
        }
    }
    return false;
}

#pragma mark - 点击确认
- (void)onConfirmClick
{
    if (!self.checkUserArray.count) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请选择工作人员!" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    if (self.userDataBlock) {
        self.userDataBlock(self.checkUserArray);
    }
    
    [self popViewController];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:true];
}

- (NSMutableArray *)checkUserArray
{
    if (!_checkUserArray) {
        _checkUserArray = [NSMutableArray new];
    }
    return _checkUserArray;
}

- (NSMutableArray *)dataUserArray
{
    if (!_dataUserArray) {
        _dataUserArray = [NSMutableArray new];
    }
    return _dataUserArray;
}
@end

//
//  DQQualificationRecordController.m
//  WebThings
//
//  Created by winton on 2017/10/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//  资质记录

#import "DQQualificationRecordController.h"
#import "DQDericePhotoListCell.h"
#import "DQUserQualificationModel.h"

@interface DQQualificationRecordController ()
<UITableViewDelegate,
UITableViewDataSource,
MGSwipeTableCellDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation DQQualificationRecordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popViewController) image:ImageNamed(@"back")];
    self.title = @"资质记录";
    [self.view addSubview:self.mTableView];
    [self fetchPersonQualificationAPI];
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

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark -UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DQUserQualificationModel *model = [self.dataList safeObjectAtIndex:indexPath.section];
    return model.height+181;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return (section == 0) ? 8.f : 16.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = (section == 0) ? 8.f : 16.f;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-20, height)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DQDericePhotoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MangerPhotoListCellIdentifier"];
    if (!cell) {
        cell = [[DQDericePhotoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MangerPhotoListCellIdentifier"];
    }
    if ([self isZuLin] && ![self isCEO]) {
        cell.delegate = self;
    } else {
        cell.delegate = nil;
    }
    DQUserQualificationModel *model = [self.dataList safeObjectAtIndex:indexPath.section];
    cell.indexPath = indexPath;
    [cell configQualificationInfoModel:model];
    return cell;
}

#pragma mark -MGSwipeTableCellDelegate
-(nullable NSArray<UIView*>*) swipeTableCell:(nonnull MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
                               swipeSettings:(nonnull MGSwipeSettings*) swipeSettings expansionSettings:(nonnull MGSwipeExpansionSettings*) expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionBorder;
    if (direction == MGSwipeDirectionRightToLeft) {
        expansionSettings.buttonIndex = -1;
        expansionSettings.fillOnTrigger = true;
        return [self createRightButtons];
    }
    return nil;
}

-(BOOL)swipeTableCell:(MGSwipeTableCell*)cell
  tappedButtonAtIndex:(NSInteger)index
            direction:(MGSwipeDirection)direction
        fromExpansion:(BOOL)fromExpansion
{
    if (direction == MGSwipeDirectionRightToLeft) {
        NSIndexPath *indexPath = [self.mTableView indexPathForCell:cell];
        [self fetchRemoveRecordAPI:indexPath];
    }
    return false;
}

- (void)fetchPersonQualificationAPI
{
    [[DQProjectInterface sharedInstance] dq_getPersonQualificationList:self.projectID success:^(id result) {
        if (result) {
            self.dataList = result;
            [self.mTableView reloadData];
        }
    } failture:^(NSError *error) {
        
    }];
}

- (void)fetchRemoveRecordAPI:(NSIndexPath *)indexPath
{
    DQUserQualificationModel *model = [self.dataList safeObjectAtIndex:indexPath.section];
    [[DQProjectInterface sharedInstance] dq_getDeletePersonQualification:self.projectID workerid:model.workerid success:^(id result) {
        if (result) {
            [self.dataList safeRemoveObjectAtIndex:indexPath.section];
            [self.mTableView reloadData];
        }
    } failture:^(NSError *error) {
        
    }];
}

- (NSArray *)createRightButtons
{
    UIColor *color = [UIColor colorWithHexString:@"#F3F4F5"];
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"" icon:ImageNamed(@"icon_delete") backgroundColor:color padding:20];
    button.width = 80.f;
    return @[button];
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray new];
    }
    return _dataList;
}

- (UITableView *)mTableView
{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 64, self.view.width-20, screenHeight-64) style:UITableViewStylePlain];
        _mTableView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorColor = [UIColor clearColor];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.showsVerticalScrollIndicator = false;
        if (@available(iOS 11.0, *)) {
            _mTableView.estimatedRowHeight = 0;
            _mTableView.estimatedSectionHeaderHeight = 0;
            _mTableView.estimatedSectionFooterHeight = 0;
            _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}

@end

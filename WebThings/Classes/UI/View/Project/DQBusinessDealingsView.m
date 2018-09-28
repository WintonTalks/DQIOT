
//
//  DQBusinessDealingsView.m
//  WebThings
//
//  Created by winton on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//  Done By Heidi 2017/10/13
//  商务往来

#import "DQBusinessDealingsView.h"
#import "DQServiceStationBaseCell.h"
#import "DQServiceButtonView.h"

#import "DQLogicBusinessContractModel.h"
#import "DQBusinessContractModel.h"

#import "DQBusinessContactInterface.h"

#import "DQNewBusContactController.h"

@interface DQBusinessDealingsView ()
<EMIBaseViewControllerDelegate,
DQLogicServiceDelegate>

@end

@implementation DQBusinessDealingsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
        _foldSections = [NSMutableArray arrayWithCapacity:0];
        self.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 61)];
        header.backgroundColor = [UIColor colorWithHexString:COLOR_BG];

        _btnLogic = [DQLogicBusinessContractModel
                                             dq_buttonLogicWithEnumState:DQEnumStateBusContactAdd
                                             flowType:DQFlowTypeBusinessContact];
        _btnLogic.delegate = self;
        
        DQServiceButtonView *btnNewContact = [[DQServiceButtonView alloc]
                                              initWithFrame:CGRectMake(16, 0, screenWidth - 32, 61)
                                              logic:_btnLogic];
        [header addSubview:btnNewContact];

        _mainTable = [[UITableView alloc] initWithFrame:
                      CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_mainTable];
        
        _mainTable.tableHeaderView = header;
        
        CKRefreshHeader *refreshHeader = [CKRefreshHeader
                                   headerWithRefreshingTarget:self
                                   refreshingAction:@selector(reloadData)];
        _mainTable.mj_header = refreshHeader;
        [_mainTable.mj_header beginRefreshing];
    }
    return self;
}

#pragma mark -
- (void)reloadData {
    
    [[DQBusinessContactInterface sharedInstance]
     dq_getListWithProjID:@(_projectID)
     success:^(id result) {
         [_mainTable.mj_header endRefreshing];

         [_dataArray removeAllObjects];
         [_dataArray addObjectsFromArray:result];
         
         [_mainTable reloadData];
         [self scrollViewDidScroll:_mainTable];

     } failture:^(NSError *error) {
         [_mainTable.mj_header endRefreshing];
     }];
}

- (void)setProjectID:(NSInteger)projectID {
    _projectID = projectID;
    
    _btnLogic.projectid = projectID;

    [self reloadData];
}

- (void)setNavCtl:(UINavigationController *)navCtl {
    _navCtl = navCtl;
    _btnLogic.navCtl = navCtl;
}

- (NSArray *)displayArrayWithSection:(NSInteger)section {
    NSArray *datas = _dataArray[section];
    
    DQLogicBusinessContractModel *lastModel = datas[[datas count] - 1];
    BOOL hasButtonCell = lastModel.cellData.isButtonCell;
    
    NSMutableArray *displayArray = [NSMutableArray arrayWithCapacity:0];
    if ([_foldSections containsObject:@(section)]) {    // 如果是折叠，只显示头尾（和Button）
        [displayArray addObject:datas[0]];
        
        if (hasButtonCell && [datas count] > 2) {    // 如果有Button，则要显示Button前面一个
            [displayArray addObject:datas[[datas count] - 2]];
        }
        [displayArray addObject:lastModel];
    } else {    // 如果是展开，则显示全部数据
        [displayArray addObjectsFromArray:datas];
    }
    return displayArray;
}

#pragma mark - EMIBaseViewControllerDelegate
- (void)didPopFromNextVC {
    [self reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self displayArrayWithSection:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataArray count] > 0) {
        NSArray *datas = [self displayArrayWithSection:indexPath.section];
        DQLogicBusinessContractModel *model = datas[indexPath.row];
        return model.cellHeight;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 8)];
    footer.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSArray *datas = _dataArray[section];

    DQLogicBusinessContractModel *lastModel = datas[[datas count] - 1];
    BOOL hasButtonCell = lastModel.cellData.isButtonCell;   // 最后一行是否有按钮
    NSArray *displayArray = [self displayArrayWithSection:section];
    NSInteger displayCount = (hasButtonCell ? 4 : 3);   // 3个及以上(按钮不算在内)，则显示下拉收齐箭头
    
    DQLogicBusinessContractModel *model = displayArray[indexPath.row];
    model.navCtl = self.navCtl;
    model.canExpend = [datas count] >= displayCount && indexPath.row == 0;    // 是否可以收起
    model.delegate = self;
    model.isOpen = ![_foldSections containsObject:@(section)];
    
    NSString *cellIdentifier = model.cellIdentifier;
    DQServiceStationBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        Class cellClass = NSClassFromString(cellIdentifier);
        cell = [[[cellClass class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setData:model];
    cell.reloadCellBlock = ^(BOOL isOpen){
        if (!isOpen) {
            [_foldSections addObject:@(section)];
        } else {
            if ([_foldSections containsObject:@(section)]) {
                [_foldSections removeObject:@(section)];
            }
        }
        [_mainTable reloadData];
    };
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //footerView
    if (scrollView == _mainTable) {
        //去掉UItableview的section的footerview黏性
        CGFloat sectionFooterHeight = 8;
        if (scrollView.contentOffset.y<=sectionFooterHeight && scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, -sectionFooterHeight, 0);
        } else if (scrollView.contentOffset.y>=sectionFooterHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, -sectionFooterHeight, 0);
        }
    }
}

#pragma mark -
// 完成某些操作（如API调用）后须刷新数据
- (void)dq_needReloadData {
    [self reloadData];
}

@end

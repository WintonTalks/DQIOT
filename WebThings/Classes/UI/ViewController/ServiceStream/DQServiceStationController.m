//
//  DQServiceStationController.m
//  WebThings
//  业务站主页
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceStationController.h"
#import "EMINavigationController.h"
#import "DQServiceStationDetailController.h"

#import "DeviceModel.h"
#import "DQServiceSubNodeModel.h"
#import "DQServiceNodeModel.h"
#import "DQLogicServiceBaseModel.h"

#import "DQServiceSectionHeaderView.h"

#import "DQServiceStationBaseCell.h"

@implementation DQServiceStationController

#pragma mark - Init
- (void)initSubviews {
    self.view.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    
    CGFloat height = self.view.frame.size.height - 6;
    _bodyScroll = [[UIScrollView alloc]
                   initWithFrame:CGRectMake(0, 6, screenWidth, height)];
    if (@available(iOS 11.0, *)) {
        _bodyScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _bodyScroll.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _bodyScroll.scrollIndicatorInsets = _bodyScroll.contentInset;
    }
//    _bodyScroll.delaysContentTouches = false;
//    _bodyScroll.canCancelContentTouches = false;
    [self.view addSubview:_bodyScroll];
    
    _mainTable = [[UITableView alloc]
                  initWithFrame:CGRectMake(0, 0, screenWidth, height)
                  style:UITableViewStylePlain];
    _mainTable.dataSource = self;
    _mainTable.delegate = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.scrollEnabled = NO;
    _mainTable.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    _mainTable.backgroundView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    [_bodyScroll addSubview:_mainTable];
    

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 31)];
    headerView.backgroundColor = [UIColor whiteColor];
    _mainTable.tableHeaderView = headerView;
    
    _evaluteView = [[DQServiceEvaluateFooterView alloc]
                    initWithFrame:CGRectMake(0, 0, screenWidth, 500)];
    _evaluteView.delegate = self;
    _evaluteView.backgroundColor = [UIColor whiteColor];
    [_bodyScroll addSubview:_evaluteView];
    _evaluteView.hidden = YES;
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _openSection = -1;
    _lastSection = -1;
    
    self.title = @"业务站";
    _sectionArray = [NSMutableArray arrayWithCapacity:0];
    _stateArray = [NSMutableArray arrayWithCapacity:0];
    
    [self initSubviews];

    [self fetchServiceState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
- (void)onKeyboardShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGRect frame = _bodyScroll.frame;
    frame.size.height = self.view.frame.size.height - keyboardFrame.size.height;
    _bodyScroll.frame = frame;
}

- (void)onKeyboardHide:(NSNotification *)notification {
    CGRect frame = _bodyScroll.frame;
    frame.size.height = self.view.frame.size.height - 6;
    _bodyScroll.frame = frame;
}

#pragma mark - Handle
- (void)handleServiceState {
    
    // 找出当前走到哪一步，并获取当前步骤的数据
    NSInteger index = 0;
    for (int i = 0; i < [_sectionArray count]; i++) {
        DQServiceNodeModel *node = _sectionArray[i];
        if ([node.flowtype isEqualToString:@"设备起租"]) {
            node.flowtype = @"设备启租";
        }
        if (node.canclick == 1) {
            index = i;
        }
    }
    _currentStep = index;
    _openSection = index;
    [self requestSubDataWithStep:_openSection];
}

/// 跳转到下一级页面
- (void)pushToNext:(DQFlowType)type {
    DQServiceNodeModel *node = _sectionArray[type];

    DQServiceStationDetailController *ctl = [[DQServiceStationDetailController alloc] init];
    ctl.projectid = _projectid;
    ctl.device = _dm;
    ctl.flowTypeName = node.flowtype;
    [self.navigationController pushViewController:ctl animated:YES];
}

// 刷新Table
- (void)reloadTableData {
    //判断状态值
//    if ((_openSection == -1 && _lastSection == -1) || !_isNotFirst) {
    [_mainTable reloadData];
//    } else {
//        NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
//        if (_lastSection != -1) {
//            [indexSets addIndex:_lastSection];
//        }
//        if (_openSection != -1) {
//            [indexSets addIndex:_openSection];
//        }
//        [_mainTable reloadSections:indexSets withRowAnimation:UITableViewRowAnimationAutomatic];
//    }

    [self refreshScrollView];
    
    // 没有数据时，隐藏白色HeaderView
    _mainTable.tableHeaderView.hidden = [_stateArray count] < 1 && [_sectionArray count] < 1;
}

// 设置滚动区域
- (void)refreshScrollView {

    CGRect rectTable = _mainTable.frame;
    CGFloat height = rectTable.size.height;

    _bodyScroll.backgroundColor = [UIColor clearColor];
    
    // 承租方发起评价且可以查看, 租赁方只能查看
    BOOL isZulin = [AppUtils readUser].isZuLin;
    BOOL showEvaluate = _openSection == DQFlowTypeEvaluate &&
    (([_stateArray count] > 1 && isZulin) || !isZulin);
    if (showEvaluate) { // 评价View
        DQLogicEvaluateModel *logicEvaluate;
        if ([_stateArray count] > 0) {
            logicEvaluate = (DQLogicEvaluateModel *)_stateArray[0];
            logicEvaluate.delegate = self;
        }
        [_evaluteView setEvaluteLogic:logicEvaluate];
        
        _bodyScroll.backgroundColor = [UIColor whiteColor];
        
        CGRect rect = _evaluteView.frame;
        rect.origin.y = 518 + 32;
        rect.size.height = [_evaluteView getMaxY] + 16;
        _evaluteView.frame = rect;
        
        height = rect.size.height + 518 + 32;    // 518: 全部收起时Table的高度
        rectTable.size.height = height;
        _mainTable.frame = rectTable;
    }

    if (showEvaluate) {
        
        _mainTable.scrollEnabled = NO;
        _bodyScroll.scrollEnabled = YES;
        _bodyScroll.contentSize = CGSizeMake(screenWidth, height);

        _evaluteView.hidden = NO;
        // 滚动到最底部
        [UIView animateWithDuration:0.5 animations:^{
            [_bodyScroll setContentOffset:
             CGPointMake(0, _bodyScroll.contentSize.height - _bodyScroll.frame.size.height)];
        }];
    }
    else {
        _mainTable.scrollEnabled = YES;
        rectTable.origin.y = 0;
        rectTable.size.height = screenHeight - self.navigationBarHeight;
        _mainTable.frame = rectTable;
        _bodyScroll.contentSize = CGSizeMake(rectTable.size.width, height);
        _bodyScroll.scrollEnabled = NO;
        _evaluteView.hidden = YES;
    }
}

#pragma mark - Request API
/// 获取服务流状态
- (void)fetchServiceState {
    [[DQServiceInterface sharedInstance]
     dq_getServiceStationWithProjID:@(_projectid)
     deviceID:@(_dm.deviceid)
     projectdeviceid:@(_dm.projectdeviceid)
     success:^(id result) {
        
         [_sectionArray removeAllObjects];
         BOOL isRentBegin = NO;
         // 过滤司机
         for (DQServiceNodeModel *node in result) {
             if (node.nodeIndex == DQFlowTypeRent) {
                 isRentBegin = node.isfinish;
             }
             if (![node.flowtype isEqualToString:@"司机确认"] &&
                 node.nodeIndex <= DQFlowTypeEvaluate) {
                 if (node.nodeIndex >= DQFlowTypeMaintain &&
                     node.nodeIndex <= DQFlowTypeHeighten &&
                     isRentBegin) {// 启租打开之后，维修／加高／维保始终可以点击
                     node.canclick = YES;
                 }
                 [_sectionArray addObject:node];
             }
         }
         
         [self handleServiceState];
         
     } failture:^(NSError *error) {
         
     }];
}

/// 获取服务流数据
- (void)requestSubDataWithStep:(DQFlowType)flow {
    
    if ([_sectionArray count] <= flow) {
        [self reloadTableData];
        return;
    }
    if (_openSection <= DQFlowTypeRent || _openSection >= DQFlowTypeRemove) {
        DQServiceNodeModel *node = _sectionArray[flow];
        
        [[DQServiceInterface sharedInstance]
         dq_getServiceFlowDataWithProjID:@(_projectid)
         deviceID:@(_dm.deviceid)
         projectdeviceid:@(_dm.projectdeviceid)
         flowType:flow == DQFlowTypeRemove ? @"拆除设备" : node.flowtype
         success:^(id result) {
             [_stateArray removeAllObjects];
             [_stateArray addObjectsFromArray:result];

             [self reloadTableData];

         } failture:^(NSError *error) {
             
         }];
    } else {
        _openSection = -1;
        [_stateArray removeAllObjects];
        [self reloadTableData];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == DQFlowTypeEvaluate && _openSection == section) {
        return 0;
    }
    return section == _openSection ? [_stateArray count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_stateArray count] > 0) {
        DQLogicServiceBaseModel *model = _stateArray[indexPath.row];
        return model.cellHeight;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == DQFlowTypeRent || section == DQFlowTypeRemove) {
        return 84.0;
    }
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 自定义的SectionHeader
    DQServiceSectionHeaderView *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ServiceFlowSectionHeader"];
    if (sectionHeader == nil) {
        sectionHeader = [[DQServiceSectionHeaderView alloc] initWithReuseIdentifier:@"ServiceFlowSectionHeader"];
        
        sectionHeader.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    __weak DQServiceSectionHeaderView *weakHeader = sectionHeader;
    __block DQServiceStationController *blockSelf = self;
    // Header设置
    DQServiceNodeModel *node = _sectionArray[section];
    [sectionHeader setNode:node];
    sectionHeader.currentStep = _currentStep;
    sectionHeader.openIndex = _openSection;
    sectionHeader.clicked = ^(id result) {
        _lastSection = _openSection;
        
        // 维修／加高／维保点击跳下一级页面
        if (weakHeader.canSkipToNext) {
            [blockSelf pushToNext:node.nodeIndex];
        }
        else {
            if ([result boolValue]) {  // 每次点开section的时候去请求该业务的数据
                _openSection = section;
                _isNotFirst = YES;
                [self requestSubDataWithStep:node.nodeIndex];
                
             } else {
                if (node.nodeIndex == DQFlowTypeEvaluate) {
                    _evaluteView.hidden = YES;
                }
                _openSection = -1;
                [self reloadTableData];
            }
        }
    };
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DQLogicServiceBaseModel *model = _stateArray[indexPath.row];
    model.delegate = self;
    model.navCtl = self.navigationController;
    model.device = _dm;
    model.projectid = _projectid;
    model.cellData.deviceaddress = _dm.installationsite;
    
    NSString *cellIdentifier = model.cellIdentifier;
    // 父类Cell接受类型，运行时Cell的真实类型为DQLogicServiceBaseModel的子类里各自指定的Cell
    DQServiceStationBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        Class cellClass = NSClassFromString(cellIdentifier);
        cell = [[[cellClass class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setData:model];
    cell.reloadCellBlock = ^(BOOL isCellReload){
        if (isCellReload) {
            [self reloadTableData];
        } else {
            [self reloadTableData];
        }
    };

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 84;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - DQServiceEvaluateViewDelegate
- (void)willChangeHeight:(CGFloat)height {
    [self refreshScrollView];
}

// 完成某些操作（如API调用）后须刷新数据
- (void)dq_needReloadData {
    [self fetchServiceState];
}

@end

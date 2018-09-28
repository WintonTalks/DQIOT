//
//  DQServiceStationDetailController.m
//  WebThings
//  业务站二级页面
//  Created by Heidi on 2017/9/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceStationDetailController.h"
#import "EMINavigationController.h"

#import "DQServiceStationBaseCell.h"
#import "DQServiceButtonView.h"

#import "DQServiceNodeModel.h"
#import "DQSubMaintainModel.h"
#import "DeviceModel.h"

@implementation DQServiceStationDetailController

#pragma mark - Init
- (void)initSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mainTable = [[UITableView alloc]
                  initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)
                  style:UITableViewStylePlain];
    _mainTable.dataSource = self;
    _mainTable.delegate = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_mainTable.scrollEnabled = NO;
    _mainTable.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.view addSubview:_mainTable];
    if (@available(iOS 11.0, *)) {
        _mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mainTable.contentInset = UIEdgeInsetsMake(84, 0, 0, 0);
        _mainTable.scrollIndicatorInsets = _mainTable.contentInset;
    }
    
    self.title = _flowTypeName;
    
    DQFlowType flowType = [AppUtils nodeIndexWithTypeName:_flowTypeName];
    // 双方都可以发起维保，承租方才能发起维修和加高
    if (flowType == DQFlowTypeMaintain || ![AppUtils readUser].isZuLin) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 61)];
        header.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
        
        DQEnumState state;
        switch (flowType) {
            case DQFlowTypeMaintain:{
                state = DQEnumStateMaintainAdd;
            }
                break;
            case DQFlowTypeFix: {
                state = DQEnumStateFixAdd;
            }
                break;
            case DQFlowTypeHeighten: {
                state = DQEnumStateHeightAdd;
            }
                break;
                default:
                state = DQEnumStateMaintainAdd;
                break;
        }

        DQSubMaintainModel *tempM = [[DQSubMaintainModel alloc] init];
        tempM.enumstateid = state;
        tempM.isButtonCell = YES;

        DQLogicMaintainModel *logic = [[DQLogicMaintainModel alloc] init];
        logic.nodeName = _flowTypeName;
        logic.nodeType = flowType;
        logic.cellData = tempM;
        logic.delegate = self;
        logic.navCtl = self.navigationController;
        logic.projectid = self.projectid;
        logic.device = self.device;
        
        DQServiceButtonView *btnNew = [[DQServiceButtonView alloc]
                                       initWithFrame:CGRectMake(16, 0, screenWidth - 32, 61)
                                       logic:logic];
        [header addSubview:btnNew];
        
        _mainTable.tableHeaderView = header;
    }
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _foldSections = [NSMutableArray arrayWithCapacity:0];
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self initSubviews];
    [self requestSubData];
}

#pragma mark -
/// 获取服务流数据
- (void)requestSubData {
    
    [[DQServiceInterface sharedInstance]
     dq_getServiceFlowDataWithProjID:@(_projectid)
     deviceID:@(_device.deviceid)
     projectdeviceid:@(_device.projectdeviceid)
     flowType:_flowTypeName
     success:^(id result) {
         
         [_dataArray removeAllObjects];
         [_dataArray addObjectsFromArray:result];
         [_mainTable reloadData];
         
     } failture:^(NSError *error) {
         
     }];
}

- (NSArray *)displayArrayWithSection:(NSInteger)section {
    NSArray *datas = _dataArray[section];
    
    DQLogicMaintainModel *lastModel = datas[[datas count] - 1];
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

        DQLogicServiceBaseModel *model = datas[indexPath.row];
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
    
    DQLogicMaintainModel *lastModel = datas[[datas count] - 1];
    BOOL hasButtonCell = lastModel.cellData.isButtonCell;   // 最后一行是否有按钮
    NSArray *displayArray = [self displayArrayWithSection:section];
    NSInteger displayCount = (hasButtonCell ? 4 : 3);   // 3个及以上(按钮不算在内)，则显示下拉收齐箭头

    DQLogicMaintainModel *model = displayArray[indexPath.row];
    model.delegate = self;
    model.navCtl = self.navigationController;
    model.device = _device;
    model.projectid = _projectid;
    model.isOpen = ![_foldSections containsObject:@(section)];
    model.canExpend = [datas count] >= displayCount && indexPath.row == 0;    // 是否可以收起

    NSString *cellIdentifier = model.cellIdentifier;
    // 父类Cell接受类型，运行时Cell的真实类型为DQLogicServiceBaseModel的子类里各自指定的Cell
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

#pragma mark - Delegate
// 完成某些操作（如API调用）后须刷新数据
- (void)dq_needReloadData {
    [self requestSubData];
}

@end

//
//  DQDataCenterView.m
//  WebThings
//
//  Created by Heidi on 2017/9/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQDataCenterView.h"
#import "BJNoDataView.h"
#import "CKRefreshHeader.h"

#import "DQProjectSectionHeaderView.h"
#import "DQDataCenterListCell.h"

#import "AddProjectModel.h"

@implementation DQDataCenterView

- (id)initWithFrame:(CGRect)frame refreshSelector:(SEL)selector target:(id)tar {
    self = [super initWithFrame:frame];
    if (self) {
        
        _projectArray = [NSMutableArray arrayWithCapacity:0];
        _foldArray = [NSMutableArray arrayWithCapacity:0];
        
        _mainTable = [[UITableView alloc] initWithFrame:
                      CGRectMake(0, 0, frame.size.width, frame.size.height)
                                                  style:UITableViewStylePlain];
        _mainTable.dataSource = self;
        _mainTable.delegate = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_mainTable];
        
        if (selector) {
            CKRefreshHeader *header = [CKRefreshHeader headerWithRefreshingTarget:tar refreshingAction:selector];
            _mainTable.mj_header = header;
            [_mainTable.mj_header beginRefreshing];
        }
    }
    return self;
}

#pragma mark - 
/// 根据NSIndexPath获取设备
- (DeviceTypeModel *)getCurrentDeviceWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if ([_projectArray count] > section) {
        AddProjectModel *project = _projectArray[section];
        if ([project.devices count] > row) {
            return project.devices[row];
        }
    }
    return nil;
}

// 根据section判断是否Fold
- (BOOL)isFoldWithSection:(NSInteger)section {
    BOOL isFold = YES;
    if ([_foldArray count] > section) {
        isFold = [_foldArray[section] boolValue];
    }
    
    return isFold;
}

- (void)endRefresh {
    [_mainTable.mj_header endRefreshing];
}

/// 处理请求数据并展示
- (void)handleResultData:(NSArray *)result {
    [_projectArray removeAllObjects];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    // 只展示有设备的项目
    for (AddProjectModel *pro in result) {
        if ([pro.devices count] > 0) {
            [array addObject:pro];
        }
    }
    
    // 将报警告的设备排在每个项目的前面
    for (AddProjectModel *model in array) {
        NSMutableArray *devices = [NSMutableArray arrayWithArray:model.devices];
        NSComparator cmptr = ^(DeviceTypeModel *device1, DeviceTypeModel *device2)
        {
            if (device1.iswarn && !device2.iswarn)
            {
                return (NSComparisonResult)NSOrderedAscending;
            }
            else if (!device1.iswarn && device2.iswarn)
            {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            return (NSComparisonResult)NSOrderedSame;
        };
        
        [devices sortUsingComparator:cmptr];
        model.devices = devices;
    }
    
    [_projectArray addObjectsFromArray:array];
    [self handleUIDisplay];
}

- (void)handleUIDisplay {
    if ([_projectArray count] == 0) { //无数据
        [[BJNoDataView shareNoDataView]
         showCenterWithSuperView:self
         icon:@"ic_empty03"
         Frame:CGRectMake(0, 0, screenWidth, screenHeight) iconClicked:^{
            //图片点击回调
            if (self.refresh) {
                self.refresh(nil);
            }
        } WithText:@"暂时没有可查询的项目"];
        _mainTable.hidden  = YES;
        //        self.topCalendarFatherV.hidden = YES;
        return;
    } else {                           // 有数据
        // 默认将所有的Section设置为收起状态（isFold=YES）
        [_foldArray removeAllObjects];
        for (int i = 0; i < [_projectArray count]; i ++) {
            [_foldArray addObject:[NSNumber numberWithBool:YES]];
        }
        
        [_mainTable reloadData];
        //有数据
        [[BJNoDataView shareNoDataView] clear];
        _mainTable.hidden  = NO;
    }
}

- (NSArray *)dataArray {
    return [NSArray arrayWithArray:_projectArray];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_projectArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AddProjectModel *project = _projectArray[section];
    BOOL isFold = [self isFoldWithSection:section];
    NSInteger rows = [project.devices count];
    NSInteger min = 3;  // 最少显示3个设备，如需修改默认显示个数，改此数字即可
    if (isFold && rows > min) {
        rows = min;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddProjectModel *project = _projectArray[indexPath.section];
    CGFloat height = 100;
    if (indexPath.row == [project.devices count] - 1) {
        height = 90;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // 自定义的SectionHeader
    DQProjectSectionHeaderView *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DataCenterSectionView"];
    if (sectionHeader == nil) {
        sectionHeader = [[DQProjectSectionHeaderView alloc] initWithReuseIdentifier:@"DataCenterSectionView"];
    }
    [sectionHeader setProject:_projectArray[section]];
    sectionHeader.isFold = [self isFoldWithSection:section];
    sectionHeader.clicked = ^(id result) {
        [MobClick event:tableView.mj_header ? @"dc_more" : @"dc_search_more"];
        if ([result isKindOfClass:[NSNumber class]]) {
            if ([_foldArray count] > section) {
                [_foldArray replaceObjectAtIndex:section withObject:result];
            }
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"DataCenterCellIdentifier";
    DQDataCenterListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (cell == nil) {
        cell = [[DQDataCenterListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:CellIdentifer];
    }
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    AddProjectModel *project = _projectArray[section];
    NSInteger rows = [project.devices count];

    cell.isLast = indexPath.row == rows - 1;
    
    if ([_projectArray count] > section) {
        AddProjectModel *project = _projectArray[section];
        if ([project.devices count] > row) {
            [cell setDeviceModel:project.devices[row]];
            
            cell.deviceReportClicked = ^(id result) {
                if (self.reportClick) {
                    self.reportClick(project.devices[row]);
                }
            };
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddProjectModel *project = _projectArray[indexPath.section];
    DeviceTypeModel *device = [self getCurrentDeviceWithIndexPath:indexPath];
    if (self.deviceClick) {
        self.deviceClick(project, device);
    }
}

@end

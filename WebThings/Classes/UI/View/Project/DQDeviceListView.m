//
//  DQDeviceListView.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQDeviceListView.h"
#import "DQDeviceListCell.h"

@interface DQDeviceListView()
<UITableViewDelegate,
UITableViewDataSource,
MGSwipeTableCellDelegate>
{
    UILabel *_deviceNumberLabel;
    UIButton *_addDeviceBtn;
    NSIndexPath *_swipeIndexPath;
}
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *deviceListArr;
@end

@implementation DQDeviceListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
        [self addSubview:self.headerView];
        [self addSubview:self.mTableView];
    }
    return self;
}

- (void)configAdjustmentView
{
    //CEO没有权限修改，只能查看
    _addDeviceBtn.hidden = true;
}

#pragma mark - 下拉刷新
- (void)loadNewData:(CKRefreshHeader *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didConfigDeviceList)]) {
        [self.delegate didConfigDeviceList];
    }
}

- (void)reloadTableView:(NSMutableArray *)dataArr
{
    [self.mTableView.mj_header endRefreshing];
    [self.deviceListArr removeAllObjects];
    self.deviceListArr = dataArr;
    NSString *text = [NSString stringWithFormat:@"当前设备总数: %ld台",dataArr.count];
    _deviceNumberLabel.text = text;
    CGFloat width = [AppUtils textWidthSystemFontString:text height:12 font:_deviceNumberLabel.font];
    _deviceNumberLabel.width = width;
    
    [self.mTableView reloadData];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.deviceListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mTableView.width, 16)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DQDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceListIdentifier"];
    if (!cell) {
        cell = [[DQDeviceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeviceListIdentifier"];
    }
    BOOL isCEO = [self.delegate didExpandIsCEO];
    cell.delegate = isCEO ? self : nil;
    DeviceModel *model = [self.deviceListArr safeObjectAtIndex:indexPath.section];
    [cell configDeviceListWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedServiceStation:indexPath:)]) {
        [self.delegate didSelectedServiceStation:self indexPath:indexPath];
    }
}

#pragma mark -MGSwipeTableCellDelegate
-(nullable NSArray<UIView*>*) swipeTableCell:(nonnull MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
                               swipeSettings:(nonnull MGSwipeSettings*) swipeSettings expansionSettings:(nonnull MGSwipeExpansionSettings*) expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionBorder;
    if (direction == MGSwipeDirectionRightToLeft) {
        expansionSettings.buttonIndex = -1;
        expansionSettings.fillOnTrigger = true;
        
        NSIndexPath *indexPath = [self.mTableView indexPathForCell:cell];
        return [self createRightButtons:indexPath];
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
        if (index == 0) { //删除
            [self.delegate didSwipeOptaionStyle:self type:KDQDeviceListViewRemoveStyle indexPath:indexPath];

        } else { //编辑
            if(self.delegate && [self.delegate respondsToSelector:@selector(didSwipeOptaionStyle:type:indexPath:)]) {
                [self.delegate didSwipeOptaionStyle:self type:KDQDeviceListViewEditStyle indexPath:indexPath];
            }
        }
    }
    return false;
}

- (NSArray *)createRightButtons:(NSIndexPath *)indexPath
{
    DeviceModel *model = [self.deviceListArr safeObjectAtIndex:indexPath.section];
    if (model.detailstate == DQEnumStateCommunicateSubmitted || model.detailstate == DQEnumStateCommunicateRefuse) {
        NSMutableArray * result = [NSMutableArray array];
        UIColor *color = [UIColor colorWithHexString:@"#F3F4F5"];
        NSArray *images = @[ImageNamed(@"icon_delete"),ImageNamed(@"icon_CellEdit")];
        for (int i = 0; i < 2; ++i)
        {
            MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@"" icon:[images safeObjectAtIndex:i] backgroundColor:color padding:20];
            button.width = 80.f;
            [result safeAddObject:button];
        }
        return result;
    } else {
        //进入前期沟通单以后只能删除
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@"" icon:ImageNamed(@"icon_delete") backgroundColor:[UIColor colorWithHexString:@"#F3F4F5"] padding:20];
        button.width = 80.f;
        return @[button];
    }
    return nil;
}

- (NSMutableArray *)deviceListArr
{
    if (!_deviceListArr) {
        _deviceListArr = [NSMutableArray new];
    }
    return _deviceListArr;
}

- (UITableView *)mTableView
{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, self.headerView.bottom, self.width-20, self.height-self.headerView.bottom) style:UITableViewStylePlain];
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorColor = [UIColor clearColor];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.tableFooterView = [UIView new];
        _mTableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _mTableView.estimatedRowHeight = 0;
            _mTableView.estimatedSectionHeaderHeight = 0;
            _mTableView.estimatedSectionFooterHeight = 0;
            _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
         CKRefreshHeader *ckh = [CKRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
        _mTableView.mj_header = ckh;
        [_mTableView.mj_header beginRefreshing];
    }
    return _mTableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
        _headerView.backgroundColor = [UIColor  colorWithHexString:@"#F3F4F5"];
        _headerView.userInteractionEnabled = true;

        _deviceNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, 0, 12)];
        _deviceNumberLabel.text = @"";
        _deviceNumberLabel.font = [UIFont dq_semiboldSystemFontOfSize:12];
        _deviceNumberLabel.textAlignment = NSTextAlignmentLeft;
        [_headerView addSubview:_deviceNumberLabel];
        
        _addDeviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addDeviceBtn.frame = CGRectMake(_headerView.width-8-90, 5, 100, 35);
        _addDeviceBtn.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:12];
        [_addDeviceBtn setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
        [_addDeviceBtn setTitle:@"添加设备" forState:UIControlStateNormal];
        [_addDeviceBtn setImage:ImageNamed(@"ic_business_device") forState:UIControlStateNormal];
        _addDeviceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_addDeviceBtn.imageView.bounds.size.width, 0, _addDeviceBtn.imageView.width+6);
        _addDeviceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _addDeviceBtn.titleLabel.width, 0, -_addDeviceBtn.titleLabel.bounds.size.width);
        [_addDeviceBtn addTarget:self action:@selector(onNewDeviceClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_addDeviceBtn];
    }
    return _headerView;
}

- (void)onNewDeviceClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedNewDeviceVC:)]) {
        [self.delegate didSelectedNewDeviceVC:self];
    }
}

@end

//
//  DQTrainingRecodingController.m
//  WebThings
//
//  Created by winton on 2017/9/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//  培训记录

#import "DQTrainingRecodingController.h"
#import "DQTraingRecordingCell.h"
#import "DQDateInfoHerderView.h"
#import "DQTranrecordListModel.h"

@interface DQTrainingRecodingController ()
<UITableViewDelegate,
UITableViewDataSource,
MGSwipeTableCellDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation DQTrainingRecodingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"培训记录";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popViewController) image:ImageNamed(@"back")];

    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, screenWidth-20, screenHeight-0) style:UITableViewStyleGrouped];
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
        _mTableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        _mTableView.scrollIndicatorInsets = _mTableView.contentInset;
        
    }
    [self.view addSubview:_mTableView];
    
    [self fetchTrainingListAPI];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:true];
}
   
- (void)fetchTrainingListAPI
{
    [[DQProjectInterface sharedInstance] dq_getUserTranrecord:self.projectID success:^(id result) {
        if (result) {
            [self sortDateResult:result];
        }
    } failture:^(NSError *error) {

    }];
}

#pragma mark -UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rowArr = [self.dataList safeObjectAtIndex:section];
    return rowArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
         return 181.f;
    }
    return 189.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  60.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mTableView.width, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    
    NSArray *compleArr = [self.dataList safeObjectAtIndex:section];
    if (compleArr.count) {
        DQTranrecordListModel *model = [compleArr safeObjectAtIndex:0];
        DQDateInfoHerderView *infoView = [[DQDateInfoHerderView alloc] initWithFrame:CGRectMake(16, 16, 232, 28)];
        NSString *weekString = [NSDate getWeekDay:model.date];
        [infoView configDateInfoClick:model.date week:weekString number:model.traincount];
        [headerView addSubview:infoView];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DQTraingRecordingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TraingRecordingIdentifier"];
    if (!cell) {
        cell = [[DQTraingRecordingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TraingRecordingIdentifier"];
        if ([self isZuLin] && ![self isCEO]) {
            cell.delegate = self;
        } else {
            cell.delegate = nil;
        }
    }
    NSArray *rowArr = [self.dataList safeObjectAtIndex:indexPath.section];
    DQTranrecordListModel *model = [rowArr safeObjectAtIndex:indexPath.row];
    [cell configTraingRecordingModel:model];
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
        [self fetchRemoveTranrecordObjAPI:indexPath];
    }
    return false;
}

- (NSArray *)createRightButtons
{
    UIColor *color = [UIColor colorWithHexString:@"#F3F4F5"];
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"" icon:ImageNamed(@"icon_delete") backgroundColor:color padding:20];
    button.width = 80.f;
    return @[button];
}

- (void)fetchRemoveTranrecordObjAPI:(NSIndexPath *)indexPath
{
    NSArray *rowArr = [self.dataList safeObjectAtIndex:indexPath.section];
    DQTranrecordListModel *model = [rowArr safeObjectAtIndex:indexPath.row];
    [[DQProjectInterface sharedInstance] dq_getDeleteTranrecordById:self.projectID workerid:model.workerid trainid:model.trainid success:^(id result) {
        if (result) {
            NSMutableArray *rowArr = [self.dataList safeObjectAtIndex:indexPath.section];
            [rowArr safeRemoveObjectAtIndex:indexPath.row];
            [self.mTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } failture:^(NSError *error) {
        
    }];
}

- (void)sortDateResult:(NSMutableArray *)resultArr
{
    //排序处理
    NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:false]];
    NSArray *sortedArr = [resultArr sortedArrayUsingDescriptors:sortDesc];
    NSMutableArray *groupArray = [NSMutableArray new];
    NSMutableArray *currentArray = [NSMutableArray new];
    [currentArray safeAddObject:[sortedArr safeObjectAtIndex:0]];
    [groupArray safeAddObject:currentArray];
    //大于1，做动态处理
    if (sortedArr.count > 1) {
        for (int i = 1; i <sortedArr.count; i++) {
            NSMutableArray *preModeArr = [groupArray safeObjectAtIndex:groupArray.count-1];
            // 先取出组数组中，上一个数组的第一个元素
            DQTranrecordListModel *hdcDto = [preModeArr safeObjectAtIndex:0];
            //取出当前元素,根据createTime比较,如果相同则添加到同一个组中;如果不相同,说明不是同一个组的
            DQTranrecordListModel *hdcDtoTmp = [sortedArr safeObjectAtIndex:i];
            if ([self compareCreateTime:hdcDto.date secondTime:hdcDtoTmp.date]) {
                [currentArray safeAddObject:hdcDtoTmp];
            } else {
                // 如果不相同,说明有新的一组,那么创建一个元素数组,并添加到组数组groupArr
                currentArray = [NSMutableArray new];
                [currentArray safeAddObject:hdcDtoTmp];
                [groupArray safeAddObject:currentArray];
            }
        }
    }
    //遍历对每一组进行排序
    self.dataList = groupArray;
    [self.mTableView reloadData];
}

#pragma mark - 比较上传时间
-(BOOL)compareCreateTime:(NSString *)firstTime secondTime:(NSString *)secondTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *time1 = [NSDate stringForDate:firstTime format:@"yyyy-MM-dd"];
    NSString *timeStr1=[df stringFromDate:time1];
    
    NSDate *time2 = [NSDate stringForDate:secondTime format:@"yyyy-MM-dd"];
    NSString *timeStr2=[df stringFromDate:time2];
    
    if ([timeStr1 isEqualToString:timeStr2]) {
        return true;
    }else{
        return false;
    }
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray new];
    }
    return _dataList;
}

@end

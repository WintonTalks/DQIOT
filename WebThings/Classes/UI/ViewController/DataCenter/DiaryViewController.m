//
//  DiaryViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/6.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DiaryViewController.h"
#import "DiaryDetailCell.h"
#import "DailyModel.h"
#import "CheckModel.h"
#import "DQDeviceInterface.h"
#import "BRDatePickerView.h"
#import "BJNoDataView.h"

@interface DiaryViewController ()
<UITableViewDelegate,
UITableViewDataSource>
{
    NSString *_cdate;
    UIImageView *_readView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DailyModel *dm;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BJNoDataView *noDataView;

@end

@implementation DiaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备报告";
    //[EMINavigationController addAppBar:self];
    [self configUI];
}

- (void)configUI
{
    _cdate = [NSDate currentDateString];
    UIBarButtonItem *rightNav = [UIBarButtonItem itemWithTarget:self action:@selector(rightDailyNavClicked) image:ImageNamed(@"business_calendar_icon")];
    self.navigationItem.rightBarButtonItem = rightNav;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 64+8, screenWidth-16, screenHeight-72) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview:_tableView];
    [self fetchData];
}

//- (void)createTestData
//{
//    for (int i = 0; i < 10; i++) {
//        CheckModel *model = [CheckModel new];
//        model.checktype = @"dsfsdfsdfsdfdfsddfgfdgdfgfdfgdfgdfgdfg\nertetertetg353345353\nertert45463534dfgdg\nmtytty3434535##@@fsdfsdfdsfsdf";
//        model.checkstate =  (i%2==0) ? @"正常" : @"待修复";
//        [self.dataArray safeAddObject:model];
//    }
//}

- (void)rightDailyNavClicked
{
    MJWeakSelf;
    [MobClick event:@"diarycheck_rightclick"];
    NSString *date = [NSDate currentDateString];
    [BRDatePickerView showDatePickerWithTitle:@"请选择日报日期" dateType:UIDatePickerModeDate defaultSelValue:_cdate minDateStr:@"" maxDateStr:date isAutoSelect:true resultBlock:^(NSString *selectValue) {
        [weakSelf pickerdidDisappear:selectValue];
    }];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    return [model cellForHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 53.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 53)];
    headView.backgroundColor = [UIColor whiteColor];
  
    NSString *text = @"检查项目";
    UIFont *font = [UIFont dq_semiboldSystemFontOfSize:16];
    CGFloat width = [AppUtils textWidthSystemFontString:text height:21 font:font];
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake((headView.width-width)/2, (headView.height-21)/2, width, 21)];
    topLabel.text = text;
    topLabel.font = font;
    topLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:topLabel];

    _readView = [[UIImageView alloc] initWithImage:ImageNamed(@"icon_read")];
    _readView.frame = CGRectMake(headView.width-134/2, 0, 134/2, 102/2);
    [headView addSubview:_readView];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiaryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCellIdentifier"];
    if (!cell) {
        cell = [[DiaryDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailCellIdentifier"];
    }
    [cell setViewValuesWithModel:[self.dataArray safeObjectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - 日报接口
- (void)fetchData
{
    NSDictionary *params = @{@"userid" : @(self.baseUser.userid),
                             @"type" : [NSObject changeType:self.baseUser.type],
                             @"cdate" : _cdate,
                             @"deviceid":@(_deviceId),
                             @"usertype" : [NSObject changeType:self.baseUser.usertype]};
    
    [[DQDeviceInterface sharedInstance] dq_getDailyWIWithModel:params success:^(id result) {
        if (result) {
            NSMutableArray *dataArray = (NSMutableArray *)result;
            if (dataArray.count > 0) {
                self.tableView.hidden = false;
                [self.noDataView clear];
                self.dataArray = dataArray;
                [self.tableView reloadData];
                [self refreshView];
            } else {
                self.tableView.hidden = true;
                [self.noDataView showCenterWithSuperView:self.view icon:@"NoneDataBack"];
            }
        } else {
            self.tableView.hidden = true;
            [self.noDataView showCenterWithSuperView:self.view icon:@"NoneDataBack"];
        }
    } failture:^(NSError *error) {
        self.tableView.hidden = true;
        [self.noDataView showCenterWithSuperView:self.view icon:@"NoneDataBack"];
    }];
}

- (void)refreshView
{
    NSArray *arr = [_dm.workingtime componentsSeparatedByString:@":"];
    NSString *workTime = arr.count > 0 ? [arr safeObjectAtIndex:0] : @"0";
//    [self.bottomView configSafestate:_dm.safestate weight:_dm.deadweight workTime:workTime];

    if ([_dm.isread isEqualToString:@"已读"]) {
        _readView.hidden = false;
    }else{
        _readView.hidden = true;
        //标记已读
        [self fetchYiDu];
    }
}

/**
 标记已读
 */
- (void)fetchYiDu
{
    [[DQDeviceInterface sharedInstance] dq_getReadDailyWithModel:self.baseUser reportid:_dm.reportid success:^(id result) {
        
        
    } failture:^(NSError *error) {
    }];
}

#pragma mark -UI
- (BJNoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView  = [BJNoDataView shareNoDataView];
        [_noDataView setLabText:@"设备很安全，数据再等一等~"];
    }
    return _noDataView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)pickerdidDisappear:(NSString *)dateString
{
    _cdate = dateString;
    [self fetchData];
}

@end

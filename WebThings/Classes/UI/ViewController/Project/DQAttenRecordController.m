//
//  DQAttenRecordController.m
//  WebThings
//
//  Created by 孙文强 on 2017/10/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQAttenRecordController.h"
#import "ITDatePickerController.h"
#import "DQAttendanceListModel.h"
@interface DQAttenRecordController ()
<UITableViewDelegate,
UITableViewDataSource,
ITDatePickerControllerDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *dataListArray;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@end

@implementation DQAttenRecordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"考勤记录";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popViewController) image:ImageNamed(@"back")];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightDailyNavClick) image:ImageNamed(@"business_calendar_icon")];
    [self.view addSubview:self.mTableView];
    
    NSInteger year = [NSDate year];
    NSInteger month = [NSDate month];
    [self fetchAttenRecordAPI:[NSString stringWithFormat:@"%ld/%ld",year,month]];
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

- (void)fetchAttenRecordAPI:(NSString *)time
{
    [[DQProjectInterface sharedInstance] dq_getAttendanceRecord:self.projectid date:time success:^(id result) {
        self.dataListArray = result;
        [self.mTableView reloadData];
    } failture:^(NSError *error) {
        
    }];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightDailyNavClick
{
    ITDatePickerController *datePickerController = [[ITDatePickerController alloc] init];
    datePickerController.delegate = self;
    datePickerController.showToday = NO;
    datePickerController.defaultDate = self.startDate;  // Default date
    datePickerController.maximumDate = self.endDate;    // maxinum date
    [self presentViewController:datePickerController animated:true completion:nil];
}

#pragma mark -ITDatePickerControllerDelegate
- (void)datePickerController:(nonnull ITDatePickerController *)datePickerController
             didSelectedDate:(nonnull NSDate *)date
                  dateString:(nonnull NSString *)dateString
{
    [self fetchAttenRecordAPI:dateString];
}

#pragma mark -UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 66.f : 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        return nil;
    }
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 66)];
    infoView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    [infoView withRadius:18.f];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(9, 8, infoView.width-18, 50)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#4B8AF8"];
    [infoView addSubview:headView];
    
    UIFont *font = [UIFont dq_mediumSystemFontOfSize:16];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(43*screenWidth/375, 15, 32, 16)];
    nameLabel.text = @"姓名";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = font;
    [headView addSubview:nameLabel];
    
    NSString *numberText = @"打卡次数";
    CGFloat nbWidth = [AppUtils textWidthSystemFontString:numberText height:16 font:font];
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.right+71*screenWidth/375, nameLabel.top, nbWidth, 16)];
    numberLabel.text = numberText;
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = font;
    [headView addSubview:numberLabel];

    NSString *text = @"未打卡次数";
    CGFloat width = [AppUtils textWidthSystemFontString:text height:16 font:font];
    UILabel *noNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(headView.width-width-16, nameLabel.top, width, 16)];
    noNumberLabel.text = text;
    noNumberLabel.textColor = [UIColor whiteColor];
    noNumberLabel.font = font;
    [headView addSubview:noNumberLabel];
    return infoView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttenRecordIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AttenRecordIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        UIFont *font = [UIFont dq_mediumSystemFontOfSize:16];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45*screenWidth/375, 12, 80, 16)];
        nameLabel.font = font;
        nameLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.tag = 1200897;
        [cell.contentView addSubview:nameLabel];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(177*screenWidth/375, nameLabel.top, 25, nameLabel.height)];
        numberLabel.font = font;
        numberLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        numberLabel.tag = 1200899;
        [cell.contentView addSubview:numberLabel];
        
        UILabel *fixLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-79-31, nameLabel.top, 79, nameLabel.height)];
        fixLabel.font = font;
        fixLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        fixLabel.textAlignment = NSTextAlignmentCenter;
        fixLabel.tag = 1200900;
        [cell.contentView addSubview:fixLabel];
    }
    cell.contentView.backgroundColor = (indexPath.row%2 ==0) ? [UIColor colorWithHexString:@"#BAD4FF"] :[UIColor whiteColor];
    DQAttendanceListModel *model = [self.dataListArray safeObjectAtIndex:indexPath.row];
    UILabel *nameLabel = [cell.contentView viewWithTag:1200897];
    nameLabel.text = model.name;

    UILabel *numberLabel = [cell.contentView viewWithTag:1200899];
    numberLabel.text = [NSString stringWithFormat:@"%ld",model.checkincount];
    //
    UILabel *fixLabel = [cell.contentView viewWithTag:1200900];
    fixLabel.text = [NSString stringWithFormat:@"%ld",model.totalcount];

    return cell;
}

- (UITableView *)mTableView
{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, screenHeight-64) style:UITableViewStylePlain];
        _mTableView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorColor = [UIColor clearColor];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.tableFooterView = [UIView new];
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

- (NSMutableArray *)dataListArray
{
    if (!_dataListArray) {
        _dataListArray = [NSMutableArray new];
    }
    return _dataListArray;
}


@end

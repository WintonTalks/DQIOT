//
//  DQAttendanceController.m
//  WebThings
//
//  Created by 孙文强 on 2017/10/6.
//  Copyright © 2017年 machinsight. All rights reserved.
//  考勤

#import "DQAttendanceController.h"
#import "YXCalendarView.h"
#import "DQAttendanceModel.h"
@interface DQAttendanceController ()
{
    UIButton *_workTopBtn;
    UIButton *_workBottomBtn;
    UILabel *_bottomLabel;
    UILabel *_topLabel;
    UIView *_topView;
    UIView *_bottomView;
}
@property (nonatomic, strong) YXCalendarView *calendar;
@property (nonatomic, strong) UIView *workView;
@end

@implementation DQAttendanceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"考勤";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popViewController) image:ImageNamed(@"back")];
    _calendar = [[YXCalendarView alloc] initWithFrame:CGRectMake(0, 72, screenWidth, [YXCalendarView getMonthTotalHeight:[NSDate date] type:CalendarType_Week]) Date:[NSDate date] Type:CalendarType_Week];
    __weak typeof(_calendar) weakCalendar = _calendar;
    MJWeakSelf;
    _calendar.refreshH = ^(CGFloat viewH) {
        [UIView animateWithDuration:0.3 animations:^{
            weakCalendar.frame = CGRectMake(0, 72, screenWidth, viewH);
        }];
        
    };
    _calendar.sendSelectDate = ^(NSDate *selDate) {
        [weakSelf fetchAttendanceAPI:[NSDate dateForString:selDate format:@"yyyy/MM/dd"]];
    };
    [self.view addSubview:_calendar];
    [self addWorkInfoView];
    [self fetchAttendanceAPI:[NSDate dateForString:[NSDate date] format:@"yyyy/MM/dd"]];
}

- (void)addWorkInfoView
{
    _workView = [[UIView alloc] initWithFrame:CGRectMake(0, _calendar.bottom+8, screenWidth, 130)];
    _workView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_workView];

    _topView = [[UIView alloc] initWithFrame:CGRectMake(16, 16, 8, 8)];
    _topView.backgroundColor = [UIColor colorWithHexString:@"#4B8AF8"];
    [_topView withRadius:4];
    [_workView addSubview:_topView];

    _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(_topView.right+16, 9, 160, 12)];
    _topLabel.textAlignment = NSTextAlignmentLeft;
    _topLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _topLabel.font = [UIFont dq_mediumSystemFontOfSize:12];
    [_workView addSubview:_topLabel];

    _workTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _workTopBtn.frame = CGRectMake(_topLabel.left, _topLabel.bottom+8, 76, 12);
    _workTopBtn.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:12];
    [_workTopBtn setTitleColor:[UIColor colorWithHexString:@"#BAB9B9"] forState:UIControlStateNormal];
    [_workTopBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -_workTopBtn.titleLabel.width)];
    [_workTopBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_workTopBtn.imageView.width+16, 0, 0)];
    [_workView addSubview:_workTopBtn];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(_topView.left, _workTopBtn.bottom+34, 8, 8)];
    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#4B8AF8"];
    [_bottomView withRadius:4];
    [_workView addSubview:_bottomView];

    _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bottomView.right+16, _bottomView.top, 160, 12)];
    _bottomLabel.textAlignment = NSTextAlignmentLeft;
    _bottomLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _bottomLabel.font = [UIFont dq_mediumSystemFontOfSize:12];
    [_workView addSubview:_bottomLabel];

    _workBottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _workBottomBtn.frame = CGRectMake(_bottomLabel.left, _bottomLabel.bottom+8, 76, 12);
    _workBottomBtn.titleLabel.font = [UIFont dq_mediumSystemFontOfSize:12];
    [_workBottomBtn setTitleColor:[UIColor colorWithHexString:@"#BAB9B9"] forState:UIControlStateNormal];
    [_workBottomBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -_workBottomBtn.titleLabel.width)];
    [_workBottomBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_workBottomBtn.imageView.width+16, 0, 0)];
    [_workView addSubview:_workBottomBtn];
    
    _topView.hidden = true;
    _bottomView.hidden = true;
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchAttendanceAPI:(NSString *)dateString
{
    [[DQProjectInterface sharedInstance] dq_getCheckUserAttendance:self.projectid workerid:self.workerid date:dateString success:^(id result) {
        if (result) {
            NSMutableArray *dataArray = result;
            [self configAttendanceModel:[dataArray safeObjectAtIndex:0]];
        }
    } failture:^(NSError *error) {
        
    }];
}

- (void)configAttendanceModel:(DQAttendanceModel *)model
{
    if (!model) {
        return;
    }
    _topView.hidden = false;
    _bottomView.hidden = false;
    _topLabel.text = [NSString stringWithFormat:@"打卡时间：%@",model.time];
    _bottomLabel.text = [NSString stringWithFormat:@"打卡时间：%@",model.time];
    NSString *location = [NSString stringWithFormat:@"%@",model.location];
    
    [_workTopBtn setTitle:location forState:UIControlStateNormal];
    [_workTopBtn setImage:ImageNamed(@"icon_Map") forState:UIControlStateNormal];
    [_workBottomBtn setTitle:location forState:UIControlStateNormal];
    [_workBottomBtn setImage:ImageNamed(@"icon_Map") forState:UIControlStateNormal];
}

@end

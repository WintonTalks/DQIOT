//
//  YXCalendarView.m
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import "YXCalendarView.h"

static CGFloat const yearMonthH = 30;   //年月高度
static CGFloat const weeksH = 30;       //周高度

@interface YXCalendarView ()

@property (nonatomic, strong) UILabel *yearMonthL;      //年月label
@property (nonatomic, strong) UIButton *topButton;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UIScrollView *scrollV;    //scrollview
@property (nonatomic, assign) CalendarType type;        //选择类型
@property (nonatomic, strong) NSDate *currentDate;      //当前月份
@property (nonatomic, strong) NSDate *selectDate;       //选中日期
@property (nonatomic, strong) NSDate *tmpCurrentDate;   //记录上下滑动日期

@property (nonatomic, strong) YXMonthView *leftView;    //左侧日历
@property (nonatomic, strong) YXMonthView *middleView;  //中间日历
@property (nonatomic, strong) YXMonthView *rightView;   //右侧日历

@end

@implementation YXCalendarView

- (instancetype)initWithFrame:(CGRect)frame Date:(NSDate *)date Type:(CalendarType)type {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _type = type;
        _currentDate = date;
        _selectDate = date;
        if (type == CalendarType_Week) {
            _tmpCurrentDate = date;
            _currentDate = [[YXDateHelpObject manager] getLastdayOfTheWeek:date];
        }
        [self settingViews];
        [self addSwipes];
    }
    return self;
}

- (void)dealloc
{
    [_scrollV removeObserver:self forKeyPath:@"contentOffset"];
}

//MARK: - setMethod

-(void)setType:(CalendarType)type {
    _type = type;
    
    _middleView.type = type;
    _leftView.type = type;
    _rightView.type = type;
    
    if (type == CalendarType_Week) {
        //周
        if (_refreshH) {
            if (self.height == dayCellH + yearMonthH + weeksH) {
                return;
            }
            _refreshH(dayCellH + yearMonthH + weeksH+25+17);
            __weak typeof(_scrollV) weakScroll = _scrollV;
            [UIView animateWithDuration:0.3 animations:^{
                weakScroll.frame = CGRectMake(0, /*yearMonthH + weeksH+25*/_yearMonthL.bottom+weeksH+10, self.width, dayCellH);
            }];
            
        }
    } else {
        //月
        if (_refreshH) {
            CGFloat viewH = [YXCalendarView getMonthTotalHeight:_currentDate type:CalendarType_Month];
            if (viewH == self.height) {
                return;
            }
            _refreshH(viewH);
            __weak typeof(_scrollV) weakScroll = _scrollV;
            [UIView animateWithDuration:0.3 animations:^{
                weakScroll.frame = CGRectMake(0, yearMonthH + weeksH, self.width, viewH - yearMonthH - weeksH);
            }];
        }
    }
    
}

//MARK: - otherMethod
+ (CGFloat)getMonthTotalHeight:(NSDate *)date type:(CalendarType)type {
    if (type == CalendarType_Week) {
        return dayCellH + yearMonthH + weeksH+25+17;
    } else {
        NSInteger rows = [[YXDateHelpObject manager] getRows:date];
        return yearMonthH + weeksH + rows * dayCellH;
    }
    
}

- (void)slideView:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        _tmpCurrentDate = _currentDate.copy;
        //上滑
        if (_type == CalendarType_Week) {
            return;
        }
        if (_selectDate && [[YXDateHelpObject manager] checkSameMonth:_selectDate AnotherMonth:_currentDate]) {
            _currentDate = [[YXDateHelpObject manager] getLastdayOfTheWeek:_selectDate];
            _middleView.currentDate = _currentDate;
            _leftView.currentDate = [[YXDateHelpObject manager]getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
            _rightView.currentDate = [[YXDateHelpObject manager]getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
        } else {
            //默认第一周
            _currentDate = [[YXDateHelpObject manager] getLastdayOfTheWeek:[[YXDateHelpObject manager] GetFirstDayOfMonth:_currentDate]];
            _middleView.currentDate = _currentDate;
            _leftView.currentDate = [[YXDateHelpObject manager]getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
            _rightView.currentDate = [[YXDateHelpObject manager]getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
            
        }
        self.type = CalendarType_Week;
    } else if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        //下滑
        if (_type == CalendarType_Month) {
            return;
        }
        //选中最后一行再上滑需要这个判断
        if (![[YXDateHelpObject manager] checkSameMonth:_tmpCurrentDate AnotherMonth:_currentDate]) {
            _currentDate = _tmpCurrentDate.copy;
        }
        _type = CalendarType_Month;
        [self setData];
        [self scrollToCenter];
    }
    
}

//MARK: - setViewMethod
- (void)addSwipes
{
    UISwipeGestureRecognizer *swipUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideView:)];
    [swipUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:swipUp];
    
    UISwipeGestureRecognizer *swipDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideView:)];
    [swipDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self addGestureRecognizer:swipDown];
    
}

- (void)settingViews
{
    [self settingHeadLabel];
    [self settingScrollView];
    [self addObserver];
}

- (void)settingHeadLabel
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    [self addSubview:lineView];
    
    CGFloat width = 80;
    _yearMonthL = [[UILabel alloc] initWithFrame:CGRectMake((self.width-width)/2, 15, width, yearMonthH)];
    _yearMonthL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:_currentDate];
    _yearMonthL.textAlignment = NSTextAlignmentCenter;
    _yearMonthL.font = [UIFont dq_mediumSystemFontOfSize:16];
    [self addSubview:_yearMonthL];
    
    _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _topButton.frame = CGRectMake(_yearMonthL.left-16-4, 24, 16, 10);
    [_topButton setImage:ImageNamed(@"ic_up") forState:UIControlStateNormal];
    _topButton.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [_topButton addTarget:self action:@selector(onTopScrollClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_topButton];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(_yearMonthL.right+4, 24, 16, 10);
    [_nextButton setImage:ImageNamed(@"ic_up") forState:UIControlStateNormal];
    _nextButton.transform = CGAffineTransformMakeRotation(M_PI_2);
    [_nextButton addTarget:self action:@selector(onNextScrollClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextButton];
    
    NSArray *weekdays = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    CGFloat weekdayW = self.width/7;
    for (int i = 0; i < 7; i++) {
        UILabel *weekL = [[UILabel alloc] initWithFrame:CGRectMake(i*weekdayW, _yearMonthL.bottom, weekdayW, weeksH)];
        weekL.textAlignment = NSTextAlignmentCenter;
        weekL.font = [UIFont dq_mediumSystemFontOfSize:14];
        weekL.text = weekdays[i];
        [self addSubview:weekL];
    }
}

- (void)onTopScrollClicked
{
    //上周
    _middleView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
    _middleView.selectDate = _selectDate;
    _rightView.currentDate = _currentDate;
    _rightView.selectDate = _selectDate;
    _currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
    _tmpCurrentDate = _currentDate.copy;
    _leftView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
    _leftView.selectDate = _selectDate;
    _yearMonthL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:_currentDate];

    [self scrollToCenter];
    self.type = _type;
}

- (void)onNextScrollClicked
{
    //下周
    _middleView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
    _middleView.selectDate = _selectDate;
    _leftView.currentDate = _currentDate;
    _leftView.selectDate = _selectDate;
    _currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
    _tmpCurrentDate = _currentDate.copy;
    _rightView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
    _rightView.selectDate = _selectDate;
    _yearMonthL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:_currentDate];

    [self scrollToCenter];
    self.type = _type;
}

- (void)settingScrollView
{
    CGFloat top = _yearMonthL.bottom+weeksH+10;
    _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, top, self.width, self.height-top)];
    _scrollV.contentSize = CGSizeMake(self.width * 3, 0);
    _scrollV.pagingEnabled = true;
    _scrollV.showsHorizontalScrollIndicator = false;
    _scrollV.showsVerticalScrollIndicator = false;
    [self addSubview:_scrollV];
    
    __weak typeof(self) weakSelf = self;
    CGFloat height = dayCellH;
    _leftView = [[YXMonthView alloc] initWithFrame:CGRectMake(0, 0, self.width, height) Date:
                 _type == CalendarType_Month ? [[YXDateHelpObject manager] getPreviousMonth:_currentDate] :[[YXDateHelpObject manager]getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2]];
    _leftView.type = _type;
    _leftView.selectDate = _selectDate;
    
    _middleView = [[YXMonthView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, height) Date:_currentDate];
    _middleView.type = _type;
    _middleView.selectDate = _selectDate;
    _middleView.sendSelectDate = ^(NSDate *selDate) {
        weakSelf.selectDate = selDate;
        if (weakSelf.sendSelectDate) {
            weakSelf.sendSelectDate(selDate);
        }
        [weakSelf setData];
    };
    
    _rightView = [[YXMonthView alloc] initWithFrame:CGRectMake(self.width * 2, 0, self.width, height) Date:
                  _type == CalendarType_Month ? [[YXDateHelpObject manager] getNextMonth:_currentDate] : [[YXDateHelpObject manager]getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2]];
    _rightView.type = _type;
    _rightView.selectDate = _selectDate;
    
    [_scrollV addSubview:_leftView];
    [_scrollV addSubview:_middleView];
    [_scrollV addSubview:_rightView];
    
    [self scrollToCenter];
}

- (void)setData {
    
    if (_type == CalendarType_Month) {
        _middleView.currentDate = _currentDate;
        _middleView.selectDate = _selectDate;
        _leftView.currentDate = [[YXDateHelpObject manager] getPreviousMonth:_currentDate];
        _leftView.selectDate = _selectDate;
        _rightView.currentDate = [[YXDateHelpObject manager] getNextMonth:_currentDate];
        _rightView.selectDate = _selectDate;
    } else {
        _middleView.currentDate = _currentDate;
        _middleView.selectDate = _selectDate;
        _leftView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
        _leftView.selectDate = _selectDate;
        _rightView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
        _rightView.selectDate = _selectDate;
    }
    self.type = _type;
}

//MARK: - kvo
- (void)addObserver
{
    [_scrollV addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self monitorScroll];
    }
    
}

- (void)monitorScroll {
    
    if (_scrollV.contentOffset.x > 2*self.width -1) {
        if (_type == CalendarType_Month) {
            //左滑,下个月
            _middleView.currentDate = [[YXDateHelpObject manager] getNextMonth:_currentDate];
            _middleView.selectDate = _selectDate;
            _leftView.currentDate = _currentDate;
            _leftView.selectDate = _selectDate;
            _currentDate = [[YXDateHelpObject manager] getNextMonth:_currentDate];
            _rightView.currentDate = [[YXDateHelpObject manager] getNextMonth:_currentDate];
            _rightView.selectDate = _selectDate;
            _yearMonthL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:_currentDate];
        } else {
            //下周
            _middleView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
            _middleView.selectDate = _selectDate;
            _leftView.currentDate = _currentDate;
            _leftView.selectDate = _selectDate;
            _currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
            _tmpCurrentDate = _currentDate.copy;
            _rightView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
            _rightView.selectDate = _selectDate;
            _yearMonthL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:_currentDate];
        }
        
        [self scrollToCenter];
        self.type = _type;
        
    } else if (_scrollV.contentOffset.x < 1) {
        
        if (_type == CalendarType_Month) {
            //右滑,上个月
            _middleView.currentDate = [[YXDateHelpObject manager] getPreviousMonth:_currentDate];
            _middleView.selectDate = _selectDate;
            _rightView.currentDate = _currentDate;
            _rightView.selectDate = _selectDate;
            _currentDate = [[YXDateHelpObject manager] getPreviousMonth:_currentDate];
            _leftView.currentDate = [[YXDateHelpObject manager] getPreviousMonth:_currentDate];
            _leftView.selectDate = _selectDate;
            _yearMonthL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:_currentDate];
        } else {
            //上周
            _middleView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
            _middleView.selectDate = _selectDate;
            _rightView.currentDate = _currentDate;
            _rightView.selectDate = _selectDate;
            _currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
            _tmpCurrentDate = _currentDate.copy;
            _leftView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
            _leftView.selectDate = _selectDate;
            _yearMonthL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:_currentDate];
        }
        
        [self scrollToCenter];
        self.type = _type;
        
    }
    
}

//MARK: - scrollViewMethod
- (void)scrollToCenter
{
    _scrollV.contentOffset = CGPointMake(self.width, 0);
    //可以在这边进行网络请求获取事件日期数组等,记得取消上个未完成的网络请求
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%d",[[YXDateHelpObject manager] getStrFromDateFormat:@"MM" Date:_currentDate],1 + arc4random()%28];
        [array addObject:dateStr];
    }
    
    _middleView.eventArray = array;
}

@end

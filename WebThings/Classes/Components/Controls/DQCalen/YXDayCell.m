//
//  YXDayCell.m
//  Calendar
//

#import "YXDayCell.h"

@interface YXDayCell ()

@property (strong, nonatomic) UILabel *dayLabel;     //日期
@property (nonatomic, strong) UIView *shadowView;
@end

@implementation YXDayCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake((self.contentView.width-dayCellH)/2, (self.contentView.height-dayCellH)/2, dayCellH, dayCellH)];
        _shadowView.backgroundColor = RGB_Color(194, 212, 247, 1);
        [_shadowView withRadius:(dayCellH)/2];
//        _shadowView.layer.shadowColor = RGB_Color(194, 212, 247, 1).CGColor;
//        _shadowView.layer.shadowOffset = CGSizeMake(0,dayCellH);
//        _shadowView.layer.shadowOpacity = 1.0;
//        _shadowView.layer.shadowRadius = 2;
        _shadowView.hidden = true;
        [self.contentView addSubview:_shadowView];
        
        CGFloat height = dayCellH-2;
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.contentView.width-height)/2, (self.contentView.height-height)/2, height, height)];
        _dayLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
        _dayLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        [_dayLabel withRadius:height / 2];
        [self.contentView addSubview:_dayLabel];
    }
    return self;
}

- (void)setCellDate:(NSDate *)cellDate {
    _cellDate = cellDate;
    if (_type == CalendarType_Week) {
        [self showDateFunction];
    } else {
        if ([[YXDateHelpObject manager] checkSameMonth:_cellDate AnotherMonth:_currentDate]) {
            [self showDateFunction];
        } else {
            [self showSpaceFunction];
        }
    }
}

- (void)showSpaceFunction {
    self.userInteractionEnabled = NO;
    _dayLabel.text = @"";
    _dayLabel.backgroundColor = [UIColor clearColor];
    _dayLabel.layer.borderWidth = 0;
    _dayLabel.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void)showDateFunction {
    
    self.userInteractionEnabled = YES;
    
    _dayLabel.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"d" Date:_cellDate];
    if ([[YXDateHelpObject manager] isSameDate:_cellDate AnotherDate:[NSDate date]]) {
//        _dayL.layer.borderWidth = 1.5;
        _dayLabel.layer.borderColor = [UIColor colorWithHexString:COLOR_BLUE].CGColor;
    } else {
        _dayLabel.layer.borderWidth = 0;
        _dayLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }
    if (_selectDate) {
        if ([[YXDateHelpObject manager] isSameDate:_cellDate AnotherDate:_selectDate]) {
            _dayLabel.backgroundColor = [UIColor colorWithHexString:COLOR_BLUE];
            _dayLabel.textColor = [UIColor whiteColor];
            _shadowView.hidden = false;

        } else {
            _dayLabel.backgroundColor = [UIColor clearColor];
            _dayLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];;
            _shadowView.hidden = true;
        }
        
    }
}

@end

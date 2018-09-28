//
//  BRDatePickerView.m
//  PickerDemo
//
//  Created by 孙文强 on 2017/9/6.
//  Copyright © 2017年 Happy Day. All rights reserved.
//

#import "BRDatePickerView.h"

@interface BRDatePickerView ()
{
    UIDatePickerMode _datePickerMode;
    NSString *_title;
    NSString *_minDateStr;
    NSString *_maxDateStr;
    BRDateResultBlock _resultBlock;
    NSString *_selectValue;
    BOOL _isAutoSelect;  // 是否开启自动选择
}
// 时间选择器(默认大小: 320px × 216px)
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation BRDatePickerView

#pragma mark - 显示时间选择器
+ (void)showDatePickerWithTitle:(NSString *)title dateType:(UIDatePickerMode)type defaultSelValue:(NSString *)defaultSelValue minDateStr:(NSString *)minDateStr maxDateStr:(NSString *)maxDateStr isAutoSelect:(BOOL)isAutoSelect resultBlock:(BRDateResultBlock)resultBlock {
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]initWithTitle:title dateType:type defaultSelValue:defaultSelValue minDateStr:(NSString *)minDateStr maxDateStr:(NSString *)maxDateStr isAutoSelect:isAutoSelect resultBlock:resultBlock];
    [datePickerView showWithAnimation:YES];
}

#pragma mark - 初始化时间选择器
- (instancetype)initWithTitle:(NSString *)title
                     dateType:(UIDatePickerMode)type
              defaultSelValue:(NSString *)defaultSelValue
                   minDateStr:(NSString *)minDateStr
                   maxDateStr:(NSString *)maxDateStr
                 isAutoSelect:(BOOL)isAutoSelect
                  resultBlock:(BRDateResultBlock)resultBlock
{
    if (self = [super init]) {
        _datePickerMode = type;
        _title = title;
        _minDateStr = minDateStr;
        _maxDateStr = maxDateStr;
        _isAutoSelect = isAutoSelect;
        _resultBlock = resultBlock;
        
        // 默认选中今天的日期
        if (defaultSelValue.length > 0) {
            _selectValue = defaultSelValue;
        } else {
            _selectValue = [self toStringWithDate:[NSDate date]];
        }
        
        [self initUI];
    }
    return self;
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = _title;
    // 添加时间选择器
    [self.alertView addSubview:self.datePicker];
}

#pragma mark - 时间选择器
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, SCREEN_WIDTH, kDatePicHeight)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = _datePickerMode;

        _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CHS_CN"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        if (_datePickerMode == UIDatePickerModeTime) {
            [formatter setDateFormat:@"HH:mm"];
        } else {
            [formatter setDateFormat:@"yyyy/MM/dd"];
        }
        // 设置时间范围
        if (_minDateStr) {
            NSDate *minDate = [formatter dateFromString:_minDateStr];
            _datePicker.minimumDate = minDate;
        }
        if (_maxDateStr) {
            NSDate *maxDate = [formatter dateFromString:_maxDateStr];
            _datePicker.maximumDate = maxDate;
        }
        
        // 把当前时间赋值给 _datePicker
        if (_selectValue.length > 0 && _datePickerMode == UIDatePickerModeDate) {
            NSDate *date = [NSDate stringForDate:_selectValue format:@"yyyy/MM/dd"];
            [_datePicker setDate:date animated:YES];
        } else {
            NSDate *date = [NSDate stringForDate:_selectValue format:@"HH:mm"];
            [_datePicker setDate:date animated:YES];
        }
        
        // 滚动改变值的响应事件
        [_datePicker addTarget:self action:@selector(didSelectValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = screenHeight;
        self.alertView.frame = rect;
        
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= kDatePicHeight + kTopViewHeight;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += kDatePicHeight + kTopViewHeight;
        self.alertView.frame = rect;
        
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.leftBtn removeFromSuperview];
        [self.rightBtn removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.lineView removeFromSuperview];
        [self.topView removeFromSuperview];
        [self.datePicker removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
        self.datePicker = nil;
        self.alertView = nil;
        self.backgroundView = nil;
        _minDateStr = nil;
        _maxDateStr = nil;
    }];
}

#pragma mark - 时间选择器的滚动响应事件
- (void)didSelectValueChanged:(UIDatePicker *)sender {
    _selectValue = [self toStringWithDate:sender.date];
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    [self dismissWithAnimation:YES];
    
    if (_resultBlock) {
        _resultBlock(_selectValue);
    }
}

#pragma mark - 格式转换：NSDate --> NSString
- (NSString *)toStringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (_datePickerMode) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

#pragma mark - 格式转换：NSDate <-- NSString
- (NSDate *)toDateWithDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (_datePickerMode) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    
    return destDate;
}

+ (void)hidePickerView
{
//    [BRDatePickerView dismissWithAnimation:YES];
}

@end

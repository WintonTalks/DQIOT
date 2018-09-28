//
//  EMI_MDDatePickerAlert.m
//  WebThings
//
//  Created by machinsight on 2017/6/20.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMI_MDDatePickerAlert.h"
#import "MDButton.h"
#import "MDDatePickerDialog.h"
#import "UIView+MDExtension.h"
#import "UIFontHelper.h"
#import "MDDeviceHelper.h"
#import "MDCalendar.h"
#import "MDCalendarDateHeader.h"
#import "EMICardView.h"
#define kCalendarHeaderHeight 119
#define kCalendarActionBarHeight 31.3
@interface EMI_MDDatePickerAlert()
@property(strong, nonatomic) UIFont *buttonFont UI_APPEARANCE_SELECTOR;
@property(nonatomic) NSDateFormatter *dateFormatter;
@property(nonatomic) MDCalendarDateHeader *header;
@property(nonatomic) MDCalendar *calendar;

@property(nonatomic) MDButton *buttonOk;
@property(nonatomic) MDButton *buttonCancel;

@property(nonatomic) NSString *okTitle;
@property (nonatomic) NSString *cancelTitle;
@end
@implementation EMI_MDDatePickerAlert {
    UIView *popupHolder;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        popupHolder = [[EMICardView alloc] init];
        
        [popupHolder
         setFrame:CGRectMake(0, 0, screenWidth-16-14-26-60,
                             380)];
        
        _header = [[MDCalendarDateHeader alloc]
                   initWithFrame:CGRectMake(0, 0, popupHolder.mdWidth,
                                            kCalendarHeaderHeight)];
        [popupHolder addSubview:_header];
        
        MDCalendar *calendar = [[MDCalendar alloc]
                                initWithFrame:CGRectMake(0, kCalendarHeaderHeight, popupHolder.mdWidth,
                                                         popupHolder.mdHeight - kCalendarHeaderHeight -
                                                         kCalendarActionBarHeight)];
        calendar.dateHeader = _header;
        [popupHolder addSubview:calendar];
        self.calendar = calendar;
        self.calendar.theme = MDCalendarThemeLight;
        
        [self setBackgroundColor:self.calendar.backgroundColor];
        
        _buttonFont = [UIFontHelper robotoFontWithName:@"DroidSansFallback" size:13];
        
        MDButton *buttonOk = [[MDButton alloc]
                              initWithFrame:CGRectMake(
                                                       popupHolder.mdWidth - 4 * kCalendarActionBarHeight+5,
                                                       popupHolder.mdHeight - kCalendarActionBarHeight,
                                                       2 * kCalendarActionBarHeight * 3.0 / 4.0,
                                                       kCalendarActionBarHeight * 3.0 / 4.0)
                              type:MDButtonTypeFlat
                              rippleColor:[UIColor colorWithHexString:@"#417EE8" alpha:0.16]];
        
        
        [buttonOk setTitleColor:[UIColor colorWithHexString:@"#3F7FE8"] forState:normal];
        [buttonOk addTarget:self
                     action:@selector(didSelected)
           forControlEvents:UIControlEventTouchUpInside];
        [buttonOk.titleLabel setFont:_buttonFont];
        [popupHolder addSubview:buttonOk];
        self.buttonOk = buttonOk;
        
        MDButton *buttonCancel = [[MDButton alloc]
                                  initWithFrame:CGRectMake(
                                                           popupHolder.mdWidth - 2 * kCalendarActionBarHeight+5,
                                                           popupHolder.mdHeight - kCalendarActionBarHeight,
                                                           2 * kCalendarActionBarHeight * 3.0 / 4.0,
                                                           kCalendarActionBarHeight * 3.0 / 4.0)
                                  type:MDButtonTypeFlat
                                  rippleColor:[UIColor colorWithHexString:@"#417EE8" alpha:0.16]];
        [buttonCancel setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:normal];
        [buttonCancel addTarget:self
                         action:@selector(didCancelled)
               forControlEvents:UIControlEventTouchUpInside];
        [buttonCancel.titleLabel setFont:_buttonFont];
        [popupHolder addSubview:buttonCancel];
        self.buttonCancel = buttonCancel;
        
        [self setTitleOk:@"确认" andTitleCancel:@"取消"];
        
//        [self.buttonCancel
//         setTitleColor:self.calendar.titleColors[@(MDCalendarCellStateButton)]
//         forState:UIControlStateNormal];
//        [self.buttonOk
//         setTitleColor:self.calendar.titleColors[@(MDCalendarCellStateButton)]
//         forState:UIControlStateNormal];
//        [self addTarget:self
//                 action:@selector(btnClick:)
//       forControlEvents:UIControlEventTouchUpInside];
        
        [self
         setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:popupHolder];
        self.hidden = YES;
    }
    return self;
}

-(NSDate*)selectedDate;
{
    return self.calendar.selectedDate;
}

-(void)setSelectedDate:(NSDate *)selectedDate;
{
    self.calendar.selectedDate = selectedDate;
}

-(void)setTitleOk: (nonnull NSString *) okTitle andTitleCancel: (nonnull NSString *) cancelTitle {
    _okTitle =  okTitle;
    _cancelTitle = cancelTitle;
    
    [_buttonOk setTitle:_okTitle forState:normal];
    [_buttonCancel setTitle:_cancelTitle forState:normal];
}

//- (void)btnClick:(id)sender {
//    [self disShow];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)showwithFatherV:(UIView *)fatherV andSelfFrame:(CGRect)selfFrame {
    [self setFrame:selfFrame];
    _fatherV = fatherV;
    [fatherV addSubview:self];
    self.hidden = NO;
}

- (void)calendar:(MDCalendar *)calendar didSelectDate:(NSDate *)date {
    _dateFormatter.dateFormat = @"dd-MM-yyyy";
}

- (void)didSelected {
    if (_delegate &&
        [_delegate
         respondsToSelector:@selector(datePickerDialogDidSelectDate:withSelf:)]) {
            [_delegate datePickerDialogDidSelectDate:_calendar.selectedDate withSelf:self];
        }
   [self disShow];
}

- (void)didCancelled {
    [self disShow];
}

- (void)disShow{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.hidden = YES;
        [self removeFromSuperview];
        _fatherV = nil;
    });
    
    if (_delegate &&
        [_delegate
         respondsToSelector:@selector(pickerdidDisappear)]) {
            [_delegate pickerdidDisappear];
        }
}

- (NSDate*)minimumDate {
    return self.calendar.minimumDate;
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    self.calendar.minimumDate = minimumDate;
}

@end

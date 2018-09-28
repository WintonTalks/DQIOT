//
//  DQDateSegmentView.m
//  WebThings
//
//  Created by Eugene on 10/25/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQDateSegmentView.h"

@interface DQDateSegmentView ()

@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UILabel *datelabel;
@property (nonatomic, strong) UILabel *weekLabel;

@end

@implementation DQDateSegmentView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDateSegmentView];
    }
    return self;
}

- (void)initDateSegmentView {
    
    /** view设置 */
     
    self.backgroundColor = [UIColor colorWithHexString:@"#2E2E2E"];
    self.layer.cornerRadius = 14;
    self.layer.masksToBounds = YES;
    
    /** 左 白点view */
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2-5, 10, 10)];
    pointView.backgroundColor = [UIColor whiteColor];
    pointView.layer.cornerRadius = 5;
    pointView.layer.masksToBounds = YES;
    [self addSubview:pointView];
    _pointView = pointView;
    
    _datelabel = [[UILabel alloc] init];
    _datelabel.frame = CGRectMake(CGRectGetMaxX(pointView.frame)+17, 0, 60, self.frame.size.height);
    _datelabel.textColor = [UIColor whiteColor];
    _datelabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
    [self addSubview:_datelabel];
    
    _weekLabel = [[UILabel alloc] init];
    _weekLabel.frame = CGRectMake(CGRectGetMaxX(_datelabel.frame)+10, 0, 40, self.frame.size.height);
    _weekLabel.textColor = [UIColor colorWithHexString:@"#BAB9B9"];
    _weekLabel.font = [UIFont dq_semiboldSystemFontOfSize:12];
    [self addSubview:_weekLabel];
}

- (void)setDateString:(NSString *)dateString {
    _dateString = dateString;
    
    NSString *dateStr = [self getFormattterDateString:dateString];
    _datelabel.text = [NSDate getPointerTimeStringWithFormat:@"MM月dd日" originString:dateStr orignFormat:@"yyyy/MM/dd"];
    _weekLabel.text = [NSDate getWeekDay:dateStr];
    
    // 按钮宽度根据文字多少来定
    CGSize dateSize = [AppUtils textSizeFromTextString:_datelabel.text
                                             width:100
                                            height:20
                                              font:[UIFont dq_semiboldSystemFontOfSize:14.0]];
    CGRect rect = _datelabel.frame;
    rect.size.width = dateSize.width;
    _datelabel.frame= rect;

    CGSize weekSize = [AppUtils textSizeFromTextString:_weekLabel.text
                                                 width:100
                                                height:20
                                                  font:[UIFont dq_semiboldSystemFontOfSize:12.0]];
    CGRect weekRect = _weekLabel.frame;
    weekRect.size.width = weekSize.width;
    _weekLabel.frame = weekRect;
    
}

/** 截取日期字符串处理 */
- (NSString *)getFormattterDateString:(NSString *)dateString {
 
    NSString *dateStr = nil;
    if ([dateString containsString:@"/"]) {
        if ([dateString containsString:@":"]) {
            NSArray *ary = [dateString componentsSeparatedByString:@" "];
            dateStr = [ary firstObject];
        } else {
            dateStr = dateString;
        }
    } else {
        dateStr = [NSDate dateForString:[NSDate date] format:@"yyyy/MM/dd"];
    }
    return dateStr;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    frame.size.width = CGRectGetMaxX(_weekLabel.frame) + 20;
    self.frame = frame;
}

@end

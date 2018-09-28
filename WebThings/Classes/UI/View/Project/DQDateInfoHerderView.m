//
//  DQDateInfoHerderView.m
//  WebThings
//
//  Created by winton on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQDateInfoHerderView.h"

@interface DQDateInfoHerderView()
@property (nonatomic, strong) UIView *radiusView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *evaluationLabel;
@end

@implementation DQDateInfoHerderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:COLOR_BLACK];
        [self withRadius:frame.size.height/2-1];
        [self addSubview:self.radiusView];
        [self addSubview:self.dateLabel];
        [self addSubview:self.weekLabel];
        [self addSubview:self.evaluationLabel];
    }
    return self;
}

- (UIView *)radiusView
{
    if (!_radiusView) {
        _radiusView = [[UIView alloc] initWithFrame:CGRectMake(10, (self.height-10)/2, 10, 10)];
        _radiusView.backgroundColor = [UIColor whiteColor];
        [_radiusView withRadius:5.f];
    }
    return _radiusView;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.radiusView.right+17, 7, 0, self.height-14)];
        _dateLabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

- (UILabel *)weekLabel
{
    if (!_weekLabel) {
        _weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.dateLabel.top, 0, self.dateLabel.height)];
        _weekLabel.font = [UIFont dq_semiboldSystemFontOfSize:12];
        _weekLabel.textColor = [UIColor colorWithHexString:@"#BAB9B9"];
        _weekLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _weekLabel;
}

- (UILabel *)evaluationLabel
{
    if (!_evaluationLabel) {
        _evaluationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.dateLabel.top, 0, self.dateLabel.height)];
        _evaluationLabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
        _evaluationLabel.textColor = [UIColor whiteColor];
        _evaluationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _evaluationLabel;
}

- (void)configDateInfoClick:(NSString *)date
                       week:(NSString *)week
                     number:(NSInteger)number
{
    self.dateLabel.text = [NSDate verifyDateForYMD:date];
    self.weekLabel.text = week;
    self.evaluationLabel.text = [NSString stringWithFormat:@"培训%ld人",number];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = [AppUtils textWidthSystemFontString:self.dateLabel.text height:self.dateLabel.height font:self.dateLabel.font];
    self.dateLabel.width = width;
    
    CGFloat wkWidth = [AppUtils textWidthSystemFontString:self.weekLabel.text height:self.weekLabel.height font:self.weekLabel.font];
    self.weekLabel.width = wkWidth;
    self.weekLabel.left = self.dateLabel.right+10;
    
    CGFloat nmWidth = [AppUtils textWidthSystemFontString:self.evaluationLabel.text height:self.evaluationLabel.height font:self.evaluationLabel.font];
    self.evaluationLabel.width = nmWidth;
    self.evaluationLabel.left =  self.weekLabel.right+12;
}

@end

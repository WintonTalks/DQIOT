//
//  DQDailyCaledarHeadView.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/12.
//  Copyright © 2017年 machinsight. All rights reserved.
//


#import "DQDailyCaledarHeadView.h"

@interface DQDailyCaledarHeadView ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *caledarLable;
@property (nonatomic, strong) UIImageView *arrowView;
@end

@implementation DQDailyCaledarHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    [self addSubview:self.iconView];
    [self addSubview:self.caledarLable];
    [self addSubview:self.arrowView];
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (self.height-19)/2, 19, 19)];
        _iconView.image = ImageNamed(@"business_calendar_icon");
    }
    return _iconView;
}


- (UILabel *)caledarLable
{
    if (!_caledarLable) {
        _caledarLable = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.right+15, self.iconView.top, 0, 24)];
        _caledarLable.font = [UIFont dq_semiboldSystemFontOfSize:14];
        _caledarLable.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _caledarLable.textAlignment = NSTextAlignmentLeft;
    }
    return _caledarLable;
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:ImageNamed(@"ic_down")];
        _arrowView.frame = CGRectMake(0, 0, 8, 5);
    }
    return _arrowView;
}

- (void)setDate:(NSString *)date
{
    _date = date;
    self.caledarLable.text = date;
    CGFloat width = [AppUtils textWidthSystemFontString:date height:self.caledarLable.height font:self.caledarLable.font];
    self.caledarLable.width = width+5;
    self.arrowView.left = self.caledarLable.right+2;
    self.arrowView.top = self.caledarLable.top+8;
}

- (void)setPullState:(BOOL)pullState
{
    UIImage *image = pullState ? ImageNamed(@"ic_up") : ImageNamed(@"ic_down");
    self.arrowView.image = image;
}

@end

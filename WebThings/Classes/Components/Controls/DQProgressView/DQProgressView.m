//
//  DQProgressView.m
//  DQDemo
//
//  Created by Eugene on 25/09/2017.
//  Copyright © 2017 Eugene. All rights reserved.
//

#import "DQProgressView.h"

@interface DQProgressView ()

/** 进度view */
@property (nonatomic, strong) UIView *progressView;

/** 轨道view */
@property (nonatomic, strong) UIView *trackView;

@property (nonatomic, assign) NSInteger progressHeight;

@end

@implementation DQProgressView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = frame.size.height > 15 ? 15 : frame.size.height;
    _progressHeight = frame.size.height-5;
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initProgressView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initProgressView];
    }
    return self;
}

- (void)initProgressView {
    
    UIView *trackView = [[UIView alloc] init];
    trackView.frame = CGRectMake(0, 0, self.frame.size.width, _progressHeight);
    trackView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    trackView.layer.cornerRadius = _progressHeight / 2.0;
    [self addSubview:trackView];
    _trackView = trackView;
    
    _progressView = [[UIView alloc] init];
    _progressView.frame = CGRectMake(0, 0, self.frame.size.width*0.0, _progressHeight);
    _progressView.backgroundColor = [UIColor colorWithRed:65/255.0 green:126/255.0 blue:232/255.0 alpha:1/1.0];
    // 圆角
    _progressView.layer.cornerRadius = _progressHeight / 2.0;
    // 设置阴影颜色
    _progressView.layer.shadowColor = [UIColor colorWithRed:150/255.0 green:196/255.0 blue:250/255.0 alpha:1/1.0].CGColor;
    // 设置阴影的偏移量，默认是（0， -3）
    _progressView.layer.shadowOffset = CGSizeMake(0, 3);
    // 设置阴影不透明度，默认是0
    _progressView.layer.shadowOpacity = 1.0;
    // 设置阴影的半径，默认是3
    _progressView.layer.shadowRadius = 4;
    [self addSubview:_progressView];
}

#pragma mark - Setter
- (void)setProgress:(CGFloat)progress {
    
    progress = (progress < 0.0) ? 0.0 :progress;
    progress = (progress > 1.0) ? 1.0 :progress;
    
    _progress = progress;
    
    _progressView.frame = CGRectMake(0, 0, self.frame.size.width*progress, _progressHeight);
}

- (void)setTrackBackgroundColor:(UIColor *)trackBackgroundColor {
    _trackBackgroundColor = trackBackgroundColor;
    _trackView.backgroundColor = trackBackgroundColor;
}

- (void)setProgressShadowColor:(UIColor *)progressShadowColor {
    _progressShadowColor = progressShadowColor;
    _progressView.layer.shadowColor = progressShadowColor.CGColor;
}

- (void)setProgressBackgroundColor:(UIColor *)progressBackgroundColor {
    _progressBackgroundColor = progressBackgroundColor;
    _progressView.backgroundColor = progressBackgroundColor;
}
@end

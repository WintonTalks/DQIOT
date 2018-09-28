//
//  XHStarRateView.m
//  XHStarRateView
//
//  Created by 江欣华 on 16/4/1.
//  Copyright © 2016年 jxh. All rights reserved.
//

#import "XHStarRateView.h"

#define ForegroundStarImage @"b27_icon_star_yellow"
#define BackgroundStarImage @"b27_icon_star_gray"

typedef void(^completeBlock)(CGFloat currentScore);

@interface XHStarRateView()

@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;

@property (nonatomic,strong) NSMutableArray <UILabel *> *labArr;
@property (nonatomic,strong) UILabel *currentLab;
@property (nonatomic,strong) NSMutableArray <NSString *> *labTitle;

@property (nonatomic, assign) NSInteger numberOfStars;


@property (nonatomic,strong)completeBlock complete;

@end

@implementation XHStarRateView

#pragma mark - 代理方式
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _rateStyle = WholeStar;
//        _isShowLab = NO;
        [self createStarView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
//        _isShowLab = NO;
        _delegate = delegate;
        [self createStarView];
    }
    return self;
}

#pragma mark - block方式
-(instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _rateStyle = WholeStar;
        _complete = ^(CGFloat currentScore){
            finish(currentScore);
        };
//        _isShowLab = NO;
        [self createStarView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
//        _isShowLab = NO;
        _complete = ^(CGFloat currentScore){
            finish(currentScore);
        };
        [self createStarView];
    }
    return self;
}

#pragma mark - private Method
-(void)createStarView{
    
    _labArr = [NSMutableArray array];
    _labTitle = [NSMutableArray arrayWithObjects:@"极差",@"较差",@"一般",@"不错",@"很棒", nil];
    
    for (int i = 0; i < _numberOfStars; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i * self.bounds.size.width / self.numberOfStars, self.bounds.size.height-20, self.bounds.size.width / self.numberOfStars, 20)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14];
        lab.text = _labTitle[i];
        lab.textColor = [UIColor colorWithHexString:@"#818D92"];
        if (i == 0) {
            lab.textColor = [UIColor colorWithHexString:@"#528CEA"];
            _currentLab = lab;
        }
        lab.hidden = NO;
        [self addSubview:lab];
        [_labArr addObject:lab];
    }
    
    self.foregroundStarView = [self createStarViewWithImage:ForegroundStarImage];
    self.backgroundStarView = [self createStarViewWithImage:BackgroundStarImage];
    self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width*_currentScore/self.numberOfStars, self.bounds.size.height);
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];

}

- (UIView *)createStarViewWithImage:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height-20)];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height-20);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)userTapRateView:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    switch (_rateStyle) {
        case WholeStar:
        {
            self.currentScore = ceilf(realStarScore);
            break;
        }
        case HalfStar:
            self.currentScore = roundf(realStarScore)>realStarScore ? ceilf(realStarScore):(ceilf(realStarScore)-0.5);
            break;
        case IncompleteStar:
            self.currentScore = realStarScore;
            break;
        default:
            break;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _currentLab.textColor = [UIColor colorWithHexString:@"#818D92"];
    int x = [[NSNumber numberWithFloat:_currentScore] intValue];
    if (_currentScore > 0) {
        x = [[NSNumber numberWithFloat:(_currentScore-1)] intValue];
    }
    
    _currentLab = [_labArr objectAtIndex:x];
    _currentLab.textColor = [UIColor colorWithHexString:@"#528CEA"];
    __weak XHStarRateView *weakSelf = self;
    CGFloat animationTimeInterval = self.isAnimation ? 0.2 : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        weakSelf.foregroundStarView.frame = CGRectMake(0, 0, weakSelf.bounds.size.width * weakSelf.currentScore/self.numberOfStars, weakSelf.bounds.size.height-20);
        
    }];
}


-(void)setCurrentScore:(CGFloat)currentScore {
    if (_currentScore == currentScore) {
        return;
    }
    if (currentScore < 0) {
        _currentScore = 0;
    } else if (currentScore > _numberOfStars) {
        _currentScore = _numberOfStars;
    } else {
        _currentScore = currentScore;
    }
    
    if ([self.delegate respondsToSelector:@selector(starRateView:currentScore:)]) {
        [self.delegate starRateView:self currentScore:_currentScore];
    }
    
    if (self.complete) {
        _complete(_currentScore);
    }
    
    [self setNeedsLayout];
}

@end

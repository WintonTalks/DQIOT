//
//  DQEvalueStarView.m
//  WebThings
//
//  Created by winton on 2017/10/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQEvalueStarView.h"
#import "DQStarView.h"

@interface DQEvalueStarView()
@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) UIView *infoStarView;
@end

static const NSInteger KRBDefaultStarCount = 5;

@implementation DQEvalueStarView

- (instancetype)initWithFrame:(CGRect)frame
                    leftTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化参数
        [self rbInitParam];
        [self addConfigStarView:title];
        // 添加手势
        [self rbAddGesture];
        [self rbAddStarWithCount:self.starTotalNumber];
    }
    return self;
}

/** 初始化参数 */
- (void)rbInitParam
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = true;
    _minSelectedNumber = 1;
    _starTotalNumber = KRBDefaultStarCount;
    _selectedStarNumber = _starTotalNumber;
    self.touchEnable = true;
    self.scrollSelectEnable = true;
}

- (void)addConfigStarView:(NSString *)title
{
    UIFont *font = [UIFont dq_lightSystemFontOfSize:14];
    CGFloat width = [AppUtils textWidthSystemFontString:title height:self.height font:font];
    
    _leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, self.height)];
    _leftTitleLabel.textColor = [UIColor blackColor];
    _leftTitleLabel.font = font;
    _leftTitleLabel.textAlignment = NSTextAlignmentLeft;
    _leftTitleLabel.text = title;
    [self addSubview:_leftTitleLabel];
    
    _infoStarView = [[UIView alloc] initWithFrame:CGRectMake(_leftTitleLabel.right+16, 0, self.height*5+30, self.height)];
    _infoStarView.userInteractionEnabled = true;
    _infoStarView.backgroundColor = [UIColor clearColor];
    [self addSubview:_infoStarView];
}


#pragma mark 添加手势
/** 添加手势 */
- (void)rbAddGesture {
    // 点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rbTapGes:)];
    [_infoStarView addGestureRecognizer:tap];
    // 滑动
//    if (self.touchEnable && self.scrollSelectEnable) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rbPanGes:)];
        [_infoStarView addGestureRecognizer:pan];
}

/** 点击手势触发方法 */
- (void)rbTapGes:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:_infoStarView];
    if (self.isNeedHalf) {
        CGFloat count = (point.x / CGRectGetHeight(self.frame));
        count = count < self.minSelectedNumber ? self.minSelectedNumber : count;
        self.selectedStarNumber = count > self.starTotalNumber ? self.starTotalNumber : count;
    } else {
        NSInteger count = (point.x / CGRectGetHeight(self.frame)) + 1;
        count = count < self.minSelectedNumber ? self.minSelectedNumber : count;
        self.selectedStarNumber = count > self.starTotalNumber ? self.starTotalNumber : count;
    }
}

/** 滑动手势触发方法 */
- (void)rbPanGes:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:_infoStarView];
    if (self.isNeedHalf) {
        CGFloat count = (point.x / CGRectGetHeight(self.frame));
        // 最小点亮数的左右边
        count = count < self.minSelectedNumber ? self.minSelectedNumber : count;
        
        if (count >= 0 && count <= self.starTotalNumber && self.selectedStarNumber != count) {
            self.selectedStarNumber = count;
        }
    } else {
        NSInteger count = (point.x / CGRectGetHeight(self.frame)) + 1;
        // 最小点亮数的左右边
        count = count < self.minSelectedNumber ? self.minSelectedNumber : count;
        
        if (count >= 0 && count <= self.starTotalNumber && self.selectedStarNumber != count) {
            self.selectedStarNumber = count;
        }
    }
}

#pragma mark 添加星星
/** 添加星星 */
- (void)rbAddStarWithCount:(NSInteger)count
{
    if (self.subviews.count) {
        // 全部删除
        for (UIView *vi in _infoStarView.subviews) {
            if ([vi isMemberOfClass:[DQStarView class]]) {
                [vi removeFromSuperview];
            }
        }
    }
    
    // star的 宽高 就是 JhtRatingBar的高度
    CGFloat starWH = CGRectGetHeight(self.frame);
    for (NSInteger i = 0; i < count; i ++) {
        DQStarView *star = [[DQStarView alloc] initWithFrame:CGRectMake(starWH * i, 0, starWH, starWH)];
        // 初始化 星星为未选中状态
        star.selectedStarType = Selected_noStar;
        //        self.star = star;
        [_infoStarView addSubview:star];
    }
    self.selectedStarNumber = 0;
    [self rbJudgeWidth];
}

/** 判断设置的宽度是否能够放得下所有星星 */
- (void)rbJudgeWidth {
    CGRect frame = self.frame;
    CGFloat realWidth = self.starTotalNumber * CGRectGetHeight(frame);
    if (CGRectGetMaxX(frame) < realWidth && realWidth <= [UIScreen mainScreen].bounds.size.width) {
        frame.size.width = realWidth;
        _infoStarView.frame = frame;
    }
}

#pragma mark - Set
/** 星星总的数量
 *  default：5
 */
- (void)setStarTotalNumber:(NSInteger)starTotalNumber {
    if (_starTotalNumber != starTotalNumber) {
        _starTotalNumber = starTotalNumber;
        
        // 改变星星个数
        [self rbAddStarWithCount:starTotalNumber];
        if (self.selectedStarNumber != KRBDefaultStarCount) {
            // 设置选中星星的数量
            [self setSelectedStarNumber:self.selectedStarNumber];
        } else {
            self.selectedStarNumber = starTotalNumber;
        }
    }
    
    // 判断设置的宽度是否能够放得下所有星星
    [self rbJudgeWidth];
}

/** 选中星星的数量
 *  default：星星总数
 */
- (void)setSelectedStarNumber:(CGFloat)selectedStarNumber {
    _selectedStarNumber = selectedStarNumber;
    
    // 设置最小分数
    if (selectedStarNumber < self.minSelectedNumber) {
        return;
    }
    
    // 判断是否需要半分
    if (self.isNeedHalf) {
        // 计算点亮星星个数
        NSString *starCount = [NSString stringWithFormat:@"%lf", selectedStarNumber];
        // 整数分
        NSInteger num1 = [[[starCount componentsSeparatedByString:@"."] firstObject] integerValue];
        // 小数分
        CGFloat num2 = [[NSString stringWithFormat:@"0.%@", [[starCount componentsSeparatedByString:@"."] lastObject]] floatValue];
        
        // 是否有半颗星
        if (num2 > 0.6) {
            num1 += 1;
            num2 = 0.0;
        }
        BOOL isHalf = num2 >= 0.3 ? YES : NO;
        
        // 告诉star改变图片
        for (NSInteger i = 0; i < _infoStarView.subviews.count; i ++) {
            DQStarView *star = _infoStarView.subviews[i];
            if (i < num1) {
                star.selectedStarType = Selected_allStar;
            } else {
                star.selectedStarType = Selected_noStar;
            }
        }
        
        // 处理小数部分
        CGFloat num3 = isHalf ? 0.5 : 0.0;
        _scale = (CGFloat)num1 + num3;
    } else {
        NSInteger starCount = (NSInteger)selectedStarNumber;
        if (starCount == 0) {
            for (NSInteger i = 0; i < _infoStarView.subviews.count; i ++) {
                DQStarView *star = _infoStarView.subviews[i];
                star.selectedStarType = Selected_noStar;
            }
            
        } else {
            // star改变
            for (NSInteger i = 0; i < _infoStarView.subviews.count; i ++) {
                DQStarView *star = _infoStarView.subviews[i];
                if (i < starCount) {
                    star.selectedStarType = Selected_allStar;
                } else {
                    star.selectedStarType = Selected_noStar;
                }
            }
        }
        _scale = starCount;
    }
    
    // 星星选中状态发生变化
    if (self.delegate && [self.delegate respondsToSelector:@selector(starsControl:didChangeScore:)]) {
        [self.delegate starsControl:self didChangeScore:_scale];
    }
}

- (void)setTouchEnable:(BOOL)touchEnable
{
    if (!touchEnable) {
        _infoStarView.userInteractionEnabled = false;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
}

/** 底部视图的颜色（默认：白色）
 *  default：[UIColor whiteColor]
 */
- (void)setBgViewColor:(UIColor *)bgViewColor {
    if (_bgViewColor != bgViewColor) {
        self.backgroundColor = bgViewColor;
    }
}

@end

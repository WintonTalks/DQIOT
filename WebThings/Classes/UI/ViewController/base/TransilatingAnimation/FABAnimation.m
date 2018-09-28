//
//  FABPushAnimation.m
//  WebThings
//
//  Created by machinsight on 2017/6/15.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "FABAnimation.h"

@interface FABAnimation()<CAAnimationDelegate>
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation FABAnimation
- (instancetype)initWithAnimatedView:(UIView *)animatedView
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    NSAssert(animatedView != nil, @"animatedView cannot be nil");
    _animatedView = animatedView;
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
   
    UIView* contentView = [self.transitionContext containerView];
    
    UIViewController* fromVc = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVc = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVc.view.frame = [self.transitionContext finalFrameForViewController:toVc];
    
    toVc.view.alpha = 0;
    _cardV = [[EMICardView alloc] initWithFrame:_cardVFrame];
    _cardV.backgroundColor = [UIColor whiteColor];
    [fromVc.view addSubview:_cardV];
    
    
    if(!self.isReverse){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setupCircleAnimation];
            [contentView addSubview:toVc.view];
        } completion:^(BOOL finished) {
            toVc.view.alpha = 1;
        }];
    }
    else{
        //pop
        [UIView animateWithDuration:0.3 animations:^{
            [self setPopAni];
            [contentView insertSubview:toVc.view belowSubview:fromVc.view];
        } completion:^(BOOL finished) {
            toVc.view.alpha = 1;
        }];
    }
}


-(void)setupCircleAnimation{
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    int controlPointX = (_animatedView.center.x + screenWidth/2) / 3;
    int controlPointY = (_animatedView.center.y + screenHeight/2) / 2;
    [path moveToPoint:CGPointMake(_animatedView.center.x, _animatedView.center.y)];
    [path addQuadCurveToPoint:CGPointMake(screenWidth/2, screenHeight/2	) controlPoint:CGPointMake(controlPointX, controlPointY)];
    anima.path = path.CGPath;
    anima.duration = 0.3f;
    
    
    CGRect rect = CGRectMake(_cardV.center.x-30, _cardV.center.y-30, 60, 60);
    UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    CGPoint extremePoint = CGPointMake(self.cardV.bounds.size.width/2, self.cardV.bounds.size.height/2);
    
    float radius = sqrtf(extremePoint.x * extremePoint.x + extremePoint.y * extremePoint.y)+50;
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    self.cardV.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id _Nullable)(originPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
    animation.duration = 0.3f;
    [maskLayer addAnimation:animation forKey:@"path"];
    //组动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.delegate = self;
    groupAnimation.animations = [NSArray arrayWithObjects:anima,animation, nil];
    groupAnimation.duration = 0.3f;
    [_cardV.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
}


- (void)setPopAni{
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    int controlPointX = (_animatedView.center.x + _cardV.center.x/2) / 3;
    int controlPointY = (_animatedView.center.y + _cardV.center.y/2) / 2;
    [path moveToPoint:CGPointMake(_cardV.center.x, _cardV.center.y)];
    [path addQuadCurveToPoint:CGPointMake(_animatedView.center.x, _animatedView.center.y) controlPoint:CGPointMake(controlPointX, controlPointY)];
    anima.path = path.CGPath;
    anima.duration = 0.3f;
    
    
    CGRect rect = CGRectMake(_cardV.center.x-30, _cardV.center.y-30, 60, 60);
    UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    CGPoint extremePoint = CGPointMake(self.cardV.bounds.size.width/2, self.cardV.bounds.size.height/2);
    
    float radius = sqrtf(extremePoint.x * extremePoint.x + extremePoint.y * extremePoint.y)+50;
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    self.cardV.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.toValue = (__bridge id _Nullable)(originPath.CGPath);
    animation.fromValue = (__bridge id _Nullable)(finalPath.CGPath);
    animation.duration = 0.3f;
    [maskLayer addAnimation:animation forKey:@"path"];
    //组动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anima,animation, nil];
    groupAnimation.duration = 0.3f;
    groupAnimation.delegate = self;
    [_cardV.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
}



-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    
    _cardV.layer.mask = nil;
    [_cardV removeFromSuperview];
    _cardV = nil;
    
   
    
}
@end

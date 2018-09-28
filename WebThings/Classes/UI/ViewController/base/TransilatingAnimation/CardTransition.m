//
//  CardTransition.m
//  WebThings
//
//  Created by machinsight on 2017/8/11.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CardTransition.h"

@interface CardTransition()<CAAnimationDelegate>
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@end

@implementation CardTransition
- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
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
            _cardV.frame = _toCardFrame;
            [contentView addSubview:toVc.view];
        } completion:^(BOOL finished) {
            toVc.view.alpha = 1;
            [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
            
            _cardV.layer.mask = nil;
            [_cardV removeFromSuperview];
            _cardV = nil;
        }];
    }
    else{
        //pop
        [UIView animateWithDuration:0.3 animations:^{
            _cardV.frame = _toCardFrame;
            _cardV.alpha = 0;
            [contentView insertSubview:toVc.view belowSubview:fromVc.view];
        } completion:^(BOOL finished) {
            toVc.view.alpha = 1;
            [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
            
            _cardV.layer.mask = nil;
            [_cardV removeFromSuperview];
            _cardV = nil;
        }];
    }
}








@end

//
//  PushTransition.m
//  WebThings
//
//  Created by machinsight on 2017/5/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "PushTransition.h"

@implementation PushTransition
// 指定动画的持续时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
    
}
// 转场动画的具体内容
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    // 获取动画的源控制器和目标控制器
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * container = transitionContext.containerView;
    

    toVC.view.frame = CGRectMake(screenWidth, 0, screenWidth, screenHeight);
    // 设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
    
    toVC.view.alpha = 0;
    
    // 都添加到container中。注意顺序
    [container addSubview:toVC.view];
    // 执行动画
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        toVC.view.alpha = 1;
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        //一定要记得动画完成后执行此方法，让系统管理 navigation
        [transitionContext completeTransition:YES];
    }];
}
@end

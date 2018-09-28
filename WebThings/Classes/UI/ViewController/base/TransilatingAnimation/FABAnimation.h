//
//  FABPushAnimation.h
//  WebThings
//
//  Created by machinsight on 2017/6/15.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMICardView.h"

@interface FABAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (weak, nonatomic) UIView *animatedView;

@property (strong,nonatomic) EMICardView *cardV;
@property (assign,nonatomic) CGRect cardVFrame;

@property (getter=isReverse) BOOL reverse;

- (instancetype)initWithAnimatedView:(UIView *)animatedView;
@end



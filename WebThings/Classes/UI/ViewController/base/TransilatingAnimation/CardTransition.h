//
//  CardTransition.h
//  WebThings
//
//  Created by machinsight on 2017/8/11.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMICardView.h"

@interface CardTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (strong,nonatomic) EMICardView *cardV;
@property (assign,nonatomic) CGRect cardVFrame;
@property (assign,nonatomic) CGRect toCardFrame;

@property (getter=isReverse) BOOL reverse;

- (instancetype)init;
@end

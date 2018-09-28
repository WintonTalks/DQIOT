//
//  ChangeAnchorPoint.h
//  WebThings
//
//  Created by machinsight on 2017/6/20.
//  Copyright © 2017年 machinsight. All rights reserved.
//  改变放大缩小的原点

#import <Foundation/Foundation.h>

@interface ChangeAnchorPoint : NSObject
+ (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;
+ (void)setDefaultAnchorPointforView:(UIView *)view;
@end

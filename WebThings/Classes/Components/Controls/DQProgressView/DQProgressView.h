//
//  DQProgressView.h
//  DQDemo
//
//  Created by Eugene on 25/09/2017.
//  Copyright © 2017 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQProgressView : UIView

/** 进度 范围0～1 默认0.5 */
@property (nonatomic, assign) CGFloat progress;

/** 轨道背景色 */
@property (nonatomic, strong) UIColor *trackBackgroundColor;

/** 进度条背景色 */
@property (nonatomic, strong) UIColor *progressBackgroundColor;

/** 进度条阴影色 */
@property (nonatomic, strong) UIColor *progressShadowColor;


@end

//
//  DQOverView.h
//  DQDemo
//
//  Created by Eugene on 2017/9/14.
//  Copyright © 2017年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQOverView : UIWindow

+ (DQOverView *)shareInstance;

- (void)show;

- (void)dismiss;

@end

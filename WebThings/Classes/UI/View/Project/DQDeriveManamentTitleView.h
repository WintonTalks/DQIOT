//
//  DQDeriveManamentTitleView.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/29.
//  Copyright © 2017年 machinsight. All rights reserved.
//  cell司机信息、操作权限

#import <UIKit/UIKit.h>
#import "DriverModel.h"

@class DQDeriveManamentTitleView;
@protocol DQDeriveManamentTitleViewDelegate <NSObject>
///编辑司机操作
- (void)didDeriveInfoEditclicked:(DQDeriveManamentTitleView *)manageView;
//操作权限
- (void)didDerivePullStackView:(DQDeriveManamentTitleView *)manageView;
@end

@interface DQDeriveManamentTitleView : UIView
@property (nonatomic, weak) id<DQDeriveManamentTitleViewDelegate>delegate;
@property (nonatomic, strong) NSString *infoAuth;
- (void)configDriveTitleData:(DriverModel *)model;
@end

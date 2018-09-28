//
//  DQApproachBottomView.h
//  WebThings
//  驳回|确认状态的View
//  Created by 孙文强 on 2017/9/27.
//  Modify by Heidi
//  Copyright © 2017年 machinsight. All rights reserved.
//  进场同意or驳回view

#import <UIKit/UIKit.h>

@class DQLogicServiceBaseModel;

@interface DQApproachBottomView : UIView

- (void)configApproachWithModel:(DQLogicServiceBaseModel *)model;

@end

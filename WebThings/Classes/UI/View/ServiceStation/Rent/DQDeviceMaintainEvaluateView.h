//
//  DQDeviceMaintainEvaluateView.h
//  WebThings
//
//  Created by Eugene on 10/13/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DQLogicEvaluateModel.h"

@class DQDeviceMaintainEvaluateView;
@protocol DQDeviceMaintainEvaluateViewDelegate <NSObject>
/// 此View的高度发生改变时
- (void)willChangeHeight:(CGFloat)height;
@end

@interface DQDeviceMaintainEvaluateView : UIView

@property (nonatomic, strong) DQLogicEvaluateModel *evaluteLogic;
@property (nonatomic, weak) id<DQDeviceMaintainEvaluateViewDelegate> delegate;

// 本View的实时高度
- (CGFloat)getMaxY;

@end


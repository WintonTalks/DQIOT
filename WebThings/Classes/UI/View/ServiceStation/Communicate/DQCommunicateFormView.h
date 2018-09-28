//
//  DQCommunicateFormView.h
//  WebThings
//
//  Created by Eugene on 27/09/2017.
//  Copyright © 2017 machinsight. All rights reserved.
//   前期沟通-》 沟通单列表

#import <UIKit/UIKit.h>
#import "DQLogicCommunicateModel.h"

@interface DQCommunicateFormView : UIView

@property (nonatomic, strong) DQLogicCommunicateModel *logicModel;

/** 获取维保单高度 */
- (CGFloat)getCommunicateFormViewHeight;

@end

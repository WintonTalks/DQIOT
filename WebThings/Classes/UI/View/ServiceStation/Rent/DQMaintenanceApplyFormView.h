//
//  DQMaintenanceApplyFormView.h
//  WebThings
//
//  Created by Eugene on 10/9/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DQLogicMaintainModel.h"

typedef void(^DQFoldBlock) (void);
@interface DQMaintenanceApplyFormView : UIView

/** 维保单 model */
@property (nonatomic, strong) DQLogicMaintainModel *logicApplyFormModel;

@property (nonatomic, copy) DQFoldBlock reloadFrameBlock;

/** 获取维保申请单的高度 */
@property (nonatomic, assign) NSInteger formViewHeight;

@end

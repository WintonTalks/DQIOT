//
//  DQUserInfoTopView.h
//  WebThings
//
//  Created by Eugene on 27/09/2017.
//  Copyright © 2017 machinsight. All rights reserved.
//  前期沟通-》沟通表单 topView用户信息

#import <UIKit/UIKit.h>

@class DQLogicServiceBaseModel;

typedef void (^DQFoldBlock) (BOOL isFold);
@interface DQUserInfoTopView : UIView

/** 折叠按钮是否显示，默认为 隐藏 */
@property (nonatomic, assign) BOOL isHidden;

/** 折叠block事件 */
@property (nonatomic, copy) DQFoldBlock unfoldBlock;

@property (nonatomic, strong) DQLogicServiceBaseModel *viewData;

@end

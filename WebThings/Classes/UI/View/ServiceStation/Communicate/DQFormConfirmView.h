//
//  DQFormConfirmView.h
//  WebThings
//
//  Created by Eugene on 27/09/2017.
//  Copyright © 2017 machinsight. All rights reserved.
//  前期沟通-》沟通表单 bottomView确认、驳回视图

#import <UIKit/UIKit.h>
@class DQLogicServiceBaseModel;

typedef void(^FormConfirmBlock) (void);
@interface DQFormConfirmView : UIView

@property (nonatomic, strong) DQLogicServiceBaseModel *logicServiceBaseModel;
/** 确认按钮文本 */
@property (nonatomic, copy) NSString *sureTitle;

/** 忽略事件按钮文本 */
@property (nonatomic, copy) NSString *ignoreTitle;

/** 确认block */
@property (nonatomic, copy) FormConfirmBlock confirmBlock;
/** 驳回block */
@property (nonatomic, copy) FormConfirmBlock ignoreBlock;

@end

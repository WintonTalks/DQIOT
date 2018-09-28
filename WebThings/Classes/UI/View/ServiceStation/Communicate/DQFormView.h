//
//  DQFormView.h
//  WebThings
//
//  Created by Eugene on 9/28/17.
//  Copyright © 2017 machinsight. All rights reserved.
// 前期沟通-》沟通表单 包含：topView、容器视图、bottomView

#import <UIKit/UIKit.h>

@class DQFormView;
@class DQLogicServiceBaseModel;

@protocol DQFormViewDelegate <NSObject>
@optional
/** 表单确认 */
- (void)formViewConfirm:(DQFormView *)formView;
/** 表单驳回 */
- (void)formViewIgnore:(DQFormView *)formView;
/** 表单折叠 */
- (void)formViewUnfold:(BOOL)isUnfold;
@end

// ------------------ 分割线 -------------------

@interface DQFormView : UIView

@property (nonatomic, weak) id<DQFormViewDelegate> delegate;
@property (nonatomic, strong) DQLogicServiceBaseModel *logicServiceModel;

/** 视图表单view的折叠按钮是否显示 */
@property (nonatomic, assign) BOOL isHiddenFoldBtn;
/** 视图表单view的折叠状态 */
@property (nonatomic, assign, readonly) BOOL isUnfold;

/** 添加内容视图到表单view */
- (void)addFormSubView:(UIView *)view;
/** 批量添加内容视图到表单view */
- (void)addFormSubviews:(NSArray <UIView *>*)subviews;

/** 更新表单frame时调用 */
- (void)reloadFormSubView;
@end

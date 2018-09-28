//
//  DQServiceSectionHeaderView.h
//  WebThings
//  业务站节点Header
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceSectionHeaderView_h
#define DQServiceSectionHeaderView_h

#import <UIKit/UIKit.h>
#import "DQDefine.h"

@class DQServiceNodeModel;

@interface DQServiceSectionHeaderView : UITableViewHeaderFooterView
{
    UILabel *_titleLabel;
    UIImageView *_icon;
    UIImageView *_indictor;
    UIButton *_button;
    
    UIView *_dot;
    UIView *_line1;
    UIView *_line2;
    
    BOOL _isOpened;
    
    UIView *_bodyView;
    UIView *_bgView;
}

@property (nonatomic, copy) DQResultBlock clicked;
@property (nonatomic, strong) DQServiceNodeModel *node;
/// 是否需要跳转到下一级页面而不是展开（设备维保，维修，加高）
@property (nonatomic, assign) BOOL canSkipToNext;

/** 打开的section,用来控制竖线显示与否和竖线颜色 */
@property (nonatomic, assign) DQFlowType openIndex;
/** 已走到哪一步,用来控制竖线显示与否和竖线颜色 */
@property (nonatomic, assign) DQFlowType currentStep;

- (void)setNode:(DQServiceNodeModel *)node;

@end

#endif /* DQServiceSectionHeaderView_h */

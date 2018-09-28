
//
//  Header.h
//  WebThings
//  评价View
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceEvaluateFooterView_h
#define DQServiceEvaluateFooterView_h

#import "DQLogicEvaluateModel.h"

#import "HPGrowingTextView.h"
#import "DQServiceEvaluateView.h"

@class DQFormView;

@protocol DQEvaluateFooterDelegate;

@interface DQServiceEvaluateFooterView : UIView
<DQServiceEvaluateViewDelegate>
{
    DQFormView *_formView;
    UIView *_bodyView;
    
    DQServiceEvaluateView *_evalutePersonView;     // 人员评价
    DQServiceEvaluateView *_evaluteDeviceView;      // 设备评价
    
    UIButton *_btnSend; // 发送按钮
}

@property (nonatomic, strong) DQLogicEvaluateModel *evaluteLogic;
@property (nonatomic, weak) id<DQEvaluateFooterDelegate> delegate;
// 本View的实时高度
- (CGFloat)getMaxY;

@end

@protocol DQEvaluateFooterDelegate <NSObject>
/// 此View的高度发生改变时
- (void)willChangeHeight:(CGFloat)height;

@end

#endif /* DQServiceEvaluateFooterView_h */

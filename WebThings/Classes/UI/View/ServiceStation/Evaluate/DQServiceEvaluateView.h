
//
//  Header.h
//  WebThings
//  评价View
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceEvaluateView_h
#define DQServiceEvaluateView_h

#import "DQEvalueStarView.h"
#import "DQLogicEvaluateModel.h"

#import "HPGrowingTextView.h"

@protocol DQServiceEvaluateViewDelegate;

@interface DQServiceEvaluateView : UIView
<DQEvalueStarViewDelegate,
HPGrowingTextViewDelegate>
{
    DQEvaluateType _evaluateType;
    
    UILabel *_lblTitle;
    UIButton *_btnSatisfy;
    UIButton *_btnUnsatisfy;
    
    DQEvalueStarView *_controlFirst;
    DQEvalueStarView *_controlSecond;
    DQEvalueStarView *_controlThird;
    
    HPGrowingTextView *_contentTextView;   // 评价内容
    
    UIView *_line1;
    UIView *_line2;
    UIView *_lineBottom;
}

- (id)initWithFrame:(CGRect)frame type:(DQEvaluateType)type;

@property (nonatomic, copy) NSString *titleStr;
/** 是否能编辑 */
@property (nonatomic, assign) BOOL canEdit;
/** 最多显示多少行 */
@property (nonatomic, assign) int maxLine;

@property (nonatomic, weak) id<DQServiceEvaluateViewDelegate> delegate;

 /** 是否满意 */
@property (nonatomic, assign) BOOL isSatisfy;
/** 第一项评分 */
@property (nonatomic, assign) NSInteger starFirst;
/** 第二项评分 */
@property (nonatomic, assign) NSInteger starSecond;
/** 第三项评分 */
@property (nonatomic, assign) NSInteger starThird;
/** 文本内容 */
@property (nonatomic, copy) NSString *content;

- (void)setData:(DQLogicServiceBaseModel *)data evaluate:(ServiceevaluateModel *)evaluate;

// 本View的实时高度
- (CGFloat)getMaxY;

@end

@protocol DQServiceEvaluateViewDelegate <NSObject>
/// 此View的高度发生改变时
- (void)willChangeHeight:(CGFloat)height evaluateView:(DQServiceEvaluateView *)evaluateView;

@end

#endif /* DQServiceEvaluateView_h */

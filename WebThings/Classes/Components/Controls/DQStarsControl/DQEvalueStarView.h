//
//  DQEvalueStarView.h
//  WebThings
//
//  Created by winton on 2017/10/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DQEvalueStarView;
@protocol DQEvalueStarViewDelegate <NSObject>
- (void)starsControl:(DQEvalueStarView *)starsView
      didChangeScore:(CGFloat)score;
@end

@interface DQEvalueStarView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                    leftTitle:(NSString *)title;

/** 点亮星星发生变化 */
@property (nonatomic, weak) id<DQEvalueStarViewDelegate>delegate;
/** 获得的分数 */
@property (nonatomic, assign, readonly) CGFloat scale;

/** 星星总的数量
 *  default：5
 */
@property (nonatomic, assign) NSInteger starTotalNumber;
/** 选中星星的数量，可通过此参数设置默认选中星星个数
 *  default：星星总数
 */
@property (nonatomic, assign) CGFloat selectedStarNumber;
/** 最少选中星星数
 *  default：1
 */
@property (nonatomic, assign) CGFloat minSelectedNumber;

/** 是否可触摸
 *  default：YES
 */
@property (nonatomic, assign) BOOL touchEnable;
/** 是否允许滑动选择（在touchEnable = YES的前提下才有意义）
 *  default：YES
 */
@property (nonatomic, assign) BOOL scrollSelectEnable;

/** 是否需要半分
 *  default：NO
 */
@property (nonatomic, assign) BOOL isNeedHalf;
/** 底部视图的颜色
 *  default：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *bgViewColor;

@end

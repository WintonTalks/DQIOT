//
//  EMI_MaterialSeachBar.h
//  WebThings
//
//  Created by machinsight on 2017/6/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMI_MaterialSeachBar;
@protocol EMI_MaterialSeachBarDelegate <NSObject>

@optional
/** 搜索框显示调用 */
- (void)EMI_MaterialSeachBarDidShow;
/** 点击搜索后调用 */
- (void)EMI_MaterialSeachBarReturnKeyClicked:(NSString *)text;
/** 放弃搜索后调用 */
- (void)EMI_MaterialSeachBarDismissed;
@end

@interface EMI_MaterialSeachBar : UIView

@property (nonatomic,weak) id<EMI_MaterialSeachBarDelegate> delegate;

@property (nonatomic, copy) NSString *palceHodlerString;

- (void)showWithFatherV:(UIView *)fatherV;

- (void)becomeFirstResponder;

- (void)dismiss;
@end

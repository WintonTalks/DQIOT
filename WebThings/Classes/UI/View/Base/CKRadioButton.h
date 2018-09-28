//
//  CKRadioButton.h
//  WebThings
//
//  Created by machinsight on 2017/6/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CKRippleButton.h"
@class CKRadioButton;
NS_ASSUME_NONNULL_BEGIN
@protocol CKRadioButtonDelegate <NSObject>

@optional

/**
 按钮点击回调

 @param btn 按钮
 */
- (void)btnClicked:(CKRadioButton *)btn;

@end
NS_ASSUME_NONNULL_END
IB_DESIGNABLE
@interface CKRadioButton : CKRippleButton
/**
 状态
 */
@property(nonatomic) IBInspectable BOOL isOn;

/**
 代理
 */
@property(null_unspecified,nonatomic) IBInspectable id<CKRadioButtonDelegate> delegate;
@end


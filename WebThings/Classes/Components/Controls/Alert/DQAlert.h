//
//  DQAlert.h
//  WebThings
//
//  Created by Heidi on 2017/9/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQAlert_h
#define DQAlert_h
#import <UIKit/UIKit.h>

@interface DQAlert : NSObject {
    UIView *_moduleView;
    UIView  *_viewFromBottom;
    UIView  *_blackViewBottom;
}

/** 自定义的Alert */
- (void)showAlertWithTitle:(NSString *)title
                     okBtn:(NSString *)okTitle
                 cancelBtn:(NSString *)strCancel
                   okClick:(DQActionBlock)okClick
               cancelClick:(DQActionBlock)cancel;

- (void)showAlertWithTitle:(NSString *)title
                      icon:(NSString *)imageName
                     okBtn:(NSString *)okTitle
                 cancelBtn:(NSString *)strCancel
                   okClick:(DQActionBlock)okClick
               cancelClick:(DQActionBlock)cancel;

/** 自定义的ActionSheet */
- (void)showActionSheetWithTitle:(NSString *)title
                           okBtn:(NSArray *)btnTitles
                       cancelBtn:(NSString *)strCancel
                           block:(DQActionBlock)block
                     cancelClick:(DQActionBlock)cancel;

/** 自定义View从中间弹出 */
- (void)showViewFromMiddle:(UIView *)view Animated:(BOOL)animated;
/** 自定义View从底部弹出 */
- (void)showViewFromBottom:(UIView *)view Animated:(BOOL)animated;
/** 收起底部层 */
- (void)dissmissBottom;
/** 收起中间的弹出层 */
- (void)dismissMiddleView;

@end

#endif /* DQAlert_h */

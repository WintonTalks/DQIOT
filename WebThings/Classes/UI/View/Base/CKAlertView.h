//
//  CKAlertView.h
//  WebThings
//
//  Created by machinsight on 2017/6/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CKAlertView;
@protocol CKAlertViewDelegate  <NSObject>
- (void)ckalert_sureBtnClicked:(CKAlertView *)sender;
@end
@interface CKAlertView : UIView
@property(nonatomic,strong)id<CKAlertViewDelegate> delegate;

- (void)setTitle:(NSString *)title Content:(NSString *)content;
@end

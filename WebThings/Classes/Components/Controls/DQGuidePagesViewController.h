//
//  DQGuidePagesViewController.h
//  WebThings
//
//  Created by winton on 2017/10/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DQGuidePagesVCDelegate <NSObject>
- (void)pushMainController;
@end

@interface DQGuidePagesViewController : UIViewController
// 初始化引导页
- (void)guidePageControllerWithImages;
+ (BOOL)isShow;
@property (nonatomic, weak) id<DQGuidePagesVCDelegate> delegate;
@end

//
//  EMIBaseViewController.h
//  WebThings
//
//  Created by machinsight on 2017/5/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@class EMIBaseViewController;
@protocol EMIBaseViewControllerDelegate <NSObject>

@optional

/**
 判断是否是来自下一个VC返回的，用来刷新数据
 */
- (void)didPopFromNextVC;

@end
@interface EMIBaseViewController : UIViewController

@property (nonatomic,  weak) id<EMIBaseViewControllerDelegate> basedelegate;

/** 导航条 */
@property (nonatomic, strong) MDCAppBar *appBar;
/** 导航条的高度 */
@property (nonatomic, readonly) CGFloat navigationBarHeight;
/** 用户基本信息 */
@property (nonatomic, strong) UserModel *baseUser;

/**
 转场方式
 0 左往右渐变
 1 右下角的floatactionButton转场
 2 卡片点击转场
 */
@property(nonatomic, assign) int pushType;
@property(nonatomic, strong) UIView *animationView;

@property(nonatomic, assign) CGRect cardVFrame;
@property(nonatomic, assign) CGRect tocardVFrame;

/**
 判断返回是不是租赁商

 @return 是否
 */
- (BOOL)isZuLin;

/**
 判断返回是不是CEO
 
 @return 是否
 */
- (BOOL)isCEO;

@end

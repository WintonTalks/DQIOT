//
//  AppDelegate.h
//  WebThings
//
//  Created by machinsight on 2017/5/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (void)storyBoradAutoLay:(UIView *)allView;

+ (void)storyBoardAutoLabelFont:(UIView *)allView;
+ (AppDelegate *)appDelegate;
/**
 改变mdtf的字体大小

 @param allView .
 @param scale .
 */
+ (void)MDTFAutoLabelFont:(UIView *)allView withScale:(CGFloat)scale;


//单例
+ (AppDelegate *)shareAppDelegate;

/**
 当前顶层控制器
 */
-(UIViewController*) getCurrentVC;

-(UIViewController*) getCurrentUIVC;

+ (UIView *)getMainView;
@end


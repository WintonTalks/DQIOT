//
//  AppDelegate.m
//  WebThings
//
//  Created by machinsight on 2017/5/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"
#import "AppDelegate+PushService.h"
#import "YYTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initWindow];
    [self initVoice];
    [self initBaiDuMap];
    [self initUmeng];
    [self initPushSettingsWithOptions:launchOptions];
    [self monitorNetworkStatus];

    return YES;
}

+ (AppDelegate *)appDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //[JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
    
    //[application setApplicationIconBadgeNumber:0];//小红点清0操作
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)storyBoradAutoLay:(UIView *)allView
{
    for (UIView *temp in allView.subviews) {
        
            temp.frame = CGRectMake1(temp.frame.origin.x, temp.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
            if (temp.subviews.count > 0) {
                [AppDelegate storyBoradAutoLay:temp];
            }
    }
}

//动态改变字体大小
+ (void)storyBoardAutoLabelFont:(UIView *)allView
{
    for (UIView *temp in allView.subviews) {
        
        //label
        if ([temp isKindOfClass:[UILabel class]]) {
            CGFloat fontSize = ((UILabel *)(temp)).font.pointSize;
            NSString *fontName = ((UILabel *)(temp)).font.fontName;
            ((UILabel *)(temp)).font = [UIFont fontWithName:fontName size:fontSize*autoSizeScaleY];
        }
        //UITextField
        if ([temp isKindOfClass:[UITextField class]]) {
            CGFloat fontSize = ((UITextField *)(temp)).font.pointSize;
            NSString *fontName = ((UITextField *)(temp)).font.fontName;
            ((UITextField *)(temp)).font = [UIFont fontWithName:fontName size:fontSize*autoSizeScaleY];
            [((UITextField *)(temp)) setValue:[UIFont fontWithName:fontName size:fontSize*autoSizeScaleY] forKeyPath:@"_placeholderLabel.font"];
        }
        //UITextView
        if ([temp isKindOfClass:[UITextView class]]) {
            CGFloat fontSize = ((UITextView *)(temp)).font.pointSize;
            NSString *fontName = ((UITextView *)(temp)).font.fontName;
            ((UITextView *)(temp)).font = [UIFont fontWithName:fontName size:fontSize*autoSizeScaleY];
        }
        //button
        if ([temp isKindOfClass:[UIButton class]]) {
            CGFloat fontSize = ((UIButton *)(temp)).titleLabel.font.pointSize;
            NSString *fontName = ((UIButton *)(temp)).titleLabel.font.fontName;
            ((UIButton *)(temp)).titleLabel.font = [UIFont fontWithName:fontName size:fontSize*autoSizeScaleY];
        }
        if (temp.subviews.count > 0) {
            [AppDelegate storyBoardAutoLabelFont:temp];
        }
    }
}

//动态改变字体大小
+ (void)MDTFAutoLabelFont:(UIView *)allView withScale:(CGFloat)scale
{
    for (UIView *temp in allView.subviews) {
        
        //label
        if ([temp isKindOfClass:[UILabel class]]) {
            CGFloat fontSize = ((UILabel *)(temp)).font.pointSize;
            NSString *fontName = ((UILabel *)(temp)).font.fontName;
            ((UILabel *)(temp)).font = [UIFont fontWithName:fontName size:fontSize*scale];
        }
        //UITextField
        if ([temp isKindOfClass:[UITextField class]]) {
            CGFloat fontSize = ((UITextField *)(temp)).font.pointSize;
            NSString *fontName = ((UITextField *)(temp)).font.fontName;
            ((UITextField *)(temp)).font = [UIFont fontWithName:fontName size:fontSize*scale];
            [((UITextField *)(temp)) setValue:[UIFont fontWithName:fontName size:fontSize*scale] forKeyPath:@"_placeholderLabel.font"];
        }
        //UITextView
        if ([temp isKindOfClass:[UITextView class]]) {
            CGFloat fontSize = ((UITextView *)(temp)).font.pointSize;
            NSString *fontName = ((UITextView *)(temp)).font.fontName;
            ((UITextView *)(temp)).font = [UIFont fontWithName:fontName size:fontSize*scale];
        }
        //button
        if ([temp isKindOfClass:[UIButton class]]) {
            CGFloat fontSize = ((UIButton *)(temp)).titleLabel.font.pointSize;
            NSString *fontName = ((UIButton *)(temp)).titleLabel.font.fontName;
            ((UIButton *)(temp)).titleLabel.font = [UIFont fontWithName:fontName size:fontSize*scale];
        }
        if (temp.subviews.count > 0) {
            [AppDelegate MDTFAutoLabelFont:temp withScale:scale];
        }
    }
}

CG_INLINE CGRect//注意：这里的代码要放在.m文件最下面的位置
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX; rect.origin.y = y * autoSizeScaleY;
    rect.size.width = width * autoSizeScaleX; rect.size.height = height * autoSizeScaleY;
    return rect;
}

+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    if ([result isKindOfClass:[EMINavigationController class]]) {
        result = ((EMINavigationController *)result).viewControllers[0];
    }
    if ([result isKindOfClass:[YYTabBarController class]]) {
        result = ((YYTabBarController *)result).selectedViewController;
        if ([result isKindOfClass:[EMINavigationController class]]) {
            result = ((EMINavigationController *)result).viewControllers[0];
        }
    }
    return result;
}

- (UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}

+ (UIView *)getMainView {
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (!window)
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        return [window subviews].lastObject;
    } else {
        UIWindow *window =[[UIApplication sharedApplication] keyWindow];
        if (window == nil)
            window = [[[UIApplication sharedApplication] delegate] window];//#14
        return window;
    }
}

@end

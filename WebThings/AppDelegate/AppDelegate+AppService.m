//
//  AppDelegate+AppService.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/19.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "YYTabBarController.h"
#import "iflyMSC/IFlyMSC.h"
#import "UMMobClick/MobClick.h"
#import "Definition.h"
#import "AFNetworkReachabilityManager.h"
#import "NewLoginViewController.h"
#import "EMINavigationController.h"
#import "DQGuidePagesViewController.h" //引导页

@interface AppDelegate ()<DQGuidePagesVCDelegate>

@end

@implementation AppDelegate (AppService)

#pragma mark ————— 初始化window —————
- (void)initWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [NSThread sleepForTimeInterval:0.2];
    
    BOOL guideManger = [DQGuidePagesViewController isShow];
    if (guideManger) {
        DQGuidePagesViewController *pageVC = [[DQGuidePagesViewController alloc] init];
        pageVC.delegate = self;
        [pageVC guidePageControllerWithImages];
        self.window.rootViewController = pageVC;
    } else {
        [self showManageRootVC];
    }
    [self.window makeKeyAndVisible];
}

#pragma mark -DQGuidePagesVCDelegate
- (void)pushMainController
{
    [self showManageRootVC];
}

- (void)showManageRootVC
{
    if (safeUserDefaultObjectForKey(KUserLoginKey)) {
        UserModel *user = [AppUtils readUser];
        if ([user.usertype isEqualToString:@"工人"] || [user.usertype isEqualToString:@"司机"]) {
            self.window.rootViewController = [[EMINavigationController alloc] initWithRootViewController:[NewLoginViewController new]];
        } else {
            self.window.rootViewController = [[YYTabBarController alloc] init];
        }
    } else {
        self.window.rootViewController = [[EMINavigationController alloc] initWithRootViewController:[NewLoginViewController new]];
    }
}

#pragma mark ————— 初始化讯飞语音 —————
- (void)initVoice{
    //    <#!!!特别提醒：                                                                #>
    //
    //    <#  1、在集成讯飞语音SDK前请特别关注下面设置，主要包括日志文件设置、工作路径设置和appid设置。#>
    //
    //    <#2、在启动语音服务前必须传入正确的appid。#>
    //
    //    <#3、SDK运行过程中产生的音频文件和日志文件等都会保存在设置的工作路径下。#>
    
    
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

/// 初始化百度地图
- (void)initBaiDuMap{
    BMKMapManager *_mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:baiduid  generalDelegate:nil];
    if (!ret) {
        DQLog(@"manager start failed!");
    }
}

/// 初始化友盟
- (void)initUmeng {
    UMConfigInstance.appKey = KEY_UMENG;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
}

#pragma mark -
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [[IFlySpeechUtility getUtility] handleOpenURL:url];
    return YES;
}

- (void)monitorNetworkStatus{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                //未知网络
                DQLog(@"未知网络");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                //无法联网
                DQLog(@"无法联网");
                MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"网络连接已断开" actionTitle:@"" duration:3.0];
                [t show];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //手机自带网络
                DQLog(@"当前使用的是2g/3g/4g网络");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                //WIFI
                DQLog(@"当前在WIFI网络下");
            }
                
        }
    }];
}




@end

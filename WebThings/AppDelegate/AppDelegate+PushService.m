//
//  AppDelegate+PushService.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/25.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "AppDelegate+PushService.h"
#import "PushModel.h"
#import "PushAlert.h"
#import "AddProjectModel.h"
#import "DeviceModel.h"
#import "ServiceStreamViewController.h"


@interface AppDelegate()<JPUSHRegisterDelegate>

@end
@implementation AppDelegate (PushService)
- (void)initPushSettingsWithOptions:(NSDictionary *)launchOptions{
    
    // 注册app icon角标iOS8需要设置
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    //推送
    //1.添加初始化APNs代码
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //2.添加初始化JPush代码
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    
    //    appKey
    //
    //    填写管理Portal上创建应用后自动生成的AppKey值。请确保应用内配置的 AppKey 与 Portal 上创建应用后生成的 AppKey 一致。
    //
    //    channel
    //
    //    指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
    //
    //    apsForProduction
    //
    //    1.3.1版本新增，用于标识当前应用所使用的APNs证书环境。
    //    0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。
    //    注：此字段的值要与Build Settings的Code Signing配置的证书环境一致。
    //
    //    advertisingIdentifier
    
    [JPUSHService setupWithOption:launchOptions appKey:jpushappkey
                          channel:@"pugongying"
                 apsForProduction:1
            advertisingIdentifier:nil];
}


//推送代理方法
//注册APNs成功并上报DeviceToke
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//实现注册APNs失败接口（可选）

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DQLog(@"注册极光推送出现如下错误: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
//应用在前台会进入这个方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    [self handleDataWithRemoteNotification:userInfo];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    [self handleDataWithRemoteNotification:userInfo];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self handleDataWithRemoteNotification:userInfo];
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self handleDataWithRemoteNotification:userInfo];
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)handleDataWithRemoteNotification:(NSDictionary *)userInfo{
    
    NSString *dataStr = [userInfo objectForKey:@"data"];
    NSDictionary *dataDic;
    if (dataStr) {
        dataDic = [NSDictionary mj_objectWithKeyValues:dataStr];
        
        //[DictIntoModel dictionaryWithJsonString:dataStr];
    }
    PushModel *pushM;
    if (dataDic) {
        pushM = [PushModel mj_objectWithKeyValues:dataDic];
    }
    if (pushM) {
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
            //前台
            if (pushM.state == 99) {
                //故障通知
                PushAlert *al = [[PushAlert alloc] init];
                al.m = pushM;
                [al show];
            }
            
        } else {
            UIViewController *currentVC = [self getCurrentVC];
            //后台
            ServiceStreamViewController *VC = [AppUtils VCFromSB:@"Main" vcID:@"ServiceStreamVC"];
            
            AddProjectModel *apm = [[AddProjectModel alloc] init];
            apm.projectid = pushM.projectid;
            apm.drivertype = pushM.drivertype;
            
            DeviceModel *dm = [[DeviceModel alloc] init];
            dm.deviceid = pushM.deviceid;
            dm.projectdeviceid = pushM.projectdeviceid;
            dm.installationsite = pushM.address;
            dm.deviceno = pushM.deviceno;
            
            VC.projectid = pushM.projectid;
            VC.drivertype = pushM.drivertype;
            VC.dm = dm;
            VC.projectModel = apm;
            
            if (![pushM.usertype isEqualToString:@"司机"] && ![pushM.usertype isEqualToString:@"工人"]) {
                [currentVC.navigationController pushViewController:VC animated:YES];
            }
        }
    }
//    {
//        "_j_business" = 1;
//        "_j_msgid" = 9007199526199667;
//        "_j_uid" = 10511226088;
//        aps =     {
//            alert = "\U6d4b\U8bd5";
//            badge = 1;
//            sound = happy;
//        };
//        data = "{\"message\":\"test\"}";
//    }
}

@end

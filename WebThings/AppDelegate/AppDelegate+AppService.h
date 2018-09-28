//
//  AppDelegate+AppService.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/19.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "AppDelegate.h"

#define ReplaceRootViewController(vc) [[AppDelegate shareAppDelegate] replaceRootViewController:vc]

/**
 包含第三方 和 应用内业务的实现，减轻入口代码压力
 */
@interface AppDelegate (AppService)

//初始化 window
-(void)initWindow;

/**
 初始化 讯飞语音识别
 */
- (void)initVoice;

/**
 初始化百度地图
 */
- (void)initBaiDuMap;

/**
 初始化Umeng
 */
- (void)initUmeng;

//监听网络状态
- (void)monitorNetworkStatus;
@end

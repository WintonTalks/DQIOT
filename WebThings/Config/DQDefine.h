//
//  DQAPIDefine.h
//  WebThings
//
//  Created by Heidi on 2017/9/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQResultModel.h"

typedef void (^DQProcessBlock) (CGFloat percent);
typedef void (^DQActionBlock) (NSInteger index);
typedef void (^DQSuccessBlock) (DQResultModel *returnValue);
typedef void (^DQResultBlock) (id result);
typedef void (^DQResult2Block) (id result1, id result2);
typedef void (^DQFailureBlock) (NSError *error);

typedef void(^DQAddressCoordinate)(double lat, double lng);
typedef void(^DQAddressReverse)(NSString *address, NSString *cityCode);

// -------------------------------- Brief -------------------------------------------
#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height
#define autoSizeScaleX [[UIScreen mainScreen] bounds].size.width/375.0f
#define autoSizeScaleY [[UIScreen mainScreen] bounds].size.height/667.0f
#define APPDELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate
#define  saveUserDefault(sys, key)    [[NSUserDefaults standardUserDefaults] setObject:sys forKey:key];
#define  safeUserDefaultObjectForKey(key)      [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define  removeUserDefault(key)       [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define IS_IOS10      [[[UIDevice currentDevice] systemVersion] integerValue] < 11.0
#define IS_IOS11      [[[UIDevice currentDevice] systemVersion] integerValue] >= 11.0


// -------------------------------- Keys -------------------------------------------
#pragma mark - Keys
#define baiduid @"eL4kQUGTAMphXVoAxz25UEwpYgfiSKB4"//百度地图密钥
//极光推送的appkey
#define jpushappkey @"669c69daf0434d6ef8d88a7c"
#define PGY_APP_ID @"e12ae251963bc0858e6b5aa3ddddf78b"
#define KEY_UMENG @"59b9f9edaed179715f00001a"       // 友盟Key

// -------------------------------- 简写代码 -------------------------------------------
#pragma mark -
#define RGB_Color(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define Font(f) [UIFont systemFontOfSize:f]
#define ImageNamed(n) [UIImage imageNamed:n]
#define ADDURL(url)   [NSURL URLWithString:appendUrl(IMAGEURL, url)]

// -------------------------------- 颜色值 -------------------------------------------
#pragma mark - Color
#define COLOR_BG @"#EFEFF3"             // 底色
#define COLOR_LINE @"#E1E1E1"           // 分割线灰色
#define COLOR_BLACK @"#303030"          // 主色黑
#define COLOR_GRAY @"#DDDDDD"           // 不可用灰色字体
#define COLOR_SUBTITLE @"BAB9B9"        // 说明文字灰色
#define COLOR_TITLE_GRAY  @"#CACACA"    // 字体灰色.输入以前默认

#define COLOR_BTN_BLUE @"#417EE8"       // 按钮蓝色

#define COLOR_ORANGE @"#F19E39"         // 选中的橘黄色

#define COLOR_GREEN_LIGHT @"#F7F9E1"    // 背景淡绿色
#define COLOR_BLUE_LIGHT @"#BBCDEE"     // 背景淡蓝色
#define COLOR_RED_LIGHT @"#FFE7DF"      // 背景淡红色

#define COLOR_GREEN @"#92C15F"    // 边框／字体绿色
#define COLOR_BLUE @"#407EE9"     // 边框／字体蓝色
#define COLOR_RED @"#F94141"      // 边框/字体红色

// -------------------------------- String -------------------------------------------
#pragma mark - String
#define appendUrl(x,y) [NSString stringWithFormat:@"%@%@",x,y]

#define robot_originstr @"我是AI小维，请问需要我做什么?"//机器人初始化问候句
#define robot_speakoriginstr @"我是A I小维，请问需要我做什么?"//机器人初始化问候句
#define STRING_NONETWORK        @"没有网络连接, 请检查网络设置后重试！"
#define STRING_APIEXCEPTION     @"数据异常"
#define STRING_REQUESTFAIL     @"请求失败"

#define STRING_SERVICE_PLACEHOLDER @"服务满足你的期待吗？说说服务的优点和美中不足的地方吧"

#pragma mark - Tags
#define TAG_ACTIONSHEET     10000

#pragma mark - 宏值
#define kString_DateFormatter @"yyyy/MM/dd hh:mm"
#define kString_DateNoTimeFormatter @"yyyy/MM/dd"

#define kNUMBER_MAXPHOTO  6                     // 上传图片数量最大限制

#define kHEIHGT_SPACE 16                        // 默认间距高度
#define kHEIHGT_BILLCELL 30                     // 单据Cell高度
#define kWIDTH_BILLCELL screenWidth - 208       // 单据Cell宽度
#define kHEIHGT_REPORTCELL 47                   // 设备报告单／费用清单等Cell高度



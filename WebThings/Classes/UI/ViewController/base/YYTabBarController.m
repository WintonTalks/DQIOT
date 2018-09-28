//
//  YYTabBarController.m
//  yunya
//
//  Created by WongSuechang on 16/3/17.
//  Copyright © 2016年 emi365. All rights reserved.
//

#import "YYTabBarController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "RDVTabBarItem.h"
#import "EMINavigationController.h"
#import "BusinessCenterViewController.h"
#import "MeViewController.h"
#import "WorkDeskViewController.h"
#import "DQDeviceCenterController.h"

@interface YYTabBarController ()<RDVTabBarControllerDelegate, AVAudioPlayerDelegate>
{
    SystemSoundID _soundFileObject;
}

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器

@end

@implementation YYTabBarController

- (instancetype)init
{
    self = [super init];
    if(self){
        self.delegate = self;
        self.tabBar.frame = CGRectMake(0, 0, screenWidth, 52);
        self.tabBar.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self dropShadowWithOffset:CGSizeMake(0, -2.0f)
                            radius:1
                             color:[UIColor colorWithHexString:@"#DCDCDC" alpha:0.5]
                           opacity:0.2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewControllers];
}

- (void)setViewControllers
{
    EMINavigationController *Nav1 = [[EMINavigationController alloc] initWithRootViewController:[AppUtils VCFromSB:@"Main" vcID:@"BusinessCenterVC"]];
    EMINavigationController *Nav2 = [[EMINavigationController alloc] initWithRootViewController:[[DQDeviceCenterController alloc] init]];
    //    EMINavigationController *Nav3 = [[EMINavigationController alloc] initWithRootViewController:[[ViewController1 alloc] init]];
    //    EMINavigationController *Nav4 = [[EMINavigationController alloc] initWithRootViewController:[VCFromSB VCFromSB:@"Work" vcID:@"WorkDeskVC"]];
    EMINavigationController *Nav5 = [[EMINavigationController alloc] initWithRootViewController:[MeViewController new]];
    self.viewControllers = @[Nav1,Nav2,Nav5];//@[Nav1,Nav2,Nav3,Nav4,Nav5]
    
    [self customizeTabBarForController];
}

- (void)customizeTabBarForController
{
    //    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    //    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSMutableArray *tabBarItemImages = [NSMutableArray array];
    
    for (int i = 1; i <= 5; i++) {
        
        if(i != 3 && i!= 4){
            [tabBarItemImages addObject:[NSString stringWithFormat:@"tab_%d",i]];
        }
        
    }
    
    NSArray *titles = @[@"项目", @"设备", @"我"];
    NSInteger index = 0;
    UIColor *color = [UIColor colorWithHexString:@"417EE8"];
    UIColor *normalColor = [UIColor colorWithHexString:@"B2B9C5"];
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        //        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_unselected",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:titles[index]];
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            item.selectedTitleAttributes = @{
                                             NSFontAttributeName: [UIFont dq_mediumSystemFontOfSize:10],
                                             NSForegroundColorAttributeName:color
                                             };
            item.unselectedTitleAttributes = @{ NSFontAttributeName:[UIFont dq_mediumSystemFontOfSize:10],
                                                NSForegroundColorAttributeName:normalColor};
            
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            item.selectedTitleAttributes = @{
                                             UITextAttributeFont: [UIFont dq_mediumSystemFontOfSize:10],
                                             UITextAttributeTextColor: color,
                                             };
            item.unselectedTitleAttributes = @{ NSFontAttributeName:[UIFont dq_mediumSystemFontOfSize:10],
                                                NSForegroundColorAttributeName:normalColor};
#endif
        }
        
        index++;
    }
}

/**
 tababr加阴影
 
 @param offset 偏移量
 @param radius 圆角w
 @param color 颜色
 @param opacity 透明度
 */
- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.tabBar.clipsToBounds = NO;
}

- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    switch (tabBarController.selectedIndex) {
        case 0:
            [MobClick event:@"businesscenter_tababr"];
            break;
        case 1:
            [MobClick event:@"datacenter_tabbar"];
            break;
        case 2:
            [MobClick event:@"usercenter_tabbar"];
            break;
        default:
            break;
    }
}

- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController AtIndex:(NSInteger)index{
    //    if (index == 2) {
    //        [((EMINavigationController *)self.selectedViewController).viewControllers[0].navigationController presentViewController:[VCFromSB VCFromSB:@"Robot" vcID:@"RobotChatVC"]  animated:YES completion:nil];
    //        return NO;
    //    }else{
    return YES;
    //    }
}

- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController AtIndex:(NSInteger)index {
    // 点击音效
    [self playAudioFileWith:@"DQ_btn" andType:@"m4a"];
//    [self playSoundEffect:@"DQ_btn" type:@"m4a"];
}

#pragma mark - 播放音频
- (void)playSoundEffect:(NSString *)name type:(NSString *)type {
    [[self audioPlayer] play];
}

- (AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"DQ_btn" ofType:@"m4a"];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        NSError *error = nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops = 0;//设置为0不循环
        _audioPlayer.delegate = self;
        _audioPlayer.volume = 0.3;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error) {
            NSLog(@"初始化播放器过程发生错误,错误信息:%@", error.localizedDescription);
            return nil;
        }
        //设置后台播放模式
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        //        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        [audioSession setActive:YES error:nil];
    }
    return _audioPlayer;
}

// 播放音频
- (void)playAudioFileWith:(NSString *)soundName andType:(NSString *)soundType{
    // 获取路径
    NSURL * fileUrl = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:soundName ofType:soundType]];
    // 系统API播放
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl, &_soundFileObject);
    //  播放音频
    AudioServicesPlaySystemSound(_soundFileObject);
    //  播放音频+震动
    //    AudioServicesPlayAlertSound(_soundFileObject);
}


@end

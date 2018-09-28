//
//  EMINavigationController.m
//  taojin
//
//  Created by machinsight on 17/3/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMINavigationController.h"
#import "BusinessCenterViewController.h"
#import "DQDeviceCenterController.h"
#import "WorkDeskViewController.h"
#import "MeViewController.h"

@interface EMINavigationController ()
/** 导航条 */
@property (nonatomic, strong) MDCAppBar *appBar;
@end

@implementation EMINavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/**
 *  当导航控制器的view创建完毕就调用
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 *  当第一次使用这个类的时候调用1次
 */
+ (void)initialize
{
    // 设置UINavigationBarTheme的主
    [self setupNavigationBarTheme];
    
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
}

/**
 *  设置UINavigationBarTheme的主题
 */
+ (void)setupNavigationBarTheme {
    
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    // 设置导航栏背景
    appearance.barTintColor = [UIColor whiteColor];
    appearance.barStyle = UIBarStyleBlack;
    appearance.translucent = YES;
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#151617"];
    textAttrs[NSFontAttributeName] = [UIFont dq_semiboldSystemFontOfSize:18.0];
    [appearance setTitleTextAttributes:textAttrs];
    
    [appearance setShadowImage:[UIImage new]];
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#222627"];
    textAttrs[NSFontAttributeName] = [UIFont dq_semiboldSystemFontOfSize:18.0];
    //    textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#222627"];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    /**设置背景**/
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
//    [appearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        // 设置导航栏按钮
        if(![viewController isKindOfClass:[BusinessCenterViewController class]]
           ||![viewController isKindOfClass:[DQDeviceCenterController class]]
           ||![viewController isKindOfClass:[MeViewController class]]){//||![viewController isKindOfClass:[WorkDeskViewController class]]
            [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
        }
        viewController.navigationItem.hidesBackButton = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:@"back"]];
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    NSArray *array = self.viewControllers;
    if(array.count>1){
        UIViewController *destinationviewController = array[1];
        if([destinationviewController isKindOfClass:[BusinessCenterViewController class]]
           ||[destinationviewController isKindOfClass:[DQDeviceCenterController class]]
           ||[destinationviewController isKindOfClass:[MeViewController class]]){//||[destinationviewController isKindOfClass:[WorkDeskViewController class]]
            [[destinationviewController rdv_tabBarController] setTabBarHidden:NO animated:NO];
        }else{
            [[destinationviewController rdv_tabBarController] setTabBarHidden:YES animated:NO];
        }
    }else{
        [[viewController rdv_tabBarController] setTabBarHidden:NO animated:NO];
    }
    
    return viewController;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *array = self.viewControllers;
    UIViewController *viewController = array[0];
    [[viewController rdv_tabBarController] setTabBarHidden:NO animated:NO];
    [super popToRootViewControllerAnimated:animated];
    return array;
}

/**
 *  拦截所有push进来的子控制器
 */
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if([viewController isKindOfClass:[BusinessCenterViewController class]]
       ||[viewController isKindOfClass:[DQDeviceCenterController class]]
       ||[viewController isKindOfClass:[MeViewController class]]){//||[viewController isKindOfClass:[WorkDeskViewController class]]
        [[viewController rdv_tabBarController] setTabBarHidden:YES animated:NO];
    } else {
        [[viewController rdv_tabBarController] setTabBarHidden:NO animated:NO];
    }
    return [super popToViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

+ (void)addAppBar:(EMIBaseViewController *)VC {
    [[self class] addAppBar:VC shadowColor:[UIColor colorWithHexString:@"#CBCCCD"]];
}

+ (void)addAppBar:(EMIBaseViewController *)VC shadowColor:(UIColor *)color {
    [[self class] addAppBar:VC barHeight:69.0 shadowColor:color];
}

+ (void)addAppBar:(EMIBaseViewController *)VC barHeight:(CGFloat)barHeight shadowColor:(UIColor *)color {
    [[self class] addAppBar:VC barHeight:barHeight barTitleAlignment:MDCNavigationBarTitleAlignmentCenter shadowColor:color];
}

+ (void)addAppBar:(EMIBaseViewController *)VC barTitleAlignment:(MDCNavigationBarTitleAlignment)titleAlignment shadowColor:(UIColor *)color {
    [[self class] addAppBar:VC barHeight:69.0 barTitleAlignment:titleAlignment shadowColor:color];
}

+ (void)addAppBar:(EMIBaseViewController *)VC barHeight:(CGFloat)barHeight barTitleAlignment:(MDCNavigationBarTitleAlignment)titleAlignment shadowColor:(UIColor *)color {
    
    MDCAppBar *_appBar = [[MDCAppBar alloc] init];
    _appBar.navigationBar.titleAlignment = titleAlignment;
    _appBar.headerViewController.headerView.backgroundColor  =  [UIColor whiteColor];
    
    _appBar.navigationBar.tintColor = [UIColor blackColor];
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#222627"];
    textAttrs[NSFontAttributeName] = [UIFont dq_semiboldSystemFontOfSize:18.0];
    _appBar.navigationBar.titleTextAttributes = textAttrs;
    [VC addChildViewController:_appBar.headerViewController];
    
    [self dropShadowWithOffset:CGSizeMake(0, 1) radius:1 color:color opacity:1 aimView:_appBar.headerViewController.headerView];
    // After all other views have been registered.
    [_appBar addSubviewsToParent];
    [_appBar.headerViewController.headerView setFrame:CGRectMake(0, 0, screenWidth, barHeight)];
    VC.appBar = _appBar;
}


/**
 app_bar 的navigationbar加阴影
 
 @param offset 偏移量
 @param radius 圆角
 @param color 颜色
 @param opacity 透明度
 */
+ (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity
                     aimView:(UIView *)aimView{
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, aimView.bounds);
    aimView.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    aimView.layer.shadowColor = color.CGColor;
    aimView.layer.shadowOffset = offset;
    aimView.layer.shadowRadius = radius;
    aimView.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    aimView.clipsToBounds = NO;
}


@end

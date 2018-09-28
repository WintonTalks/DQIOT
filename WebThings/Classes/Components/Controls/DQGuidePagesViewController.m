//
//  DQGuidePagesViewController.m
//  WebThings
//
//  Created by winton on 2017/10/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQGuidePagesViewController.h"

@interface DQGuidePagesViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *infoScrollView;
@property (nonatomic, strong) UIPageControl *infoPageControl;
@end
#define VERSION_INFO_CURRENT @"currentversion"

@implementation DQGuidePagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}
// 初始化引导页
- (void)guidePageControllerWithImages
{
    _infoScrollView  = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _infoScrollView.backgroundColor = [UIColor clearColor];
    _infoScrollView.delegate = self;
    _infoScrollView.showsVerticalScrollIndicator = false;
    _infoScrollView.showsHorizontalScrollIndicator = false;
    _infoScrollView.bounces = true;
    _infoScrollView.pagingEnabled = true;
    _infoScrollView.contentSize = CGSizeMake(screenWidth*3, screenHeight);
    [self.view addSubview:_infoScrollView];
   
    NSArray *addImages = @[ImageNamed(@"icon_scr_page1"),ImageNamed(@"icon_scr_page2"),ImageNamed(@"icon_scr_page3")];
    NSInteger index = 0;
    for (UIImage *image in addImages) {
        UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth*index, 0, screenWidth, screenHeight)];
        picView.image = image;
        picView.contentMode = UIViewContentModeScaleAspectFill;
        [_infoScrollView addSubview:picView];
        if (index == 2) {
            picView.userInteractionEnabled = true;
            [picView addSubview:[self createTopButton]];
        }
        index++;
    }
    _infoPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, screenWidth/2, 20)];
    _infoPageControl.backgroundColor = [UIColor clearColor];
    _infoPageControl.center = CGPointMake(screenWidth/2, screenHeight-20);
    _infoPageControl.numberOfPages = 3;
    _infoPageControl.currentPage = 0;
    _infoPageControl.pageIndicatorTintColor = [UIColor grayColor];
    _infoPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:_infoPageControl];
}

- (UIButton *)createTopButton
{
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topButton.frame = CGRectMake((screenWidth-296/2)/2, screenHeight-(102*autoSizeScaleY), 296/2, 64);
    [topButton setImage:ImageNamed(@"icon_scr_round") forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(onTopMainBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *text = @"立 即 体 验";
    UIFont *font = [UIFont dq_regularSystemFontOfSize:18];
    CGFloat width = [AppUtils textWidthSystemFontString:text height:20 font:font];
    UILabel *onTopLabel = [[UILabel alloc] initWithFrame:CGRectMake((topButton.width-width)/2, (topButton.height-25)/2, width, 20)];
    onTopLabel.text = text;
    onTopLabel.font = font;
    onTopLabel.textColor = [UIColor whiteColor];
    onTopLabel.textAlignment = NSTextAlignmentCenter;
    [topButton addSubview:onTopLabel];
    return topButton;
}

- (void)onTopMainBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushMainController)]) {
        [self.delegate pushMainController];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentpage = scrollView.contentOffset.x/scrollView.width;
    _infoPageControl.currentPage = currentpage;
}

+ (BOOL)isShow
{
    // 读取版本信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [user objectForKey:VERSION_INFO_CURRENT];
    NSString *currentVersion =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (localVersion == nil || ![currentVersion isEqualToString:localVersion]) {
        [DQGuidePagesViewController saveCurrentVersion];
        return true;
    } else {
        return false;
    }
}

// 保存版本信息
+ (void)saveCurrentVersion
{
    NSString *version =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:version forKey:VERSION_INFO_CURRENT];
    [user synchronize];
}

@end

//
//  EMIBaseWebViewController.m
//  WebThings
//
//  Created by machinsight on 2017/7/21.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMIBaseWebViewController.h"
#import "MBProgressHUD.h"

@interface EMIBaseWebViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webV;
@end

@implementation EMIBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _thisTitle;
    [self initView];
    //[EMINavigationController addAppBar:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView{
    _webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, screenWidth, screenHeight-self.navigationBarHeight)];
    _webV.scrollView.showsVerticalScrollIndicator = NO;
    _webV.scrollView.showsHorizontalScrollIndicator = NO;
    _webV.scrollView.backgroundColor = [UIColor whiteColor];

    NSString *str = @"";
    if ([_thisTitle isEqualToString:@"关于我们"]) {
        _webV.scrollView.scrollEnabled = NO;
        str = @"about";
    }else{
        str = @"service";
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    
    [_webV loadHTMLString:htmlString baseURL:baseURL];
    _webV.delegate = self;
    [self.view addSubview:_webV];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end

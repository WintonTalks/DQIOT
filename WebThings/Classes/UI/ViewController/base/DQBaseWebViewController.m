//
//  DQBaseWebViewController.m
//  WebThings
//
//  Created by Heidi on 2017/9/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQBaseWebViewController.h"
#import <WebKit/WebKit.h>

#import "DQDefine.h"

@interface DQBaseWebViewController () <WKNavigationDelegate> {
    WKWebView *_webView;
    UIProgressView *_progressView;
}

@end

@implementation DQBaseWebViewController

#pragma mark - View life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _webView.navigationDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        _webView.navigationDelegate = nil;

    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _navTitle;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 65, screenWidth, screenHeight - 64)];
    _webView.scrollView.backgroundColor = [UIColor whiteColor];

    if (_url.length > 0) {
        NSString *urlStr = [_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:urlRequest];
    } else if (_fileName.length > 0 ) {
        NSString *path = [[NSBundle mainBundle] pathForResource:_fileName ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSString *basePath = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:basePath];
        [_webView loadHTMLString:htmlString baseURL:baseURL];
    }
    [self.view addSubview:_webView];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 1)];
    _progressView.tintColor = [UIColor colorWithHexString:COLOR_BLUE];
    _progressView.trackTintColor = [UIColor whiteColor];
    [self.view insertSubview:_progressView aboveSubview:_webView];
    
    //[EMINavigationController addAppBar:self];
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        [_progressView setAlpha:1.0f];
        [_progressView setProgress:_webView.estimatedProgress animated:YES];
        if(_webView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [_progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -  WKNavigationDelegate来追踪加载过程
    /// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
    /// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
    /// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}
    /// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end


//  DQAlert.m
//  WebThings
//
//  Created by Heidi on 2017/9/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQAlert.h"
#import "DQDefine.h"
#import "AppDelegate.h"
#import "UIColor+Hex.h"
#import "AppUtils.h"

@interface DQAlert ()

@property (nonatomic, copy) DQActionBlock actionBlock;
@property (nonatomic, copy) DQActionBlock cancelBlock;

@end
@implementation DQAlert

#pragma mark - 自定义的 AlertView
- (void)showAlertWithTitle:(NSString *)title
                     okBtn:(NSString *)okTitle
                 cancelBtn:(NSString *)strCancel
                   okClick:(DQActionBlock)okClick
               cancelClick:(DQActionBlock)cancel
{
    [self showAlertWithTitle:title icon:nil okBtn:okTitle cancelBtn:strCancel okClick:okClick cancelClick:cancel];
}

- (void)showAlertWithTitle:(NSString *)title
                      icon:(NSString *)imageName
                     okBtn:(NSString *)okTitle
                 cancelBtn:(NSString *)strCancel
                   okClick:(DQActionBlock)okClick
               cancelClick:(DQActionBlock)cancel
{
    self.actionBlock = okClick;
    self.cancelBlock = cancel;
    
    CGFloat height = 120;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGFloat width = window.frame.size.width;
    CGFloat widthView = width - 50;
    if (!_moduleView)
    {
        _moduleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthView, height)];
    }
    _moduleView.frame = CGRectMake(0, 0, widthView, height);
    _moduleView.backgroundColor = [UIColor whiteColor];
    _moduleView.layer.cornerRadius = 5.0;
    
    for (UIView *v in _moduleView.subviews)
    {
        [v removeFromSuperview];
    }
    
    CGFloat titleWidth = widthView - 20;
    CGSize size = [AppUtils
                   textSizeFromTextString:title
                   width:titleWidth
                   height:height - 50
                   font:[UIFont systemFontOfSize:16]];
    CGFloat x = (titleWidth - size.width) / 2.0;
    
    if (imageName.length > 0) {
        UIImage *image = [UIImage imageNamed:imageName];
        
        size = [AppUtils
                textSizeFromTextString:title
                width:(titleWidth - image.size.width - 10)
                height:height - 50
                font:[UIFont systemFontOfSize:16]];
    
        x = (titleWidth - size.width - 10 - image.size.width) / 2.0;

        UIImageView *iconView = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(x,
                                                          (height - 45 - image.size.height) / 2.0,
                                                          image.size.width, image.size.height)];
        iconView.image = [UIImage imageNamed:imageName];
        [_moduleView addSubview:iconView];
        x += image.size.width + 10;
    }
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, size.width, height - 45)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont systemFontOfSize:16];
    lblTitle.textAlignment = imageName.length > 0 ? NSTextAlignmentLeft :NSTextAlignmentCenter;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    lblTitle.text = title;
    [_moduleView addSubview:lblTitle];
    
    UIView *lineHor = [[UIView alloc] initWithFrame:CGRectMake(0, height - 45, widthView, 0.5)];
    lineHor.backgroundColor = RGB_Color(239, 239, 239, 1.0);
    [_moduleView addSubview:lineHor];
    
    UIColor *btnColor = [UIColor colorWithHexString:@"177ffc"];
    if (okTitle.length > 0)
    {
        UIView *lineVer = [[UIView alloc] initWithFrame:CGRectMake(widthView/2, height - 45, 0.5, 45)];
        lineVer.backgroundColor = [UIColor colorWithHexString:COLOR_LINE];
        [_moduleView addSubview:lineVer];
        
        UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOK.backgroundColor = [UIColor clearColor];
        [btnOK setTitleColor:btnColor forState:UIControlStateNormal];
        btnOK.frame = CGRectMake(widthView/2, height - 45, widthView/2, 45);
        btnOK.titleLabel.font = [UIFont systemFontOfSize:16];
        [btnOK addTarget:self action:@selector(onAlertOkClick) forControlEvents:UIControlEventTouchUpInside];
        [btnOK setTitle:okTitle forState:UIControlStateNormal];
        [_moduleView addSubview:btnOK];
    }
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.backgroundColor = [UIColor clearColor];
    [btnCancel setTitleColor:btnColor forState:UIControlStateNormal];
    btnCancel.frame = CGRectMake(0, height - 45, okTitle.length > 0 ? widthView/2 : widthView, 45);
    [btnCancel setTitle:strCancel forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnCancel addTarget:self action:@selector(onAlertCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_moduleView addSubview:btnCancel];
    
    [self showViewFromMiddle:_moduleView Animated:YES];
}

- (void)onAlertCancelClick
{
    [self dismissMiddleView];
    self.cancelBlock(0);
}

- (void)onAlertOkClick
{
    [self dismissMiddleView];
    self.actionBlock(0);
}

#pragma mark popup from middle
- (void)showViewFromMiddle:(UIView *)view Animated:(BOOL)animated
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGFloat width = app.window.frame.size.width;
    
    if (!_viewFromBottom) {
        _viewFromBottom = [[UIView alloc] init];
        _viewFromBottom.frame = CGRectMake(0, 0, width, app.window.frame.size.height);
        _viewFromBottom.backgroundColor = [UIColor clearColor];
        [_viewFromBottom setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
        [_viewFromBottom addSubview:view];
    }
    CGRect frame = view.frame;
    frame.origin.y = (app.window.frame.size.height - frame.size.height) / 2;
    frame.origin.x = (app.window.frame.size.width - frame.size.width) / 2;
    view.frame = frame;
    
    if (animated)
    {
        _blackViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, app.window.frame.size.height)];
        _blackViewBottom.backgroundColor = [UIColor blackColor];
        _blackViewBottom.alpha = 0.0;
        [app.window addSubview:_blackViewBottom];
        
        [app.window addSubview:_viewFromBottom];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBottom:)];
        [_viewFromBottom addGestureRecognizer:tap];

        [UIView transitionWithView:_viewFromBottom duration:0.15f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            _blackViewBottom.alpha = 0.3;
            [_viewFromBottom setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [app.window addSubview:_viewFromBottom];
    }
    
    [app.window bringSubviewToFront:_viewFromBottom];
}

- (void)showViewFromBottom:(UIView *)view Animated:(BOOL)animated
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!_viewFromBottom) {
        _viewFromBottom = [[UIView alloc] init];
        _viewFromBottom.frame = CGRectMake(0, 0, app.window.frame.size.width, app.window.frame.size.height);
        _viewFromBottom.backgroundColor = [UIColor clearColor];
        [_viewFromBottom addSubview:view];
    }
    __block CGRect frame = view.frame;
    frame.origin.y = app.window.frame.size.height;
    view.frame = frame;
    
    if (animated) {
        _blackViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, app.window.frame.size.width, app.window.frame.size.height)];
        _blackViewBottom.backgroundColor = [UIColor blackColor];
        _blackViewBottom.alpha = 0.3;
        [app.window addSubview:_blackViewBottom];
        
        [app.window addSubview:_viewFromBottom];
        
        [UIView transitionWithView:_viewFromBottom duration:0.15f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            frame.origin.y = app.window.frame.size.height - frame.size.height;
            view.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [app.window addSubview:_viewFromBottom];
    }
    
    [app.window bringSubviewToFront:_viewFromBottom];
}

#pragma mark remove bottom popview
- (void)dissmissBottom
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewFromBottom.frame = CGRectMake(0, window.frame.size.height,window.frame.size.width,window.frame.size.height);
        _blackViewBottom.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_viewFromBottom removeFromSuperview];
            _viewFromBottom=nil;
            [_blackViewBottom removeFromSuperview];
        }
    }];
}
#pragma mark remove bottom popview
- (void)dismissMiddleView
{
    [UIView animateWithDuration:0.15 animations:^{
        
        [_viewFromBottom setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
        _blackViewBottom.alpha = 0.0;
        _viewFromBottom.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [_viewFromBottom removeFromSuperview];
            _viewFromBottom = nil;
            [_blackViewBottom removeFromSuperview];
        }
    }];
}

- (void)dissmissMiddle:(BOOL)animated
{
    if (animated)
    {
        [self dismissMiddleView];
    }
    else
    {
        [_viewFromBottom removeFromSuperview];
        _viewFromBottom = nil;
        [_blackViewBottom removeFromSuperview];
    }
}

#pragma mark - 自定义的ActionSheet
- (void)showActionSheetWithTitle:(NSString *)title
                           okBtn:(NSArray *)btnTitles
                       cancelBtn:(NSString *)strCancel
                           block:(DQActionBlock)block
                     cancelClick:(DQActionBlock)cancel {
    self.actionBlock = block;
    self.cancelBlock = cancel;
    
    CGFloat per = 7;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    CGFloat widthView = window.frame.size.width;
    UIColor *btnColor = [UIColor colorWithHexString:@"177ffc"];
    NSInteger count = [btnTitles count];
    
    CGFloat height = count * 45;
    if (strCancel.length > 0)
    {
        height += 45 + per;
    }
    
    CGSize size;
    if (title.length > 0)
    {
        size = [AppUtils textSizeFromTextString:title
                                          width:widthView - 20
                                         height:height - 50
                                       font:[UIFont systemFontOfSize:16]];
        
        height += per * 6 + size.height;
    }
    
    if (!_moduleView)
    {
        _moduleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthView, height)];
    }
    _moduleView.backgroundColor = [UIColor whiteColor];
    _moduleView.frame = CGRectMake(0, 0, widthView, height);
    for (UIView *v in _moduleView.subviews)
    {
        [v removeFromSuperview];
    }
    
    if (strCancel.length > 0)
    {
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.backgroundColor = [UIColor whiteColor];
        [btnCancel setTitleColor:btnColor forState:UIControlStateNormal];
        btnCancel.frame = CGRectMake(0, height - 45, widthView, 45);
        [btnCancel setTitle:strCancel forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [btnCancel addTarget:self action:@selector(onASBtnCancelClick) forControlEvents:UIControlEventTouchUpInside];
        [_moduleView addSubview:btnCancel];
        
        height -= (45 + per);
        
        UIView *lineVer = [[UIView alloc] initWithFrame:CGRectMake(0, height, widthView, per)];
        lineVer.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
        [_moduleView addSubview:lineVer];
    }
    
    if ([btnTitles count] > 0 || title.length > 0)
    {
        UIView *viewBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthView, height)];
        viewBtn.backgroundColor = [UIColor whiteColor];
        [_moduleView addSubview:viewBtn];

        CGFloat y = 0;
        
        if (title.length > 0)
        {
            y += per * 3;
            CGSize size = [AppUtils
                           textSizeFromTextString:title
                           width:widthView - 20
                           height:height - 50
                           font:[UIFont systemFontOfSize:16]];
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, widthView - 20, size.height)];
            lblTitle.backgroundColor = [UIColor clearColor];
            lblTitle.font = [UIFont systemFontOfSize:16];
            lblTitle.textAlignment = NSTextAlignmentCenter;
            lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
            lblTitle.numberOfLines = 0;
            lblTitle.textColor = [UIColor colorWithHexString:COLOR_BLACK];
            lblTitle.text = title;
            [viewBtn addSubview:lblTitle];
            
            y += per * 3 + size.height;
            UIView *lineVer = [[UIView alloc] initWithFrame:CGRectMake(0, y, widthView, 0.5)];
            lineVer.backgroundColor = [UIColor colorWithHexString:COLOR_LINE];
            [viewBtn addSubview:lineVer];
        }
        
        for (int i = 0; i < count; i ++)
        {
            UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
            btnOK.backgroundColor = [UIColor clearColor];
            [btnOK setTitleColor:btnColor forState:UIControlStateNormal];
            btnOK.frame = CGRectMake(0, y, widthView, 45);
            btnOK.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            btnOK.tag = TAG_ACTIONSHEET + i;
            [btnOK addTarget:self action:@selector(onASBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnOK setTitle:btnTitles[i] forState:UIControlStateNormal];
            [viewBtn addSubview:btnOK];
            y += 45;
            
            if (i != count - 1)
            {
                UIView *lineVer = [[UIView alloc] initWithFrame:CGRectMake(0, y, widthView, 0.5)];
                lineVer.backgroundColor = [UIColor colorWithHexString:COLOR_LINE];
                [viewBtn addSubview:lineVer];
            }
        }
    }
    
    [self showViewFromBottom:_moduleView Animated:YES];
}
- (void)tapBottom:(UIGestureRecognizer *)gesture
{
    [self dissmissBottom];
}

- (void)onASBtnCancelClick
{
    [self dissmissBottom];
    self.cancelBlock(0);
}

- (void)onASBtnClick:(UIButton *)button
{
    [self dissmissBottom];
    self.actionBlock(button.tag - TAG_ACTIONSHEET);
}

@end

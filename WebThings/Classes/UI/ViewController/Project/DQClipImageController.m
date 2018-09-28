//
//  DQClipImageController.m
//  WebThings
//  添加商务往来／整改意见
//  Created by Heidi on 2017/10/16.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DQClipImageController.h"

@implementation DQClipImageController

#pragma mark - Getter
// 创建button
- (UIButton *)buttonWithTitle:(NSString *)title
                         icon:(NSString *)iconName
                          sel:(SEL)sel
                        frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (iconName.length > 0) {
        [button setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    }
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    button.frame = frame;
    
    return button;
}

#pragma mark - Init
- (void)initSubviews {
    CGRect frame = self.view.frame;
    CGFloat width = frame.size.width;
    {
        _cropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, screenHeight)];
        _cropView.backgroundColor = [UIColor whiteColor];
        _cropView.layer.masksToBounds = YES;
        [self.view addSubview:_cropView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, screenHeight)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.image = self.image;
        [_cropView addSubview:_imageView];
        
        // 初始化
        _cliper = [[CXCliper alloc] initWithImageView:_imageView];
        
        // 阴影设置
        _cliper.showShadow = YES;
        _cliper.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.25];
        
        // 剪切区域设置
        _cliper.gridFillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.25];
        _cliper.gridBorderColor = [UIColor clearColor];
        
        // 剪切区域边角设置
        _cliper.showGridCorner = YES;
        _cliper.gridCornerColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        _cliper.gridCornerStyle = GridCornerStyleCircle;
        _cliper.gridCornerWidth = 3;
        _cliper.gridCornerHeight = 8;
        _cliper.gridCornerRadius = 8;
        
        // 剪切区域网格线设置
        _cliper.showGridLine = YES;
        _cliper.gridLineColor = [UIColor clearColor];
        _cliper.gridLineWidth = .5;
        
        // 剪切区域网格数设置
        _cliper.gridHorizontalCount = 1;
        _cliper.gridVerticalCount = 1;
        
        // 使编辑框的范围在屏幕之内
        if (_clipRect.origin.x < 0) {
            _clipRect.origin.x = 0;
        }
        if (_clipRect.origin.y < 0) {
            _clipRect.origin.y = 0;
        }
        if (_clipRect.origin.x + _clipRect.size.width > screenWidth) {
            _clipRect.origin.x = (_clipRect.origin.x + _clipRect.size.width - screenWidth);
        }
        if (_clipRect.origin.y + _clipRect.size.height > screenHeight) {
            _clipRect.origin.y = (_clipRect.origin.y + _clipRect.size.height - screenHeight);
        }
        [_cliper setClipRect:_clipRect];
    }
    {   // 操作按钮
        UIView *topFinishBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 64)];
        [self.view addSubview:topFinishBtnView];
        
        UIButton *btnRetake = [self buttonWithTitle:@"重拍" icon:nil sel:@selector(onReTakeClick)
                                              frame:CGRectMake(0, 20, 58, 64)];
        [topFinishBtnView addSubview:btnRetake];
        
        UIButton *btnDone = [self buttonWithTitle:@"完成" icon:nil sel:@selector(onDoneClick)
                                            frame:CGRectMake(width - 58, 20, 58, 64)];
        [topFinishBtnView addSubview:btnDone];
    }
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
}

#pragma mark - Button clicks
// 重拍
- (void)onReTakeClick {
    [self.navigationController popViewControllerAnimated:NO];
}

// 完成
- (void)onDoneClick {
    if (self.clipFinished) {
        self.clipFinished([_cliper getClipImage],
                          [NSValue valueWithCGRect:[_cliper getClipRect]]);
    }
    [self.navigationController popViewControllerAnimated:NO];
}

@end

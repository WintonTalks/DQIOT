//
//  BasePopUpView.h
//  PickerDemo
//
//  Created by 孙文强 on 2017/9/6.
//  Copyright © 2017年 Happy Day. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDatePicHeight 200
#define kTopViewHeight 44

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

/// RGB颜色(16进制)
#define RGB_HEX(rgbValue, a) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

@interface BasePopUpView : UIView
// 背景视图
@property (nonatomic, strong) UIView *backgroundView;
// 弹出视图
@property (nonatomic, strong) UIView *alertView;
// 顶部视图
@property (nonatomic, strong) UIView *topView;
// 左边取消按钮
@property (nonatomic, strong) UIButton *leftBtn;
// 右边确定按钮
@property (nonatomic, strong) UIButton *rightBtn;
// 中间标题
@property (nonatomic, strong) UILabel *titleLabel;
// 分割线视图
@property (nonatomic, strong) UIView *lineView;

/** 初始化子视图 */
- (void)initUI;

/** 点击背景遮罩图层事件 */
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender;

/** 取消按钮的点击事件 */
- (void)clickLeftBtn;

/** 确定按钮的点击事件 */
- (void)clickRightBtn;
@end

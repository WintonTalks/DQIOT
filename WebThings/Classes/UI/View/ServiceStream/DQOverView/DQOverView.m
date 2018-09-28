//
//  DQOverView.m
//  DQDemo
//
//  Created by Eugene on 2017/9/14.
//  Copyright © 2017年 Eugene. All rights reserved.
//

#import "DQOverView.h"

@interface DQOverView ()

@property (nonatomic,weak) UITextField *textField;

@end

@implementation DQOverView

#pragma mark - Singleton
+ (DQOverView *)shareInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    
    return instance;
}

#pragma mark - Initilize
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.4;
    [self addSubview:view];
}

#pragma mark - Common Methods
- (void)completeButtonPressed:(UIButton *)button {
    if ([self.textField.text isEqualToString:@"123456"]) {
        [self.textField resignFirstResponder];
        [self resignKeyWindow];
        self.hidden = YES;
    } else {
        [self showErrorAlertView];
    }
}

- (void)showErrorAlertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"密码错误，请重新输入" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)show {
    [self makeKeyWindow];
    self.hidden = NO;
}

- (void)dismiss {
    [self resignKeyWindow];
    self.hidden = YES;
}
@end

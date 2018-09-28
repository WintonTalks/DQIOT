//
//  CKRadioButton.m
//  WebThings
//
//  Created by machinsight on 2017/6/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CKRadioButton.h"

@implementation CKRadioButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _isOn = NO;
    [self addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark setters
- (void)setIsOn:(BOOL)isOn{
    _isOn = isOn;
    if (_isOn) {
        [self setBackgroundImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
    }
}

- (void)setDelegate:(id<CKRadioButtonDelegate>)delegate{
    _delegate = delegate;
}

- (void)clicked:(CKRadioButton *)sender{
    //当前就是isOn状态的状态不变
    if (!sender.isOn) {
        sender.isOn = !sender.isOn;
    }
    if ([_delegate respondsToSelector:@selector(btnClicked:)]) {
        [_delegate btnClicked:self];
    }
}
@end

//
//  DQManageTitleRowView.m
//  WebThings
//
//  Created by winton on 2017/10/19.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQManageTitleRowView.h"

@interface DQManageTitleRowView()
@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UITextField *valueField;
@end

@implementation DQManageTitleRowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 6, 0, 14)];
        _keyLabel.font = [UIFont dq_mediumSystemFontOfSize:14];
        _keyLabel.textAlignment = NSTextAlignmentLeft;
        _keyLabel.textColor = [UIColor colorWithHexString:@"#BAB9B9"];
        [self addSubview:_keyLabel];
        
        _valueField= [[UITextField alloc] initWithFrame:CGRectMake(0, _keyLabel.top, 0, 14)];
        _valueField.placeholder = @"请选择";
        _valueField.returnKeyType = UIReturnKeyDefault;
        _valueField.textAlignment = NSTextAlignmentRight;
        _valueField.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _valueField.font = [UIFont dq_mediumSystemFontOfSize:14];
        [_valueField setEnabled:false];
        [self addSubview:_valueField];
    }
    return self;
}

- (void)configKeyTitle:(NSString *)key
                 value:(NSString *)value
{
    _keyLabel.text = key;
    _valueField.text = value;
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = [AppUtils textWidthSystemFontString:_keyLabel.text height:_keyLabel.height font:_keyLabel.font];
    _keyLabel.width = width;
    
    CGFloat rightWidth = [AppUtils textWidthSystemFontString:_valueField.text height:_valueField.height font:_valueField.font];
    _valueField.width = rightWidth;
    _valueField.left = self.width-rightWidth-16;
}

@end

//
//  DQTextFiledInfoCell.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQTextFiledInfoCell.h"

@interface DQTextFiledInfoCell()<UITextFieldDelegate>
@end

@implementation DQTextFiledInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.rightField];
    }
    return self;
}

- (UITextField *)rightField
{
    if (!_rightField) {
        _rightField = [[UITextField alloc] initWithFrame:CGRectZero];
       // _rightField.label = @"请选择";
        _rightField.placeholder = @"请输入";
        _rightField.delegate = self;
        _rightField.returnKeyType = UIReturnKeyDefault;
        _rightField.textAlignment = NSTextAlignmentRight;
        _rightField.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _rightField.font = [UIFont dq_regularSystemFontOfSize:14];
//        _rightField.normalColor = [UIColor colorWithRed:129/255. green:139/255. blue:146/255. alpha:1];
//        _rightField.textColor = [UIColor blackColor];
//        _rightField.hintColor = [UIColor colorWithRed:129/255. green:139/255. blue:146/255. alpha:1];
//        _rightField.highlightColor = [UIColor colorWithRed:60/255. green:123/255. blue:225/255. alpha:1];
//        _rightField.enabled = true;
//        _rightField.floatingLabel = true;
//        _rightField.highlightLabel = true;
//        _rightField.singleLine = true;
//        [_rightField hideDevide];
    }
    return _rightField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.InfoCellBlock) {
        self.InfoCellBlock(self);
    }
    return true;
}

- (void)setConfigPlaceholder:(NSString *)configPlaceholder
{
    _configPlaceholder = configPlaceholder;
    _rightField.placeholder = configPlaceholder;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.rightField.frame = CGRectMake(self.contentView.width-38-220, (self.contentView.height-25)/2, 220, 25);
}

@end

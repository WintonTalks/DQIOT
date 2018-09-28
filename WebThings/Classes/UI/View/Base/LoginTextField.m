//
//  LoginTextField.m
//  WebThings
//
//  Created by machinsight on 2017/7/12.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "LoginTextField.h"
@interface LoginTextField()<UITextFieldDelegate>
@property(nonatomic,strong)UIColor *labelColor;
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,strong)UIColor *errorColor;
@property(nonatomic,strong)UIFont *labelFont;
@property(nonatomic,strong)UIFont *textFont;
@property(nonatomic,strong)UIFont *errorFont;
@end
@implementation LoginTextField

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _labelFont = [UIFont fontWithName:@"DroidSansFallback" size:10.f*autoSizeScaleY];
        _textFont = [UIFont fontWithName:@"DroidSansFallback" size:13.f*autoSizeScaleY];
        _errorFont = [UIFont fontWithName:@"DroidSansFallback" size:9.f*autoSizeScaleY];
        _labelColor = [UIColor colorWithHexString:@"818b92"];
        _textColor = [UIColor colorWithHexString:@"161616"];
        _errorColor = [UIColor redColor];
        
        [self initView];
    }
    return self;
}

- (void)initView{
    [self floatlab];
    [self textField];
    [self errorLab];
}

- (UILabel *)floatlab{
    if (!_floatlab) {
        _floatlab = [[UILabel alloc] initWithFrame:CGRectMake(21*autoSizeScaleX, 12*autoSizeScaleY, 100, 11*autoSizeScaleY)];
        _floatlab.font = _labelFont;
        _floatlab.textColor = _labelColor;
        _floatlab.hidden  = YES;
        [self addSubview:_floatlab];
    }
    return _floatlab;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(21*autoSizeScaleX, 30*autoSizeScaleY, self.frame.size.width-42*autoSizeScaleX, 14*autoSizeScaleY)];
        _textField.font = _textFont;
        _textField.textColor = _textColor;
        _textField.delegate = self;
        [self addSubview:_textField];
    }
    return _textField;
}

- (UILabel *)errorLab{
    if (!_errorLab) {
        _errorLab = [[UILabel alloc] initWithFrame:CGRectMake(21*autoSizeScaleX, 47*autoSizeScaleY, 200, 9*autoSizeScaleY)];
        _errorLab.font = _errorFont;
        _errorLab.textColor = _errorColor;
        _errorLab.hidden = YES;
        [self addSubview:_errorLab];
    }
    return _errorLab;
}
- (void)setPlaceH:(NSString *)placeH{
    _placeH = placeH;
    [self setPlaceholder:_placeH];
    _floatlab.text = _placeH;
}
- (void)setHasError:(BOOL)hasError{
    _hasError = hasError;
    if (_hasError) {
        _errorLab.hidden = NO;
        _errorLab.text = _errorMsg;
    }else{
        _errorLab.hidden = YES;
    }
}
- (void)setPlaceholder:(NSString *)str{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:str attributes:
                                      @{NSForegroundColorAttributeName:_labelColor,
                                        NSFontAttributeName:_textFont
                                        }];
    _textField.attributedPlaceholder = attrString;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _floatlab.hidden = NO;
    [self setPlaceholder:@""];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text length] == 0) {
        _floatlab.hidden = YES;
        [self setPlaceholder:_placeH];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_delegate textFieldDidEndEditing:self];
    }
}

/**
 给textfield赋值

 @param text 值
 */
- (void)setText:(NSString *)text{
    if ([text length]) {
        _textField.text = text;
        _floatlab.hidden = NO;
        [self setPlaceholder:@""];
        if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
            [_delegate textFieldDidEndEditing:self];
        }
    }
}
@end

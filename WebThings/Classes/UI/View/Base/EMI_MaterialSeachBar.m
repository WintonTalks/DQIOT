//
//  EMI_MaterialSeachBar.m
//  WebThings
//
//  Created by machinsight on 2017/6/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMI_MaterialSeachBar.h"
@interface EMI_MaterialSeachBar()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf;

@end
@implementation EMI_MaterialSeachBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"EMI_MaterialSeachBar" owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.tf.delegate = self;
//        self.frame = CGRectMake(screenWidth, 0, screenWidth, 66);  // 修改1
        self.frame = CGRectMake(0, 0, screenWidth, 69);
        //阴影
        [EMINavigationController dropShadowWithOffset:CGSizeMake(0, 1) radius:1 color:[UIColor colorWithHexString:@"#CBCCCD"] opacity:1 aimView:self];
    }
    return self;
}

- (void)becomeFirstResponder {
    [self.tf becomeFirstResponder];
}

- (void)showWithFatherV:(UIView *)fatherV{
    if (![self superview]) {
        [fatherV addSubview:self];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, screenWidth, 66);
        [self.tf becomeFirstResponder];
    }];
    
    if (_delegate&&[_delegate respondsToSelector:@selector(EMI_MaterialSeachBarDidShow)]) {
        [_delegate EMI_MaterialSeachBarDidShow];
    }
}

- (IBAction)btnClicked:(UIButton *)sender {
    [self dismiss];
}

- (void)searchBarDismissed {
    if (_delegate && [_delegate respondsToSelector:@selector(EMI_MaterialSeachBarDismissed)]) {
        [_delegate EMI_MaterialSeachBarDismissed];
    }
}

- (IBAction)endEdit:(UITextField *)sender {
//    [self dismiss];  // 修改2
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(screenWidth, 0, screenWidth, 66);
    }];
    [self endEditing:YES];
    [self searchBarDismissed];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    if (![textField.text length]) {
        //空
        [self dismiss];
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(EMI_MaterialSeachBarReturnKeyClicked:)]) {
            [_delegate EMI_MaterialSeachBarReturnKeyClicked:textField.text];
        }
    }
//    [self dismiss];   // 修改3
    return YES;
}

#pragma mark - Setter And Getter

- (void)setPalceHodlerString:(NSString *)palceHodlerString {
    _palceHodlerString = palceHodlerString;
    
    _tf.placeholder = palceHodlerString;
}

@end

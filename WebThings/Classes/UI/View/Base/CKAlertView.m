//
//  CKAlertView.m
//  WebThings
//
//  Created by machinsight on 2017/6/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CKAlertView.h"
@interface CKAlertView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet MDButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
@implementation CKAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"CKAlertView" owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.frame = frame;
    }
    return self;
}
- (void)setTitle:(NSString *)title Content:(NSString *)content{
    _titleLab.text = title;
    _contentLab.text = content;
}
- (IBAction)sureBtnClicked:(MDButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ckalert_sureBtnClicked:)]) {
        [_delegate ckalert_sureBtnClicked:self];
    }
   [[self superview] superview].hidden = YES;
}
- (IBAction)cancelBtnClicked:(UIButton *)sender {
    [[self superview] superview].hidden = YES;
}

@end

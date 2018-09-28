//
//  ServiceBtnView.m
//  WebThings
//
//  Created by machinsight on 2017/7/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceBtnView.h"
@interface ServiceBtnView()
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *againstBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBtnWid;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *againstBtnWid;
@end
@implementation ServiceBtnView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ServiceBtnView" owner:self options:nil];
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ServiceBtnView" owner:self options:nil];
        [self setup];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.contentView];
    self.frame = CGRectMake(0, 0, 245*autoSizeScaleX, 41);
    self.contentView.frame = CGRectMake(0, 0, 245*autoSizeScaleX, 41);
}

- (void)awakeFromNib

{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"ServiceBtnView" owner:self options:nil];
    [self setup];
    
}
- (void)setSureTag:(NSInteger)tag1 againstTag:(NSInteger)tag2{
    self.sureBtn.tag = tag1;
    self.againstBtn.tag = tag2;
}

- (void)setAction1:(SEL)action1 Action2:(SEL)action2 target:(id)target{
    [_sureBtn addTarget:target action:action1 forControlEvents:UIControlEventTouchUpInside];
    [_againstBtn addTarget:target action:action2 forControlEvents:UIControlEventTouchUpInside];
}

- (void)setBtnTitle1:(NSString *)title1 Width1:(CGFloat)wid1 BtnTitle2:(NSString *)title2 Width2:(CGFloat)wid2{
    [_sureBtn setTitle:title1 forState:UIControlStateNormal];
    _sureBtnWid.constant = wid1;
    [_againstBtn setTitle:title2 forState:UIControlStateNormal];
    _againstBtnWid.constant = wid2;
}
//- (IBAction)sureClick:(UIButton *)sender {
//    if (_delegate && [_delegate respondsToSelector:@selector(sureBtnClicked:)]) {
//        [_delegate sureBtnClicked:sender];
//    }
//}
//
//- (IBAction)againstClick:(UIButton *)sender {
//    if (_delegate && [_delegate respondsToSelector:@selector(againBtnClicked:)]) {
//        [_delegate againBtnClicked:sender];
//    }
//}
@end

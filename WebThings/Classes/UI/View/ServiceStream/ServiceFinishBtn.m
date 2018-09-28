//
//  ServiceFinishBtn.m
//  WebThings
//
//  Created by machinsight on 2017/8/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceFinishBtn.h"
@interface ServiceFinishBtn()
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWid;
@end
@implementation ServiceFinishBtn

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ServiceFinishBtn" owner:self options:nil];
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ServiceFinishBtn" owner:self options:nil];
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
    
    [[NSBundle mainBundle] loadNibNamed:@"ServiceFinishBtn" owner:self options:nil];
    [self setup];
    
}
- (void)setSureTag:(NSInteger)tag1{
    self.sureBtn.tag = tag1;
}
- (void)setAction1:(SEL)action1 target:(id)target{
    [_sureBtn addTarget:target action:action1 forControlEvents:UIControlEventTouchUpInside];
}
- (void)setBtnTitle:(NSString *)title Width:(CGFloat)wid{
    [_sureBtn setTitle:title forState:UIControlStateNormal];
    _btnWid.constant = wid;
}
@end

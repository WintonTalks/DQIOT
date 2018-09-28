//
//  XWBJView.m
//  WebThings
//
//  Created by machinsight on 2017/7/6.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "XWBJView.h"
#import "WarningModel.h"
#import "XWBJChildView.h"
@interface XWBJView()<CAAnimationDelegate>{
    BOOL ishideAni;//是否是影藏的动画
}

@property (weak, nonatomic) IBOutlet UIView *fatherv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWid;

/**
 已核实并发起维修按钮
 */
@property (weak, nonatomic) IBOutlet MDButton *yhsBtn;

/**
 已维修按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *ywxBtn;
@end
@implementation XWBJView

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XWBJView" owner:nil options:nil] objectAtIndex:0];
        ishideAni = NO;
        self.hidden = YES;
    }
    self.frame = frame;
    return self;
}

#pragma show
- (void)showWithFatherV:(UIView *)fatherV{
    ishideAni = NO;
    [fatherV addSubview:self];
    self.hidden = NO;
    //动画，高度从1到223
    [ChangeAnchorPoint setAnchorPoint:CGPointMake(0, 0) forView:self];
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.keyPath=@"transform.scale.y";
    animation.fromValue= @(0);
    animation.toValue= @(1);
    animation.duration=0.3;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.removedOnCompletion=NO;//动画结束了禁止删除
    animation.fillMode= kCAFillModeForwards;//停在动画结束处
    animation.delegate = self;
    [self.layer addAnimation:animation forKey:@"basic"];
}
#pragma disshow
- (void)disshow{
    ishideAni = YES;
    [ChangeAnchorPoint setAnchorPoint:CGPointMake(0, 0) forView:self];
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.keyPath=@"transform.scale.y";
    animation.fromValue= @(1);
    animation.toValue= @(0);
    animation.duration=0.3;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.removedOnCompletion=NO;//动画结束了禁止删除
    animation.fillMode= kCAFillModeForwards;//停在动画结束处
    animation.delegate = self;
    [self.layer addAnimation:animation forKey:@"basic"];
}
#pragma animationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (ishideAni) {
        self.hidden = YES;
        [self removeFromSuperview];
    }
    [ChangeAnchorPoint setDefaultAnchorPointforView:self];
}


- (void)setViewValuesWithModel:(DataCenterModel *)model{
    NSArray <WarningModel *> *warnlist = nil;//model.warnlist;
    _fatherVWid.constant = warnlist.count*(screenWidth-16)/3;
    CGFloat x = 0;
    for (int i = 0; i<warnlist.count; i++) {
        x = i*(screenWidth-16)/3;
        XWBJChildView *cv = [[XWBJChildView alloc] init];
        cv.frame = CGRectMake(x, 0, (screenWidth-16)/3, 85);
        [cv setViewValuesWithModel:warnlist[i]];
        [_fatherv addSubview:cv];
    }
}
- (IBAction)yhsBtnClicked:(id)sender {
}
- (IBAction)ywxBtnClicked:(id)sender {
}
@end

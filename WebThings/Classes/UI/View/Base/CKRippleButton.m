//
//  CKRippleButton.m
//  WebThings
//
//  Created by machinsight on 2017/5/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CKRippleButton.h"

@implementation CKRippleButton

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
    _rippleColor = [UIColor whiteColor];
}

#pragma mark setters
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setRippleColor:(UIColor *)rippleColor {
    _rippleColor = rippleColor;
}

#pragma Touch Delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self AnimateRipple];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

- (void)AnimateRipple{
    //设置一个在button后面的图片
    
    UIView * bview = [[UIView alloc]initWithFrame:self.frame];
    
    //设置颜色
    
    [bview setBackgroundColor:_rippleColor];
    
    //设置图片的圆角效果
    
    bview.layer.cornerRadius = self.frame.size.width/2;
    bview.alpha = 0.6;
    //设置层级
    
    [[self superview] insertSubview:bview atIndex:0];
    
    
//    UIView * bviewbg = [[UIView alloc]initWithFrame:self.frame];
//    //        bviewbg.center = bview.center;
//    //        CGRect bgframe = bviewbg.frame;
//    //        bgframe.size.width = bview.frame.size.width*2;
//    //        bgframe.size.height = bview.frame.size.height*2;
//    //        bviewbg.frame = bgframe;
//    
//    //设置颜色
//    
//    [bviewbg setBackgroundColor:_rippleColor];
//    bviewbg.alpha = 1;
//    //设置图片的圆角效果
//    
//    bviewbg.layer.cornerRadius = self.frame.size.width/2;
//    
//    //设置层级
//    
//    [[self superview] insertSubview:bviewbg atIndex:1];
//    bviewbg.transform =CGAffineTransformMakeScale(2, 2);
    
    //设置连续放大效果(水波纹)效果
    
    //参数1:动画时间
    
    //参数2:延迟执行动画的时间
    
    //参数3:动画效果,传递0,表示默认
    
    //参数4:执行的动画代码块
    
    //参数5:动画执行完成后的block代码块
    
    [UIView animateWithDuration:0.2
     
                          delay:0
     
                        options:0
     
                     animations:^{
                         
                         bview.transform =CGAffineTransformMakeScale(2, 2);
                         
                         //alpha表示透明度 取值1-0 1为实  0为全透明
                         
                         //@property(nonatomic)                 CGFloat           alpha; animatable. default is 1.0
                         
//                         bview.alpha = 0;
                         
                     } completion:^(BOOL finished) {
//                         [bviewbg removeFromSuperview];
                         [bview removeFromSuperview];
                         
                     }];
}
@end

//
//  ImgButton.m
//  WebThings
//
//  Created by machinsight on 2017/6/19.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ImgButton.h"
#import "MDRippleLayer.h"
@interface ImgButton()
@property(strong, nonatomic)  UIImageView *imgV;
@property(strong, nonatomic)  UILabel *ck_titleLabel;

@property MDRippleLayer *mdLayer;
@end
@implementation ImgButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self initLayer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
        [self initLayer];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor colorWithHexString:@"#417EE8"];
    CGFloat height = self.frame.size.height;
    _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, (height-19)/2, 19, 19)];
    [self addSubview:_imgV];
    
    _ck_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgV.right+8, 5, 0, height-10)];
    [self addSubview:_ck_titleLabel];
    _ck_titleLabel.textColor = [UIColor whiteColor];
    _ck_titleLabel.font = [UIFont fontWithName:@"DroidSansFallback" size:15.f];
    _ck_titleLabel.textAlignment = NSTextAlignmentLeft;
}

#pragma mark setters
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}


- (void)setImg:(UIImage *)img {
    _img = img;
    _imgV.image = img;
}

- (void)setCk_title:(NSString *)ck_title{
    _ck_title = ck_title;
    self.ck_titleLabel.text = _ck_title;
    CGFloat width = [AppUtils textWidthSystemFontString:ck_title height:self.ck_titleLabel.height font:self.ck_titleLabel.font];
    width = (width > self.width-30) ? self.width-30 : width;
    self.ck_titleLabel.width = width;
    
    if ((self.width- self.ck_titleLabel.right) > 10) {
        self.width = self.ck_titleLabel.right+8;
    }
}

- (void)initLayer {
    if (_mdLayer) {
        [_mdLayer removeFromSuperlayer];
        _mdLayer = nil;
    }
    if (!_rippleColor)
        _rippleColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    _mdLayer = [[MDRippleLayer alloc] initWithSuperLayer:self.layer];
    _mdLayer.effectColor = _rippleColor;
    _mdLayer.rippleScaleRatio = 1;
    _mdLayer.enableElevation = false;
    _mdLayer.effectSpeed = 300;
}


- (void)setRippleColor:(UIColor *)rippleColor {
    _rippleColor = rippleColor;
    [_mdLayer setEffectColor:rippleColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [touches.allObjects[0] locationInView:self];
    [_mdLayer startEffectsAtLocation:point];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [_mdLayer stopEffectsImmediately];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [_mdLayer stopEffects];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [_mdLayer stopEffects];
}
@end

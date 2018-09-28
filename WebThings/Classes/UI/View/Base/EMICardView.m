//
//  EMICardView.m
//  WebThings
//
//  Created by machinsight on 2017/6/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "EMICardView.h"

@interface EMICardView ()

@property (nonatomic, strong) MDCShadowLayer *shadowLayer;

@end

@implementation EMICardView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self set];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self set];
    }
    return self;
}

- (void)set {
    //阴影
    _shadowLayer = (MDCShadowLayer *)self.layer;
    _shadowLayer.shadowMaskEnabled = YES;
    [_shadowLayer setElevation:MDCShadowElevationSwitch];
    
    //圆角 设置切除圆角，阴影将不存在
    //self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
}

- (void)setLayerShadowType:(CGFloat)layerShadowType {
    _shadowLayer.elevation = layerShadowType;
}

+ (Class)layerClass {
    return [MDCShadowLayer class];
}
@end

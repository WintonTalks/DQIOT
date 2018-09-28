//
//  HeadImgV.m
//  WebThings
//
//  Created by machinsight on 2017/7/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "HeadImgV.h"
#import "CDFInitialsAvatar.h"

@implementation HeadImgV

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.layer.masksToBounds = YES;
    _radius = self.height/2;
    self.layer.cornerRadius = _radius;
//    _borderColor = [UIColor colorWithHexString:@"407ee9"];
//    [self borderWid:1];
//    [self borderColor:_borderColor];
}

#pragma mark setters
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    self.layer.cornerRadius = _radius;
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    [self borderColor:_borderColor];
}

- (UIImage *_Nonnull)defaultImageWithName:(NSString *_Nonnull)str
{
    [self setup];
    CDFInitialsAvatar *topAvatar = [[CDFInitialsAvatar alloc] initWithRect:self.bounds fullName:str];
    topAvatar.initialsColor = [UIColor colorWithHexString:COLOR_BLUE];
    topAvatar.backgroundColor = [UIColor whiteColor];
    topAvatar.initialsFont = [UIFont fontWithName:@"DroidSans-Bold" size:14];
    return topAvatar.imageRepresentation;
}
@end

//
//  DQStarView.m
//  DQStarDemo
//
//  Created by winton on 2017/10/28.
//  Copyright © 2017年 winton. All rights reserved.
//

#import "DQStarView.h"

static const CGFloat KStarScale = 0.85;

@interface DQStarView()
/** 星星 */
@property (nonatomic, strong) UIImageView *starIV;
@end

@implementation DQStarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addStarWithFrame:frame];
    }
    return self;
}

- (void)addStarWithFrame:(CGRect)frame
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_star"]];
    self.starIV = imgView;
    [self addSubview:imgView];
    
    // 设置星星坐标
    CGFloat imgWH = CGRectGetWidth(frame);
    imgView.frame = CGRectMake(0, 0, imgWH * KStarScale, imgWH * KStarScale);
    imgView.center = CGPointMake(imgWH * 0.5, imgWH * 0.5);
}

#pragma mark - Set
/** 星星_是否为选中状态 */
- (void)setSelectedStarType:(DQStarViewStarType)selectedStarType {
    NSString *imgName;
    if (selectedStarType == 0) {
        imgName = @"icon_star";
    } else {
        imgName = @"icon_star_sel";
    }
    [self.starIV setImage:[UIImage imageNamed:imgName]];
}




@end

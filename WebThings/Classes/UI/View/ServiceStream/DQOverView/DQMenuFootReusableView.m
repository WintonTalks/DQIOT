//
//  DQMenuFootReusableView.m
//  WebThings
//
//  Created by Eugene on 2017/9/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#define kWidth ([[UIScreen mainScreen] bounds].size.width)

#import "DQMenuFootReusableView.h"

@implementation DQMenuFootReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];

        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 8)];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [self addSubview:_backgroundView];
        
    }return self;
}

@end

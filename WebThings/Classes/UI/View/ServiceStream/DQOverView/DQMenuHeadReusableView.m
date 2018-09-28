//
//  DQMenuHeadReusableView.m
//  WebThings
//
//  Created by Eugene on 2017/9/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#define kWidth ([[UIScreen mainScreen] bounds].size.width)

#import "DQMenuHeadReusableView.h"

@interface DQMenuHeadReusableView ()
/** 分割线 */
@property(nonatomic, strong) UIView *lineView;

/** 项目名 */
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation DQMenuHeadReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [UILabel new];
        _titleLabel.text = @"项目名";
        _titleLabel.font=[UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = [UIColor colorWithHexString:@"303030"];
        _titleLabel.frame = CGRectMake(16, 0, 300, 50);
        [self addSubview:_titleLabel];
        
        _lineView = [UIView new];
        _lineView.frame = CGRectMake(16, 54,kWidth - 32 , 1);
        _lineView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
        [self addSubview:_lineView];
    }
    return self;
}

#pragma mark - Setter and Getter
- (void)setProjectName:(NSString *)projectName {
    _projectName = projectName;
    
    _titleLabel.text = projectName;
}

@end

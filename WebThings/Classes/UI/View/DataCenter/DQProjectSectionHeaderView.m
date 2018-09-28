//
//  DQProjectSectionHeaderView.m
//  WebThings
//
//  Created by Heidi on 2017/9/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQProjectSectionHeaderView.h"
#import "AddProjectModel.h"

@implementation DQProjectSectionHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat height = 45;
        CGFloat width = screenWidth;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, width - 100, height)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:_titleLabel];
        
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 100, 0, 70, height)];
        _moreLabel.font = [UIFont systemFontOfSize:12];
        _moreLabel.text = @"查看更多";
        _moreLabel.textAlignment = NSTextAlignmentRight;
        _moreLabel.textColor = [UIColor colorWithHexString:@"#707070"];
        [self addSubview:_moreLabel];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(width - 18, height/2.0 - 2.5, 8, 5)];
        _icon.image = [UIImage imageNamed:@"ic_down"];
        [self addSubview:_icon];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(width - 100, 0, 100, height);
        [_button addTarget:self action:@selector(onFoldClick) forControlEvents:UIControlEventTouchUpInside];
        [self  addSubview:_button];
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    }
    return self;
}

- (void)setProject:(AddProjectModel *)project {
    // 少于3个不显示“查看更多”
    _moreLabel.hidden = [project.devices count] <= 3;
    _icon.hidden = _moreLabel.hidden;
    _button.hidden = _moreLabel.hidden;
    _titleLabel.text = project.projectname;
}

- (void)setIsFold:(BOOL)isFold {
    _isFold = isFold;
//    _moreLabel.text = _isFold ? @"查看更多" : @"收起";
    [UIView animateWithDuration:0.4 animations:^{
       _icon.transform = CGAffineTransformMakeRotation(_isFold ? M_PI * 2 : M_PI);
    }];
}

- (void)onFoldClick {
    _isFold = !_isFold;
    
    if (self.clicked) {
        self.clicked([NSNumber numberWithBool:_isFold]);
    }
}

@end

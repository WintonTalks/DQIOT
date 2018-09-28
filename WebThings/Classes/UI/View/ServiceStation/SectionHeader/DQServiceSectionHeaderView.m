//
//  DQServiceSectionHeaderView.m
//  WebThings
//
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceSectionHeaderView.h"
#import "DQServiceNodeModel.h"

#import "UIColor+Hex.h"

@implementation DQServiceSectionHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat height = 45;
        CGFloat width = screenWidth;
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, width, 8)];
        _bgView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
        [self.contentView addSubview:_bgView];
        _bgView.hidden = YES;
        
        // 两根竖线，来控制视觉效果
        _line1 = [[UIView alloc] initWithFrame:CGRectMake(24, 0, 2, 10)];
        _line1.backgroundColor = [UIColor colorWithHexString:COLOR_BLUE];
        [self.contentView addSubview:_line1];
        
        _line2 = [[UIView alloc] initWithFrame:CGRectMake(24, 8, 2, height - 4)];
        _line2.backgroundColor = [UIColor colorWithHexString:COLOR_BLUE];
        [self.contentView addSubview:_line2];

        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
        [self.contentView addSubview:_bodyView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 100, 20)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_bodyView addSubview:_titleLabel];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(16, height/4.0 - 3, 16, 16)];
        _icon.image = [UIImage imageNamed:@"icon_service_cur"];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [_bodyView addSubview:_icon];

        _indictor = [[UIImageView alloc] initWithFrame:CGRectMake(160, height/4.0 - 3.5, 11, 7)];
        _indictor.image = [UIImage imageNamed:@"icon_down"];
        [_bodyView addSubview:_indictor];

        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, width, height);
        [_button addTarget:self action:@selector(onFoldClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
        
        _dot = [[UIView alloc] initWithFrame:CGRectMake(80, height/4.0 - 3, 6, 6)];
        _dot.backgroundColor = [UIColor colorWithHexString:COLOR_BLUE];
        _dot.layer.cornerRadius = 3.0;
        _dot.layer.masksToBounds = YES;
        [_bodyView addSubview:_dot];
        _dot.hidden = YES;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// 设置Section的数据及布局
- (void)setNode:(DQServiceNodeModel *)node {
    _node = node;
    
    CGFloat height = 50;
    
    // 灰色背景位置设置以及线的大小位置设置
    _bgView.hidden = YES;
    if (node.nodeIndex == DQFlowTypeRent || node.nodeIndex == DQFlowTypeRemove) {
        height = 84;
        CGFloat y = height/2.0 + 6;
        
        _bgView.hidden = NO;
        _bgView.frame = CGRectMake(0, 0, screenWidth, 8);
        _bodyView.frame = CGRectMake(0, 40, screenWidth, height - 8);
        _line1.frame = CGRectMake(24, 0, 2, y);
        _line2.frame = CGRectMake(24, y, 2, height - y);
    } else {
        _bodyView.frame = CGRectMake(0, 0, screenWidth, height);
        _line1.frame = CGRectMake(24, 0, 2, 10);
        _line2.frame = CGRectMake(24, 8, 2, height - 8);
    }
    // 标题设置
    _titleLabel.text = node.flowtype;
    if (node.canclick && [self canSkipToNext]) {    // 维保／维护／加高
        _titleLabel.textColor = [UIColor colorWithHexString:COLOR_BLUE];
    } else {
        _titleLabel.textColor = [UIColor colorWithHexString:node.canclick ? COLOR_BLACK : COLOR_GRAY];
        _indictor.image = [UIImage imageNamed:@"icon_down"];
    }
    _dot.backgroundColor = _titleLabel.textColor;
    _indictor.hidden = node.canclick ? NO : YES;    // 不能点击的行隐藏下拉箭头
    if ([self canSkipToNext]) {
        _indictor.hidden = NO;
    }
    
    _button.frame = CGRectMake(0, 0, screenWidth, height);

    height = 45;

    // icon状态图片布局
    if (node.canclick) {
        _icon.image = [UIImage imageNamed:node.isfinish ? @"icon_service_done" : @"icon_service_cur"];
        _icon.frame = CGRectMake(16, height/4.0 - 9, 18, 18);
        _icon.backgroundColor = [UIColor clearColor];
    } else {
        _icon.image = nil;
        _icon.backgroundColor = [UIColor colorWithHexString:COLOR_GRAY];
        _icon.frame = CGRectMake(21, height/4.0 - 4, 8, 8);
        _icon.layer.cornerRadius = 4.0;
        _icon.layer.masksToBounds = YES;
    }
}

- (void)setOpenIndex:(DQFlowType)openIndex {
    _openIndex = openIndex;
    _isOpened =  openIndex == _node.nodeIndex;
    _dot.hidden = !self.canSkipToNext;
    
    _icon.hidden = self.canSkipToNext;
    
    // 标题及按钮的颜色和样式
    if (self.canSkipToNext) {
        _indictor.transform = CGAffineTransformMakeRotation(0);
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _titleLabel.frame = CGRectMake(95, 0, 100, 20);
        
        if (_node.canclick && [self canSkipToNext]) {    // 维保／维护／加高
            _indictor.image = [UIImage imageNamed:@"indictor_right_blue"];
        } else {
            _indictor.image = [UIImage imageNamed:@"indictor_right"];
        }
    }
    else {
        _indictor.image = [UIImage imageNamed:@"icon_down"];
        _indictor.transform = CGAffineTransformMakeRotation(_isOpened ? M_PI : M_PI * 2);
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _titleLabel.frame = CGRectMake(80, 0, 100, 20);
    }
    CGRect rect = _indictor.frame;
    rect.size.width = _indictor.image.size.width;
    rect.size.height = _indictor.image.size.height;
    rect.origin.y = _titleLabel.size.height / 2.0 - rect.size.height / 2.0;
    _indictor.frame = rect;
    
    [self setLineDisplay];
}

/** 竖线布局 */
- (void)setLineDisplay {
    
    _line1.backgroundColor = [UIColor
                              colorWithHexString:_node.canclick || _node.isfinish ?
                              COLOR_BLUE : COLOR_GRAY];
    _line2.backgroundColor = _line1.backgroundColor;

    _line1.hidden = NO;
    _line2.hidden = NO;
    
    if (_node.nodeIndex == DQFlowTypeEvaluate || _node.nodeIndex == _openIndex) {
        _line2.hidden = YES;
    }
    if (_openIndex == _node.nodeIndex - 1 ||
        _node.nodeIndex == DQFlowTypeCommunicate) {    // 前期沟通和现在打开的一个不显示上面的Line
        _line1.hidden = YES;
    }
    if (_openIndex == DQFlowTypeRent) {
        if ([self canSkipToNext]) {
            _line2.hidden = YES;
            if (_node.nodeIndex != DQFlowTypeRent) {
                _line1.hidden = YES;
            }
        }
        else if (_node.nodeIndex == DQFlowTypeRemove) {
                _line1.hidden = YES;
        }
    } else {
        if ([self canSkipToNext] && _currentStep >= DQFlowTypeRent) {
            _line1.backgroundColor = [UIColor colorWithHexString:COLOR_BLUE];
            _line2.backgroundColor = [UIColor colorWithHexString:COLOR_BLUE];
        }
        else if (_node.nodeIndex == DQFlowTypeRemove && _currentStep >= DQFlowTypeRent) {
            _line1.backgroundColor = [UIColor colorWithHexString:COLOR_BLUE];
        }
    }

    if (_currentStep == _node.nodeIndex - 1  && ![self canSkipToNext]) {
        _line1.backgroundColor = [UIColor colorWithHexString:COLOR_BLUE];
    }
    
    { // 文字和icon以及indictor水平对齐
        CGFloat y = _icon.frame.origin.y + _icon.frame.size.height / 2.0;
        CGRect rect = _titleLabel.frame;
        rect.origin.y = y - rect.size.height / 2.0;
        _titleLabel.frame = rect;
        
        CGRect rectIndictor = _indictor.frame;
        rectIndictor.origin.y = y - rectIndictor.size.height / 2.0;
        _indictor.frame = rectIndictor;
    }
}

#pragma mark - Button clicks
// 是否需要跳转到下一级页面而不是展开（设备维保，维修，加高）
- (BOOL)canSkipToNext {
    return [_node.flowtype isEqualToString:@"设备维保"]
    || [_node.flowtype isEqualToString:@"设备维修"]
    || [_node.flowtype isEqualToString:@"设备加高"];
}

// 点击展开／折叠
- (void)onFoldClick {
    if (_node.canclick) {
        if (!self.canSkipToNext) {
            _isOpened = !_isOpened;
        }
        if (self.clicked) {
            self.clicked([NSNumber numberWithBool:_isOpened]);
        }
    }
}

@end

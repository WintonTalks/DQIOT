//
//  DQServiceBtnCell.m
//  WebThings
//  蓝色按钮行
//  Created by Heidi on 2017/9/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceBtnCell.h"

#import "DQApproachBottomView.h"

#import "UIColor+Hex.h"
#import "DQDefine.h"

@implementation DQServiceBtnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIColor *color = [UIColor colorWithHexString:COLOR_BTN_BLUE];
        _subLayer = [CALayer layer];
        CGRect fixframe = CGRectMake(58, 0, 125, 29);
        _subLayer.frame = fixframe;
        _subLayer.cornerRadius = 8;
        _subLayer.backgroundColor = [color colorWithAlphaComponent:0.9].CGColor;
        _subLayer.masksToBounds = NO;
        _subLayer.shadowColor = color.CGColor;
        _subLayer.shadowOffset = CGSizeMake(0,4);
        _subLayer.shadowOpacity = 0.9;
        _subLayer.shadowRadius = 3;
        [self.contentView.layer addSublayer:_subLayer];

        _btnHandle = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnHandle.frame = fixframe;
        _btnHandle.backgroundColor = color;
        [_btnHandle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnHandle.layer.cornerRadius = 5.0;
        _btnHandle.layer.masksToBounds = YES;
        _btnHandle.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnHandle addTarget:self action:@selector(onHandleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnHandle];
    }
    return self;
}

- (void)setData:(DQLogicServiceBaseModel *)data {
    [super setData:data];

    
    NSString *title = [data titleForButton];
    NSString *icon = [data iconNameForButton];
    
    [_btnHandle setTitle:[@"  " stringByAppendingString:title] forState:UIControlStateNormal];
    [_btnHandle setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [_btnHandle setImage:[UIImage imageNamed:icon] forState:UIControlStateHighlighted];

    // 按钮宽度根据文字多少来定
    CGSize size = [AppUtils textSizeFromTextString:title
                                             width:screenWidth - 130
                                            height:20
                                              font:[UIFont systemFontOfSize:14]];
    CGRect rect = _btnHandle.frame;
    rect.size.width = size.width + 50;
    // 计算一下二级页面的位置
    if (data.nodeType == DQFlowTypeBusinessContact ||
        data.nodeType == DQFlowTypeFix ||
        data.nodeType == DQFlowTypeMaintain ||
        data.nodeType == DQFlowTypeHeighten) {
        rect.origin.x = 16;
    }
    _btnHandle.frame = rect;
    _subLayer.frame = rect;
}

#pragma mark - Button clicks
- (void)onHandleBtnClicked {
    [self.data btnClicked];
}

@end

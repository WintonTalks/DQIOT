//
//  DQServiceButtonView.m
//  WebThings
//
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceButtonView.h"

#import "DQLogicServiceBaseModel.h"

@interface DQServiceButtonView ()

// 根据数据类型处理事件
@property (nonatomic, strong) DQLogicServiceBaseModel *logicModel;

@end

@implementation DQServiceButtonView

- (id)initWithFrame:(CGRect)frame logic:(DQLogicServiceBaseModel *)logic {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.logicModel = logic;
        
        NSString *title = [@"  " stringByAppendingString:[_logicModel titleForButton]];
        CGSize size = [AppUtils textSizeFromTextString:title
                                                 width:self.width
                                                height:20
                                                  font:[UIFont systemFontOfSize:14]];
        
        [_btnHandle setImage:[UIImage imageNamed:[_logicModel iconNameForButton]]
                    forState:UIControlStateNormal];

        UIColor *color = [UIColor colorWithHexString:COLOR_BTN_BLUE];
        _subLayer = [CALayer layer];
        CGRect fixframe = CGRectMake(0, self.height / 2.0 - 29 / 2.0, size.width + 40, 29);
        _subLayer.frame = fixframe;
        _subLayer.cornerRadius = 8;
        _subLayer.backgroundColor = [color colorWithAlphaComponent:0.9].CGColor;
        _subLayer.masksToBounds = NO;
        _subLayer.shadowColor = color.CGColor;
        _subLayer.shadowOffset = CGSizeMake(0,4);
        _subLayer.shadowOpacity = 0.9;
        _subLayer.shadowRadius = 3;
        [self.layer addSublayer:_subLayer];
        
        _btnHandle = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnHandle.frame = fixframe;
        _btnHandle.backgroundColor = color;
        [_btnHandle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnHandle.layer.cornerRadius = 5.0;
        [_btnHandle setTitle:title forState:UIControlStateNormal];
        [_btnHandle setImage:[UIImage imageNamed:@"ic_create"] forState:UIControlStateNormal];
        _btnHandle.layer.masksToBounds = YES;
        _btnHandle.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnHandle addTarget:self action:@selector(onHandleBtnClicked)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnHandle];
    }
    return self;
}

#pragma mark - Button clicks
- (void)onHandleBtnClicked {
    if ([_logicModel isKindOfClass:[DQLogicServiceBaseModel class]]) {
        [_logicModel btnClicked];
    }
}

@end

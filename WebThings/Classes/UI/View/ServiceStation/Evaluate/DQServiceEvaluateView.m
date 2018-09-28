//
//  DQServiceEvaluateView.m
//  WebThings
//  评价View
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceEvaluateView.h"

#import "DQServiceInfoCell.h"

#import "DQSubEvaluateModel.h"

@implementation DQServiceEvaluateView

#pragma mark - UI
- (UIButton *)buttonWithTitle:(NSString *)title
                        frame:(CGRect)frame
                     selector:(SEL)sel
                        image:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [button borderColor:[UIColor colorWithHexString:@"#979797"]];
    [button borderWid:1.f];
    [button withRadius:13];
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [button setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:COLOR_ORANGE] forState:UIControlStateSelected];

    return button;
}

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame type:(DQEvaluateType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _isSatisfy = YES;
        _evaluateType = type;
        
        // 对人员的评价
        BOOL isPerson = type == DQEvaluateTypeWorker || type == DQEvaluateTypePersonInService;
        
        self.userInteractionEnabled = true;
        _line1 = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2.0 - 41 - 50, 6, 50, 1)];
        _line1.backgroundColor = [UIColor colorWithHexString:COLOR_BLUE];
        [self addSubview:_line1];
        
        _line2 = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2.0 + 41, 7, 50, 1)];
        _line2.backgroundColor = [UIColor colorWithHexString:COLOR_BLUE];
        [self addSubview:_line2];
        
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2.0 - 41, 0, 82, 14)];
        _lblTitle.font = [UIFont systemFontOfSize:12];
        _lblTitle.textColor = [UIColor colorWithHexString:COLOR_TITLE_GRAY];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lblTitle];

        CGFloat y = 38;
        CGFloat x = 16;
        _btnSatisfy = [self buttonWithTitle:@"满意"
                                      frame:CGRectMake(58, y, 70, 26)
                                   selector:@selector(onSatisfyBtnClick:)
                                      image:[UIImage imageNamed:@"icon_satisfy_sel"]];
        _btnSatisfy.layer.borderColor = [UIColor colorWithHexString:COLOR_ORANGE].CGColor;
        [_btnSatisfy setTitleColor:[UIColor colorWithHexString:COLOR_ORANGE]
                          forState:UIControlStateNormal];
        [self addSubview:_btnSatisfy];
        
        _btnUnsatisfy = [self buttonWithTitle:@"不满意"
                                      frame:CGRectMake(frame.size.width - 70 - 58, y, 70, 26)
                                     selector:@selector(onSatisfyBtnClick:)
                                      image:[UIImage imageNamed:@"icon_unsatisfy"]];
        [_btnUnsatisfy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnUnsatisfy setTitleColor:[UIColor colorWithHexString:COLOR_ORANGE] forState:UIControlStateSelected];
        [self addSubview:_btnUnsatisfy];
        y += _btnSatisfy.frame.size.height + 16;
        
        _controlFirst = [[DQEvalueStarView alloc] initWithFrame:CGRectMake(x, y, 300, 24)
                                                      leftTitle:isPerson ? @"完成质量" : @"运行状况"];
        _controlFirst.delegate = self;
        _controlFirst.starTotalNumber = 5;
        _controlFirst.selectedStarNumber = 0;
        _controlFirst.minSelectedNumber = 0;
        _controlFirst.isNeedHalf = false;
        [self addSubview:_controlFirst];
        
        _controlSecond = [[DQEvalueStarView alloc]
                         initWithFrame:CGRectMake(x, _controlFirst.bottom + 8, 300, 24)
                          leftTitle:isPerson ? @"专项技能" : @"设备新旧"];
        _controlSecond.delegate = self;
        _controlSecond.starTotalNumber = 5;
        _controlSecond.selectedStarNumber = 0;
        _controlSecond.minSelectedNumber = 0;
        _controlSecond.isNeedHalf = false;
        [self addSubview:_controlSecond];
        
        y = _controlSecond.bottom + 16;
        if (isPerson) {
            _controlThird = [[DQEvalueStarView alloc]
                             initWithFrame:CGRectMake(x, _controlSecond.bottom + 8, 300, 24)
                             leftTitle:@"服务态度"];
            _controlThird.delegate = self;
            _controlThird.starTotalNumber = 5;
            _controlThird.selectedStarNumber = 0;
            _controlThird.minSelectedNumber = 0;
            _controlThird.isNeedHalf = false;
            [self addSubview:_controlThird];
            
            y = _controlThird.bottom + 16;
        }
        
        _contentTextView = [[HPGrowingTextView alloc] initWithFrame:
                            CGRectMake(16, y, frame.size.width - 32, 55)];
        _contentTextView.placeholder = STRING_SERVICE_PLACEHOLDER;
        _contentTextView.minNumberOfLines = 1;
        _contentTextView.maxNumberOfLines = 71;
        _contentTextView.returnKeyType = UIReturnKeyDone;
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.placeholderColor = [UIColor lightGrayColor];
        _contentTextView.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _contentTextView.font = [UIFont systemFontOfSize:12];
        _contentTextView.delegate = self;
        [self addSubview:_contentTextView];
        
        _lineBottom = [[UIView alloc] initWithFrame:
                       CGRectMake(16, CGRectGetMaxY(_contentTextView.frame), frame.size.width - 32, 1)];
        _lineBottom.backgroundColor = [UIColor colorWithHexString:COLOR_BLUE];
        [self addSubview:_lineBottom];
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)reloadFrame {

    // 计算文本框高度
    CGRect rectText = _contentTextView.frame;

    NSString *title = _contentTextView.text.length > 0 ? _contentTextView.text : _contentTextView.placeholder;
    CGSize size = [AppUtils textSizeFromTextString:title width:rectText.size.width height:1000 font:[UIFont systemFontOfSize:12]];

    rectText.size.height = size.height + 10;
    if (_contentTextView.text.length < 1) {
        rectText.size.height = 40;
    }
    _contentTextView.frame = rectText;
    
    _lineBottom.frame = CGRectMake(16, rectText.origin.y + rectText.size.height + 1, self.frame.size.width - 32, 1);
}

- (CGFloat)getMaxY {
    return CGRectGetMaxY(_lineBottom.frame) + 1;
}

// 刷新TextViewFrame并回调
- (void)reloadTextFrame {
    [self reloadFrame];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(willChangeHeight:evaluateView:)]) {
        [self.delegate willChangeHeight:CGRectGetMaxY(_lineBottom.frame) evaluateView:self];
    }
}

#pragma mark - Setter
- (void)setData:(DQLogicServiceBaseModel *)data
evaluate:(ServiceevaluateModel *)evaluate {
    
    self.canEdit = data.canEdit;
    // 租赁方不能操作
    self.userInteractionEnabled = data.canEdit;
    
//    _contentTextView.editable = data.canEdit;
    
    _lineBottom.backgroundColor = [data hexBorderColor];
    _line1.backgroundColor = [data hexBorderColor];
    _line2.backgroundColor = [data hexBorderColor];
    _lblTitle.textColor = [data hexTitleColor];

    if (evaluate) {
        _contentTextView.text = evaluate.assess;
        [_btnSatisfy setTitleColor:
         [UIColor colorWithHexString:evaluate.pleased == 1 ? COLOR_ORANGE : COLOR_BLACK]
                          forState:UIControlStateNormal];
        [_btnUnsatisfy setTitleColor:
         [UIColor colorWithHexString:evaluate.pleased == 0 ? COLOR_ORANGE : COLOR_BLACK]
                            forState:UIControlStateNormal];
        
        BOOL isPerson = _evaluateType == DQEvaluateTypeWorker ||
        _evaluateType == DQEvaluateTypePersonInService;
        _controlFirst.selectedStarNumber = isPerson ? evaluate.complete : evaluate.state;
        _controlSecond.selectedStarNumber = isPerson ? evaluate.skill : evaluate.old;
        _controlThird.selectedStarNumber = evaluate.service;
    }

    [self reloadFrame];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _lblTitle.text = titleStr;
}

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    _contentTextView.editable = canEdit;
}

- (void)setMaxLine:(int)maxLine {
    _maxLine = maxLine;
    _contentTextView.maxNumberOfLines = maxLine;
}

#pragma mark - Button clicks
- (void)onSatisfyBtnClick:(UIButton *)button {
    _isSatisfy = button == _btnSatisfy;
}

#pragma mark - DQEvaluaStarControlDelegate
- (void)starsControl:(DQEvalueStarView *)starsControl didChangeScore:(CGFloat)score {

    if (starsControl == _controlFirst) {
        _starFirst = score;
    }
    if (starsControl == _controlFirst) {
        _starSecond = score;
    }
    else {
        _starThird = score;
    }
}

#pragma mark - HPGrowingTextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    CGRect rect = _contentTextView.frame;
    rect.size.height = height;
    _contentTextView.frame = rect;
    
    [self reloadTextFrame];
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    if (growingTextView.text.length < 1) {
        [self reloadTextFrame];
    }
    _content = growingTextView.text;
}

@end

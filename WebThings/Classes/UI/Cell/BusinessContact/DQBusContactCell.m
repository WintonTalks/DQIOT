//
//  DQBusContactCell.m
//  WebThings
//  商函通知单Cell
//  Created by Heidi on 2017/10/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQBusContactCell.h"

#import "DQSubPackModel.h"
#import "DQLogicBusinessContractModel.h"

#import "DQFormView.h"

@interface DQBusContactCell ()

@property (nonatomic, retain) DQLogicBusinessContractModel *logicMode;

@end

@implementation DQBusContactCell

#pragma mark - Getter
- (UILabel *)labelWithTitle:(NSString *)title
                      frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = [UIFont dq_semiboldSystemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    
    return label;
}

#pragma mark - Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = screenWidth - 58 - 16;
        _dateView = [[DQDateSegmentView alloc] initWithFrame:CGRectMake(16, 16, 150, 28)];
        [self.contentView addSubview:_dateView];
        _dateView.hidden = YES;
        
        _formView = [[DQFormView alloc] initWithFrame:CGRectMake(16, 60, width, 194)];
        [self.contentView addSubview:_formView];
        
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 150)];
        [_formView addFormSubView:_bodyView];
        
        CGFloat y = 0;
        _lblTitle = [self labelWithTitle:@"商函日期"
                                   frame:CGRectMake(16, y, width/2.0 - 5, 14)];
        [_bodyView addSubview:_lblTitle];
        
        _lblTime = [self labelWithTitle:@""
                                   frame:CGRectMake(width/2.0, y, width/2.0 - 16, 16)];
        _lblTime.textAlignment = NSTextAlignmentRight;
        [_bodyView addSubview:_lblTime];
        
        y += 32;
        _lblContent = [self labelWithTitle:@""
                                   frame:CGRectMake(16, y, width - 32, 16)];
        _lblContent.numberOfLines = 0;
        _lblContent.lineBreakMode = NSLineBreakByWordWrapping;
        _lblContent.font = [UIFont dq_semiboldSystemFontOfSize:12];
        [_bodyView addSubview:_lblContent];
        
        _lineBottom = [[UIView alloc] initWithFrame:CGRectMake(16, y + 16, width - 32, 1.0)];
        _lineBottom.backgroundColor = [UIColor colorWithHexString:@"#ADADAD"];
        [_bodyView addSubview:_lineBottom];
        y += 16;
        
        _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSend.frame = CGRectMake(0, y, width, 44);
        _btnSend.titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
        [_btnSend setTitle:@"确认" forState:UIControlStateNormal];
        [_btnSend setTitleColor:[UIColor colorWithHexString:COLOR_BLUE]
                       forState:UIControlStateNormal];
        [_btnSend addTarget:self action:@selector(onSendClick) forControlEvents:UIControlEventTouchUpInside];
        [_bodyView addSubview:_btnSend];
        
        _btnIndictor = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnIndictor setImage:[UIImage imageNamed:@"icon_down_blue"] forState:UIControlStateNormal];
        _btnIndictor.frame = CGRectMake(screenWidth - 58, 60 - 22, 58, 58);
        [_btnIndictor addTarget:self action:@selector(onExpendClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnIndictor];
        _btnIndictor.hidden = YES;
    }
    return self;
}

/// 设置数据
- (void)setData:(DQLogicBusinessContractModel *)data {
    self.logicMode = data;
    
    CGFloat width = screenWidth - 58 - 16;
    BOOL hideTime = data.cellData.enumstateid != DQEnumStateBusContactSubmited;
    
    BOOL isBusAdd = data.cellData.enumstateid == DQEnumStateBusContactSubmited;
    data.cellData.title = isBusAdd ? @"商函通知" : @"整改意见";
    _lblTitle.text = isBusAdd ? @"商函日期" : @"检查日期";
    
    _lblTime.text = data.cellData.checkDate;
    _lblContent.text = data.cellData.content;
    _dateView.dateString = data.cellData.sendtime;
    
    _formView.frame = CGRectMake(16, hideTime ? 0 : 60, width, 194);
    _btnIndictor.frame = CGRectMake(screenWidth - 58, hideTime ? -22 : 38, 58, 58);
    
    _btnIndictor.hidden = YES;
    // 达到3个的时候且在商函通知一栏，显示下拉箭头
    if (isBusAdd) {
        _btnIndictor.hidden = !data.canExpend;
    }
    _dateView.hidden = hideTime;
    
    // 最后一条，且不是发起人，则可以商函通知确认／整改意见确认
    BOOL show = data.showConfirm;
    _btnSend.hidden = !show;
    _lineBottom.hidden = !show;
    
    CGSize size = [AppUtils
                   textSizeFromTextString:_lblContent.text
                   width:width - 32
                   height:1000
                   font:_lblContent.font];
    CGRect rect = _lblContent.frame;
    rect.size.height = size.height;
    _lblContent.frame = rect;
    
    CGFloat y = CGRectGetMaxY(_lblContent.frame) + 10;
    
    [_btnSend setTitle:@"确认" forState:UIControlStateNormal];

    if (show) { // button和横线布局和颜色
        _lineBottom.frame = CGRectMake(16, y, rect.size.width, 1.0);
        _btnSend.frame = CGRectMake(0, _lineBottom.frame.origin.y, width, 44);
        
        [_btnSend setTitleColor:[data hexTitleColor] forState:UIControlStateNormal];
        _lineBottom.backgroundColor = [data hexBorderColor];
        
        NSString *title = data.cellData.enumstateid ==
        DQEnumStateBusContactSubmited ? @"确认" : @"整改意见确认";
        [_btnSend setTitle:title forState:UIControlStateNormal];

        y += 44;
    } else {
        y += 6;
    }
    rect = _bodyView.frame;
    rect.size.height = y;
    _bodyView.frame = rect;
    
    [_formView setLogicServiceModel:data];
    [_formView reloadFormSubView];
    
    _btnIndictor.transform = CGAffineTransformMakeRotation(self.logicMode.isOpen ? 0 : M_PI);
}

#pragma mark -
// 确认按钮
- (void)onSendClick {
    [self.logicMode btnClicked];
}

// 展开／收起
- (void)onExpendClick {
    BOOL isOpen = self.logicMode.isOpen;
    self.logicMode.isOpen = !isOpen;
    
    if (self.reloadCellBlock) {
        self.reloadCellBlock(self.logicMode.isOpen);
    }
}

@end

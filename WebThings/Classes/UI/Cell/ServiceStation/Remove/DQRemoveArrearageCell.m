//
//  DQRemoveArrearageCell.m
//  WebThings
//  费用未缴清
//  Created by Heidi on 2017/10/24.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQRemoveArrearageCell.h"
#import "DQFormView.h"

#import "DQLogicRemoveModel.h"

@interface DQRemoveArrearageCell ()

@property (nonatomic, strong) DQLogicRemoveModel *logicModel;

@end

@implementation DQRemoveArrearageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = screenWidth - 58 - 16;
        _formView = [[DQFormView alloc] initWithFrame:CGRectMake(58, 0, width, 108)];
        [self.contentView addSubview:_formView];
        
        _btnPay = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPay setTitle:@"费用已缴清" forState:UIControlStateNormal];
        [_btnPay setTitleColor:[UIColor colorWithHexString:COLOR_BLUE]
                      forState:UIControlStateNormal];
        [_btnPay addTarget:self action:@selector(onPayClick) forControlEvents:UIControlEventTouchUpInside];
        _btnPay.titleLabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
        [_formView addFormSubView:_btnPay];
    }
    return self;
}

/// 设置数据
- (void)setData:(DQLogicRemoveModel *)data {
    self.logicModel = data;
    
    _btnPay.hidden = ![AppUtils readUser].isZuLin || !data.isLast;
    _btnPay.frame = CGRectMake(0, 0, _formView.width, _btnPay.hidden ? 0 : 36);

    data.cellData.title = @"费用未缴清，请立即缴费";
    _formView.logicServiceModel = data;
    [_formView reloadFormSubView];
}

#pragma mark -
// 费用已缴清
- (void)onPayClick {
    [self.logicModel btnConfirmOrRefuteBack:YES];
}

@end

//
//  DQDeviceRentCell.m
//  WebThings
//  设备启租单
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQDeviceRentCell.h"

#import "DQFormView.h"
#import "DQServiceBillView.h"

#import "DQSubRentModel.h"
#import "DQLogicRentModel.h"

@interface DQDeviceRentCell () <DQFormViewDelegate>

@property (nonatomic, strong) DQFormView *formView;
@property (nonatomic, strong) DQLogicRentModel *logicModel;

@end

@implementation DQDeviceRentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 表单view
        CGRect rect = CGRectMake(58, 0, screenWidth - 58 - 16, 325);
        
        _formView = [[DQFormView alloc] initWithFrame:rect];
        _formView.delegate = self;
        [self.contentView addSubview:_formView];
        
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 250)];
        [_formView addFormSubView:_bodyView];
        
        // 启租单据表单容器view
        _billView = [[DQServiceBillView alloc]
                     initWithFrame:CGRectMake(0, 16, rect.size.width, 250)];
        [_bodyView addSubview:_billView];
    }
    return self;
}

/// 设置数据
- (void)setData:(DQLogicRentModel *)data {
    data.cellData.title = @"设备启租单";
    data.billID = [NSString stringWithFormat:@"%ld", data.cellData.linkid];
    _logicModel = data;
     
    [_billView setData:[_logicModel arrayForBill]];
    _formView.logicServiceModel = _logicModel;
    
    CGFloat width = _formView.frame.size.width;
    _billView.frame = CGRectMake(0, 16, width, [_billView getViewHeight]);
    _bodyView.frame = CGRectMake(0, 0, width, _billView.frame.size.height + 16);
    
    [_formView reloadFormSubView];
}

#pragma mark - Delegate
/** 表单确认 */
- (void)formViewConfirm:(DQFormView *)formView {
     [_logicModel btnConfirmOrRefuteBack:YES];
}

/** 表单驳回 */
- (void)formViewIgnore:(DQFormView *)formView {
     [_logicModel btnConfirmOrRefuteBack:NO];
}

@end

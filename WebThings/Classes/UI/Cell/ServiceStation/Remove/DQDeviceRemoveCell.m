//
//  DQDeviceRemoveCell.m
//  WebThings
//  停租单
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQDeviceRemoveCell.h"

#import "DQLogicRemoveModel.h"
#import "DQSubRemoveModel.h"
#import "DeviceMaintainorderModel.h"

#import "DQFormView.h"
#import "DQServiceBillView.h"

@interface DQDeviceRemoveCell () <DQFormViewDelegate> {
    DQFormView *_formView;
}

@property (nonatomic, strong) DQLogicRemoveModel *logicModel;

@end

@implementation DQDeviceRemoveCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 表单view
        CGRect rect = CGRectMake(58, 0, screenWidth-75, 325);
        _formView = [[DQFormView alloc] initWithFrame:rect];
        _formView.delegate = self;
        [self.contentView addSubview:_formView];
        
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 250)];
        
        // 启租单据表单容器view
        _billView = [[DQServiceBillView alloc]
                     initWithFrame:CGRectMake(0, 10, rect.size.width, 240)];
        [_bodyView addSubview:_billView];
        
        [_formView addFormSubView:_bodyView];
    }
    return self;
}

/// 设置数据
- (void)setData:(DQLogicRemoveModel *)data {
    data.cellData.title = @"停租单";
//    data.billID = [NSString stringWithFormat:@"%ld", data.cellData.linkid];

    _logicModel = data;
    
    [_billView setData:[data arrayForBill]];
    _billView.frame = CGRectMake(0, 16, _formView.frame.size.width, [data heightForBill]);
    _bodyView.frame = CGRectMake(0, 0, _billView.frame.size.width, _billView.frame.size.height + 16);
    
    _formView.logicServiceModel = _logicModel;
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

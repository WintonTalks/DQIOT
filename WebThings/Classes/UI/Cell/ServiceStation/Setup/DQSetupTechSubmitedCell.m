//
//  DQSetupTechSubmitedCell.m
//  WebThings
//  现场技术已交底Cell
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQSetupTechSubmitedCell.h"

#import "DQSubSetupModel.h"
#import "DQLogicSetupModel.h"

#import "DQFormView.h"

@interface DQSetupTechSubmitedCell () <DQFormViewDelegate>

@property (nonatomic, strong) DQLogicSetupModel *logicModel;

@end

@implementation DQSetupTechSubmitedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat width = screenWidth - 58 - 16;
        _formView = [[DQFormView alloc] initWithFrame:CGRectMake(58, 0, width, 76)];
        _formView.delegate = self;
        [self.contentView addSubview:_formView];
    }
    return self;
}

/// 设置数据
- (void)setData:(DQLogicSetupModel *)data {
    data.billID = [NSString stringWithFormat:@"%ld", data.cellData.linkid];
    
    self.logicModel = data;
    data.cellData.title = @"现场技术已交底";
    _formView.logicServiceModel = data;
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

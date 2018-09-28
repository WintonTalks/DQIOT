//
//  DQCommunicateCell.m
//  WebThings
//
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQCommunicateCell.h"

#import "DQFormView.h"
#import "DQCommunicateFormView.h"

#import "DQLogicCommunicateModel.h"

@interface DQCommunicateCell ()<DQFormViewDelegate>

@property (nonatomic, strong) DQFormView *formView;
@property (nonatomic, strong) DQCommunicateFormView *communicateFormView;

@property (nonatomic, strong) DQLogicCommunicateModel *logicModel;

@end

@implementation DQCommunicateCell

#pragma mark - Life Cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCommunicateView];
    }
    return self;
}

- (void)initCommunicateView {
        
    // 表单view
    CGRect rect = CGRectMake(60, 0, screenWidth-75, 200);
    DQFormView *formView = [[DQFormView alloc] initWithFrame:rect];
    formView.delegate = self;
    formView.isHiddenFoldBtn = NO;
    [self.contentView addSubview:formView];
    _formView = formView;
    
    // 表单容器view
    DQCommunicateFormView *communicateFormView = [[DQCommunicateFormView alloc] init];
    communicateFormView.frame = CGRectMake(0, 0, 260, 200);
    [_formView addFormSubView:communicateFormView];
    _communicateFormView = communicateFormView;
}

#pragma mark - 数据处理
- (void)setData:(DQLogicCommunicateModel *)data {
    _logicModel = data;
    
    [self updateFormViewWithIsOpen:_logicModel.isOpen];
}

- (void)updateFormViewWithIsOpen:(BOOL)isOpen {
    
    _logicModel.cellData.title = @"进场沟通单";

    _formView.logicServiceModel = _logicModel;
    _communicateFormView.logicModel = _logicModel;
    _communicateFormView.height = [_communicateFormView getCommunicateFormViewHeight];
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

/** 表单折叠 */
- (void)formViewUnfold:(BOOL)isUnfold {
    _logicModel.isOpen = isUnfold;
    // 上传cell刷新事件
    if (self.reloadCellBlock != nil) {
        self.reloadCellBlock(YES);
    }
    //[self updateFormViewWithIsOpen:isUnfold];
}

@end

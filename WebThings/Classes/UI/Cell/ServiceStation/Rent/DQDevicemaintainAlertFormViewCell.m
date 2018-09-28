//
//  DQDevicemaintainAlertFormViewCell.m
//  WebThings
//
//  Created by Eugene on 10/26/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQDevicemaintainAlertFormViewCell.h"
#import "DQFormView.h"

#import "DQLogicMaintainModel.h"

@interface DQDevicemaintainAlertFormViewCell ()<DQFormViewDelegate>

@property (nonatomic, strong) DQFormView *formView;
@property (nonatomic, strong) DQLogicMaintainModel *logicModel;

@end

@implementation DQDevicemaintainAlertFormViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self  initAlertFormView];
    }
    return self;
}

- (void)initAlertFormView {
    
    // 表单view
    _formView = [[DQFormView alloc] initWithFrame:CGRectMake(16, 0, screenWidth - 75, 200)];
    _formView.delegate = self;
    _formView.isHiddenFoldBtn = YES;
    [self.contentView addSubview:_formView];
}

- (void)setData:(DQLogicMaintainModel *)data {
    _logicModel = data;
    
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

//
//  DQDeviceMaintainFinishFormViewCell.m
//  WebThings
//
//  Created by Eugene on 10/11/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQDeviceMaintainFinishFormViewCell.h"
#import "DQFormView.h"
#import "DQServiceBillView.h" // 表单容器
#import "ServiceImageBrowser.h" // 图片容器

#import "DeviceMaintainorderModel.h"// 设备维保单,维修单，加高单，拆除单
#import "DQLogicMaintainModel.h"
#import "DQFinishOrderModel.h"//完成单

@interface DQDeviceMaintainFinishFormViewCell ()<DQFormViewDelegate>

@property (nonatomic, strong) DQFormView *formView;
/** 信息和图片表单的承载view */
@property (nonatomic, strong) UIView *containView;
/** 项目信息表单view */
@property (nonatomic, strong) DQServiceBillView *billView;
/** 图片表单view */
@property (nonatomic, strong) ServiceImageBrowser *imgBrowser;

@property (nonatomic, strong) DQLogicMaintainModel *logicModel;


/** 加高数据 */
@property (nonatomic, strong) NSArray *heightenAry;
/** 维修数据 */
@property (nonatomic, strong) NSArray *serviceAry;
/** 维保数据 */
@property (nonatomic, strong) NSArray *maintainAry;

@end

@implementation DQDeviceMaintainFinishFormViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initFinishFormView];
    }
    return self;
}

- (void)initFinishFormView {

    // 表单view
    _formView = [[DQFormView alloc] initWithFrame:CGRectMake(16, 0, screenWidth - 75, 200)];
    _formView.delegate = self;
    _formView.isHiddenFoldBtn = YES;
    [self.contentView addSubview:_formView];

    _containView = [[UIView alloc] init];
    _containView.frame = CGRectMake(0, 0, _formView.frame.size.width, 0);
    
    {
        // 维保单据表单容器view
        _billView = [[DQServiceBillView alloc]
                     initWithFrame:CGRectMake(0, 16, _containView.width, 100)];
        [_containView addSubview:_billView];
        
        _imgBrowser = [[ServiceImageBrowser alloc] initWithFrame:CGRectMake(0, _billView.bottom, _formView.frame.size.width, 0)];
        [_containView addSubview:_imgBrowser];
    }
    
    [_formView addFormSubView:_containView];
}

/// 设置数据
- (void)setData:(DQLogicMaintainModel *)data {
    _logicModel = data;
 
    [self updateFormView];
}

- (void)updateFormView {
 
    DeviceMaintainorderModel *model = _logicModel.devieceOrderModel;
    // 完成单
    DQFinishOrderModel *finishOrder = [DQFinishOrderModel mj_objectWithKeyValues:model.finshorder];
    NSArray *imgAry = [NSArray array];
    imgAry = [finishOrder.imgs componentsSeparatedByString:@","];

    NSMutableArray *imgUrls = [NSMutableArray array];
    for (int index = 0; index < imgAry.count; index++) {
        [imgUrls addObject:appendUrl(imgUrl, [imgAry objectAtIndex:index])];
        if (imgUrls.count == 6) {   //最多展示6条
            break;
        }
    }
    
    
    [_imgBrowser setImgArrs:imgUrls];
    [_billView setData:_logicModel.arrayForBill];
    _formView.logicServiceModel = _logicModel;

    
    CGRect rect = _billView.frame;
    rect.size.height = [_billView getViewHeight];
    _billView.frame = rect;
    _imgBrowser.top = CGRectGetMaxY(_billView.frame);
    _containView.frame = CGRectMake(0, 0, _formView.width, CGRectGetMaxY(_imgBrowser.frame));
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

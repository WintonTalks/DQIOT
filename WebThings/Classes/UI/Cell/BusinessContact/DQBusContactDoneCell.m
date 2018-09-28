//
//  DQBusContactDoneCell.m
//  WebThings
//  整改完成单
//  Created by Heidi on 2017/10/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQBusContactDoneCell.h"
#import "DQSubBusinessContractModel.h"

#import "DQSubPackModel.h"
#import "DQLogicBusinessContractModel.h"
#import "MsgattachmentListModel.h"

#import "DQFormView.h"
#import "ServiceImageBrowser.h"
#import "DQServiceBillView.h"

@interface DQBusContactDoneCell ()
<DQFormViewDelegate>

@property (nonatomic, retain) DQLogicBusinessContractModel *logicModel;

@end

@implementation DQBusContactDoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = screenWidth - 58 - 16;
        _formView = [[DQFormView alloc] initWithFrame:CGRectMake(16, 0, width, 338)];
        _formView.delegate = self;
        [self.contentView addSubview:_formView];
        
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 528)];

        _billView = [[DQServiceBillView alloc]
                     initWithFrame:CGRectMake(0, 0, width, 289)];
        [_bodyView addSubview:_billView];

        _imgBrowser = [[ServiceImageBrowser alloc] initWithFrame:CGRectMake(0, 5, width, 208)];
        [_bodyView addSubview:_imgBrowser];
        
        [_formView addFormSubView:_bodyView];
    }
    return self;
}

/// 设置数据
- (void)setData:(DQLogicBusinessContractModel *)data {
    self.logicModel = data;
    
    data.cellData.title = @"整改完成单";
    DQSubBusinessContractModel *model = (DQSubBusinessContractModel *)data.cellData;

    [_billView setData:[data arrayForBill]];
    
    NSMutableArray *imgArrs = [NSMutableArray array];
    for (NSString *imageName in model.imgLists) {
        [imgArrs addObject:appendUrl(imgUrl, imageName)];
//        if (imgArrs.count == 6) {   //最多展示6条
//            break;
//        }
    }
    [_imgBrowser setImgArrs:imgArrs];
    
    CGRect rect = _billView.frame;
    rect.size.height = [_billView getViewHeight];
    _billView.frame = rect;
    
    CGRect rectBrower = _imgBrowser.frame;
    rectBrower.size.height = [_imgBrowser getMaxHeight];
    rectBrower.origin.y = rect.size.height;
    _imgBrowser.frame = rectBrower;
    
    CGRect rectBody = _bodyView.frame;
    rectBody.size.height = rectBrower.origin.y + rectBrower.size.height;
    _bodyView.frame = rectBody;

    _formView.logicServiceModel = data;

    [_formView reloadFormSubView];
}

#pragma mark - DQFormViewDelegate
/** 表单确认 */
- (void)formViewConfirm:(DQFormView *)formView {
    [self.logicModel btnConfirmOrRefuteBack:YES];
}

/** 表单驳回 */
- (void)formViewIgnore:(DQFormView *)formView {
    [self.logicModel btnConfirmOrRefuteBack:NO];
}

@end

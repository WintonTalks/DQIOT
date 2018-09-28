//
//  DQPackCell.m
//  WebThings
//
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQPackCell.h"

#import "DQSubPackModel.h"
#import "DQLogicPackModel.h"
#import "MsgattachmentListModel.h"

#import "DQFormView.h"
#import "ServiceImageBrowser.h"

@interface DQPackCell ()<DQFormViewDelegate>

@property (nonatomic, strong) DQLogicPackModel *logicModel;

@end

@implementation DQPackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = screenWidth - 58 - 16;
        _formView = [[DQFormView alloc] initWithFrame:CGRectMake(58, 0, width, 338)];
        _formView.delegate = self;
        [self.contentView addSubview:_formView];
        
        _imgBrowser = [[ServiceImageBrowser alloc] initWithFrame:CGRectMake(0, 5, width, 208)];
        [_formView addFormSubView:_imgBrowser];
    }
    return self;
}

/// 设置数据
- (void)setData:(DQLogicPackModel *)data {
    self.logicModel = data;
    data.cellData.title = @"设备资料提交";
    data.billID = [NSString stringWithFormat:@"%ld", data.cellData.linkid];
    DQSubPackModel *cellData = (DQSubPackModel *)data.cellData;
    NSMutableArray *imgArrs = [NSMutableArray array];
    for (MsgattachmentListModel *item in cellData.msgattachmentList) {
        [imgArrs addObject:appendUrl(imgUrl, item.fileurl)];
        if (imgArrs.count == 6) {   //最多展示6条
            break;
        }
    }
    [_imgBrowser setImgArrs:imgArrs];
    
    _formView.logicServiceModel = data;
    DQSubPackModel *pack = (DQSubPackModel *)data.cellData;
    _imgBrowser.frame = CGRectMake(0, 5, screenWidth - 58 - 16, ceilf([pack.msgattachmentList count]/3.0) * 125);
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

//
//  DQSourceBrowerCell.m
//  WebThings
//  资料展示，图片或PDF，Word文档
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQSourceBrowerCell.h"

#import "DQSubPackModel.h"
#import "DQLogicPackModel.h"
#import "MsgattachmentListModel.h"

#import "DQFormView.h"
#import "ServiceImageBrowser.h"

@interface DQSourceBrowerCell ()<DQFormViewDelegate>

@property (nonatomic, strong) DQLogicPackModel *logicModel;

@end

@implementation DQSourceBrowerCell

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
        if (imgArrs.count < 6) {   //最多展示6条
            [imgArrs addObject:appendUrl(imgUrl, item.fileurl)];
        }
    }
    [_imgBrowser setImgArrs:imgArrs];
    
    _formView.frame = CGRectMake(58, 0, _imgBrowser.frame.size.width, _imgBrowser.frame.size.height);
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

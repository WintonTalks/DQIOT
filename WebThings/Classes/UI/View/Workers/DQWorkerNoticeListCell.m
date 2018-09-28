//
//  DQWorkerNoticeListCell.m
//  WebThings
//
//  Created by Eugene on 2017/9/21.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQWorkerNoticeListCell.h"

@interface DQWorkerNoticeListCell ()

/** 底部背景view */
@property (weak, nonatomic) IBOutlet UIView *bgView;

/** 故障进度图片 */
@property (weak, nonatomic) IBOutlet UIImageView *planImageView;
/** 消息通知类型 */
@property (weak, nonatomic) IBOutlet UIImageView *noticeTypeImageView;

/** 通知类型标签 */
@property (weak, nonatomic) IBOutlet UILabel *noticeTypeLabel;
/** 项目名标签 */
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
/** 故障描述标签 */
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
/** 日期标签 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
/** 分割线 */
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation DQWorkerNoticeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _bgView.backgroundColor = [UIColor whiteColor];
    
}

- (void)setNoticeModel:(DWMsgModel *)noticeModel {
    _noticeModel = noticeModel;
    
    _noticeTypeImageView.image = [noticeModel returnImg];
    _noticeTypeLabel.text = noticeModel.noticetype;
    _noticeTypeLabel.textColor = [noticeModel returnColor];
    
    if ([noticeModel.isfinish isEqualToString:@"未完成"]) {
        _planImageView.hidden = YES;
        _lineView.hidden = NO;
    } else {
        _planImageView.hidden = NO;
        _lineView.hidden = YES;
    }
    
    if (noticeModel.title) {
        _projectNameLabel.text = noticeModel.title;
        _descLabel.text = noticeModel.msg;
    } else {
        _projectNameLabel.text = noticeModel.orgname;
        _descLabel.text = [NSString stringWithFormat:@"%@-%@-%@-%@",noticeModel.projectname,noticeModel.model,noticeModel.address,noticeModel.descartion];
    }
    _dateLabel.text = noticeModel.cdate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

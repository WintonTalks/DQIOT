//
//  DQTraingRecordingCell.m
//  WebThings
//
//  Created by winton on 2017/9/30.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQTraingRecordingCell.h"
#import "HeadImgV.h"
#import "DQTranrecordListModel.h"

@interface DQTraingRecordingCell()
@property (nonatomic, strong) HeadImgV *headView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *projectNameLb;
@property (nonatomic, strong) UILabel *projectTypeLb;
@property (nonatomic, strong) UILabel *projectTimeLb;
@property (nonatomic, strong) UIView *footView;
@end

@implementation DQTraingRecordingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addTraingRecordingInfoView];
    }
    return self;
}

- (void)addTraingRecordingInfoView
{
    _headView = [[HeadImgV alloc] initWithFrame:CGRectMake(16, 16, 46, 46)];
    [_headView borderWid:1];
    [_headView borderColor:[UIColor colorWithHexString:@"407ee9"]];
    [self.contentView addSubview:_headView];
    
    _nameLb = [[UILabel alloc] initWithFrame:CGRectMake(_headView.right+16, 30, 0, 18)];
    _nameLb.font = [UIFont dq_boldSystemFontOfSize:14];
    _nameLb.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _nameLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLb];
    
    _projectNameLb = [[UILabel alloc] initWithFrame:CGRectMake(_headView.left, _headView.bottom+24, 0, 18)];
    _projectNameLb.font = [UIFont dq_mediumSystemFontOfSize:14];
    _projectNameLb.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _projectNameLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_projectNameLb];

    _projectTypeLb = [[UILabel alloc] initWithFrame:CGRectMake(_headView.left, _projectNameLb.bottom+16, 0, 18)];
    _projectTypeLb.font = [UIFont dq_mediumSystemFontOfSize:14];
    _projectTypeLb.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _projectTypeLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_projectTypeLb];

    _projectTimeLb = [[UILabel alloc] initWithFrame:CGRectMake(_headView.left, _projectTypeLb.bottom+16, 0, 18)];
    _projectTimeLb.font = [UIFont dq_mediumSystemFontOfSize:14];
    _projectTimeLb.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _projectTimeLb.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_projectTimeLb];
    
    _footView = [[UIView alloc] initWithFrame:CGRectZero];
    _footView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    [self.contentView addSubview:_footView];
}

- (void)configTraingRecordingModel:(DQTranrecordListModel *)model
{
    _nameLb.text = model.name;
    _projectNameLb.text = [NSString stringWithFormat:@"项目名称: %@",model.projectname];
    _projectTypeLb.text = [NSString stringWithFormat:@"培训类型: %@",model.type];
    _projectTimeLb.text = [NSString stringWithFormat:@"培训时间: %@",[NSDate verifyDateForYMD:model.date]];
    _headView.image = [_headView defaultImageWithName:[model.name substringWithRange:NSMakeRange(0, 1)]];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat nameWidth = [AppUtils textWidthSystemFontString:_nameLb.text height:18 font:_nameLb.font];
    CGFloat projectWidth = [AppUtils textWidthSystemFontString:_projectNameLb.text height:18 font:_projectNameLb.font];
    CGFloat typeWidth = [AppUtils textWidthSystemFontString:_projectTypeLb.text height:18 font:_projectTypeLb.font];
    CGFloat timeWidth = [AppUtils textWidthSystemFontString:_projectTimeLb.text height:18 font:_projectTimeLb.font];
    self.nameLb.width = nameWidth;
    self.projectNameLb.width = projectWidth;
    self.projectTypeLb.width = typeWidth;
    self.projectTimeLb.width = timeWidth;
    
    if (self.contentView.height == 189) {
        _footView.hidden = false;
        _footView.frame = CGRectMake(0, self.contentView.height-8, self.contentView.width, 8);
    } else {
        _footView.hidden = true;
    }
}

@end

//
//  DQDericePhotoListCell.m
//  WebThings
//
//  Created by winton on 2017/10/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQDericePhotoListCell.h"
#import "HeadImgV.h"
#import "DQDerivePhotoAlumView.h"
#import "DQUserQualificationModel.h"

@interface DQDericePhotoListCell()

@property (nonatomic, strong) HeadImgV *headView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *certificateLabel;
@property (nonatomic, strong) DQDerivePhotoAlumView *alumView;
@property (nonatomic, strong) NSMutableArray *photoList;
@end

@implementation DQDericePhotoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.headView];
        [self.contentView addSubview:self.nameLabel];
        [self addMangerInfoView];
    }
    return self;
}

- (void)configQualificationInfoModel:(DQUserQualificationModel *)model
{
    NSMutableString *mString = [NSMutableString stringWithFormat:@"%@",model.credentials];
    NSArray *photoUrlList = [mString componentsSeparatedByString:@","];
    if (photoUrlList.count) {//多个
        [_alumView configAlubmPhoto:photoUrlList];
    } else {//单个
        [_alumView configAlubmPhoto:@[mString]];
    }
    self.headView.image = [self.headView defaultImageWithName:[model.name substringWithRange:NSMakeRange(0, 1)]];
    self.nameLabel.text = model.name;
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _alumView.top = _certificateLabel.top;
    _alumView.height = self.contentView.height-_certificateLabel.top;
    [_alumView layoutIfNeeded];
    
    CGFloat width = [AppUtils textWidthSystemFontString:self.nameLabel.text height:self.nameLabel.height font:self.nameLabel.font];
    self.nameLabel.width = width;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _alumView.indexPath = indexPath;
}

#pragma mark -UI
- (HeadImgV *)headView
{
    if (!_headView) {
        _headView = [[HeadImgV alloc] initWithFrame:CGRectMake(16, 16, 46, 46)];
        [_headView borderWid:1];
        [_headView borderColor:[UIColor colorWithHexString:@"407ee9"]];
    }
    return _headView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headView.right+16, 28, 0, 16)];
        _nameLabel.font = [UIFont dq_boldSystemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    }
    return _nameLabel;
}

- (void)addMangerInfoView
{
    _certificateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headView.left, self.headView.bottom+16, 57, 18)];
    _certificateLabel.text = @"证书";
    _certificateLabel.font = [UIFont dq_semiboldSystemFontOfSize:16];
    _certificateLabel.textAlignment = NSTextAlignmentLeft;
    _certificateLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    [self.contentView addSubview:_certificateLabel];

    _alumView = [[DQDerivePhotoAlumView alloc] initWithFrame:CGRectMake(_certificateLabel.right+5, _certificateLabel.top, 138*2+8, 94) type:KDQDerivePhotoAlumLeftStyle];
    _alumView.userInteractionEnabled = true;
    [self.contentView addSubview:_alumView];
}

- (NSMutableArray *)photoList
{
    if (!_photoList) {
        _photoList = [NSMutableArray new];
    }
    return _photoList;
}

@end

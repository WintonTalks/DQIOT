//
//  DQUserCenterHeaderCell.m
//  WebThings
//
//  Created by 孙文强 on 2017/9/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQUserCenterHeaderCell.h"
#import "HeadImgV.h"
@interface DQUserCenterHeaderCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobAtLabel;
@property (nonatomic, strong) UIImageView *infoView;
@property (nonatomic, strong) HeadImgV *headView;
@end

@implementation DQUserCenterHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.infoView];
    [self.infoView addSubview:self.headView];
    [self.infoView addSubview:self.nameLabel];
    [self.infoView addSubview:self.jobAtLabel];
}

- (void)configModel:(UserModel *)baseModel
{
    [self.headView setImageWithURL:[NSURL URLWithString:appendUrl(imgUrl, baseModel.headimg)] placeholderImage:[self.headView defaultImageWithName:baseModel.name]];
    self.nameLabel.text = baseModel.name;
    self.jobAtLabel.text = baseModel.usertype;
    CGFloat width = [AppUtils textWidthSystemFontString:self.nameLabel.text height:24 font:self.nameLabel.font];
    self.headView.top = (self.infoView.height-42)/2;
    self.nameLabel.top = (self.infoView.height-24)/2;
    self.nameLabel.width = width;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headView.right+20, 0, 0, 24)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIImageView *)infoView
{
    if (!_infoView) {
        _infoView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, screenWidth-16, 74.f)];
        _infoView.image = ImageNamed(@"Rectangle");
    }
    return _infoView;
}

- (HeadImgV *)headView
{
    if (!_headView) {
        _headView = [[HeadImgV alloc] initWithFrame:CGRectMake(16, 0, 42, 42)];
    }
    return _headView;
}

- (UILabel *)jobAtLabel
{
    if (!_jobAtLabel) {
        _jobAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.infoView.width-33-70, (self.infoView.height-20)/2, 70, 20)];
        _jobAtLabel.textColor = [UIColor whiteColor];
        _jobAtLabel.textAlignment = NSTextAlignmentCenter;
        _jobAtLabel.font = [UIFont boldSystemFontOfSize:12];
        _jobAtLabel.layer.masksToBounds = true;
        _jobAtLabel.layer.cornerRadius = 2.f;
        _jobAtLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        [_jobAtLabel borderWid:1.f];
    }
    return _jobAtLabel;
}

@end

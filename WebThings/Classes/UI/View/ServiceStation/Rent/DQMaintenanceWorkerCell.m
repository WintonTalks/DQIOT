//
//  DQMaintenanceWorkerCell.m
//  WebThings
//
//  Created by Eugene on 10/9/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#define kMargin 16 // 间距

#import "DQMaintenanceWorkerCell.h"
#import "CDFInitialsAvatar.h"

@interface DQMaintenanceWorkerCell ()

/** 维保工人头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** 工人名 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 联系方式（手机号） */
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation DQMaintenanceWorkerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWorkerView];
    }
    return self;
}

- (void)initWorkerView {
 
    UIColor *color = [UIColor colorWithHexString:COLOR_BTN_BLUE];
    CALayer *subLayer = [CALayer layer];
    CGRect fixframe = CGRectMake(kMargin, self.contentView.centerY-19, 38, 38);
    subLayer.frame = fixframe;
    subLayer.cornerRadius = 38/2.0;
    subLayer.backgroundColor = [color colorWithAlphaComponent:0.9].CGColor;
    subLayer.masksToBounds = NO;
    subLayer.shadowColor = color.CGColor;
    subLayer.shadowOffset = CGSizeMake(0,4);
    subLayer.shadowOpacity = 0.4;
    subLayer.shadowRadius = 3;
    [self.layer addSublayer:subLayer];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, self.contentView.centerY-19, 38, 38)];
    _avatarImageView.image = [self getAvatarImageWithName:@"张艳金" color:COLOR_BLUE];
    _avatarImageView.layer.cornerRadius = 38/2.0;
    _avatarImageView.layer.masksToBounds = YES;
    [self addSubview:_avatarImageView];
    //[_avatarImageView bezierPathWithRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(19, 19)];
    
    
//    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(kMargin, self.contentView.centerY-19, 38, 38)];
//    [self addSubview:shadowView];
//    shadowView.layer.shadowColor = [UIColor colorWithRed:150/255.0 green:196/255.0 blue:250/255.0 alpha:1/1.0].CGColor;
//    shadowView.layer.shadowOffset = CGSizeMake(3, 3);
//    shadowView.layer.shadowOpacity = 0.4;
//    shadowView.layer.shadowRadius = 38/2.0;
//    shadowView.layer.cornerRadius = 38/2.0;
//    shadowView.clipsToBounds = NO;
//    [shadowView addSubview:_avatarImageView];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(_avatarImageView.right+kMargin, _avatarImageView.top, 100, _avatarImageView.height);
    _nameLabel.text = @"Eugene";
    _nameLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _nameLabel.font = [UIFont dq_semiboldSystemFontOfSize:14.0];
    [self addSubview:_nameLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.frame = CGRectMake(_nameLabel.right, _nameLabel.top, self.frame.size.width-CGRectGetMaxX(_nameLabel.frame), _nameLabel.height);
    _detailLabel.text = @"Zyj";
    _detailLabel.textAlignment = NSTextAlignmentRight;
    _detailLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _detailLabel.font = [UIFont dq_semiboldSystemFontOfSize:14.0];
    [self addSubview:_detailLabel];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _detailLabel.frame = CGRectMake(_nameLabel.right, _nameLabel.top, self.frame.size.width-CGRectGetMaxX(_nameLabel.frame)-16, _nameLabel.height);
}

/** 用户头像占位图片  */
- (UIImage *_Nonnull)getAvatarImageWithName:(NSString *_Nonnull)name color:(NSString*)color {
    
    CDFInitialsAvatar *topAvatar = [[CDFInitialsAvatar alloc] initWithRect:self.avatarImageView.bounds fullName:name];
    topAvatar.initialsColor = [UIColor colorWithHexString:color];
    topAvatar.backgroundColor = [UIColor whiteColor];
    topAvatar.initialsFont = [UIFont dq_semiboldSystemFontOfSize:16];
    return topAvatar.imageRepresentation;
}

#pragma mark - Getter And Setter
- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    
    UIImage *image = [self getAvatarImageWithName:[NSObject changeType:userModel.name] color:COLOR_BLUE];
    [_avatarImageView setImageWithURL:[NSURL URLWithString:userModel.headimg] placeholderImage:image];
    
    _nameLabel.text = userModel.name;
    _detailLabel.text = userModel.dn;
    
}
@end

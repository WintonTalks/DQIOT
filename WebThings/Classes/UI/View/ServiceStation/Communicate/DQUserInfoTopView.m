//
//  DQUserInfoTopView.m
//  WebThings
//
//  Created by Eugene on 27/09/2017.
//  Copyright © 2017 machinsight. All rights reserved.
//  前期沟通-》沟通表单 topView用户信息

#import "DQUserInfoTopView.h"
#import "CDFInitialsAvatar.h" // 将字符串首字母合成图片显示

#import "DQLogicServiceBaseModel.h"

const NSInteger userMargin = 16;

@interface DQUserInfoTopView ()

/** 头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** 用户名 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 描述标签 */
@property (nonatomic, strong) UILabel *descLabel;
/** 日期 */
@property (nonatomic, strong) UILabel *dateLabel;
/** 折叠按钮 */
@property (nonatomic, strong) UIButton *foldButton;

@end

@implementation DQUserInfoTopView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInfoTopView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUserInfoTopView];
    }
    return self;
}

- (void)initUserInfoTopView {
    
    self.backgroundColor = [UIColor colorWithHexString:COLOR_BLUE_LIGHT];// alpha:0.3
    
    // ----- 头像 -----
    [self addSubview:self.avatarImageView];

    // ----- 用户名 -----
    self.nameLabel.text = @"张艳金";
    [self setLabel:self.nameLabel alignment:NSTextAlignmentLeft textColor:COLOR_BLACK font:12];
    [self addSubview:self.nameLabel];
    
    // ----- 描述标签 -----
    self.descLabel.text = @"进场沟通单";
    [self setLabel:self.descLabel alignment:NSTextAlignmentLeft textColor:@"#256CE6" font:14];
    [self addSubview:self.descLabel];
    
    // ----- 日期 -----
    self.dateLabel.text = @"2017/09/21 19:21";
    [self setLabel:self.dateLabel alignment:NSTextAlignmentRight textColor:@"#797979" font:12];
    [self addSubview:self.dateLabel];
    
    // ----- 折叠 -----
    self.foldButton.hidden = YES;
    [self addSubview:self.foldButton];

}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)layoutSubViewsWithDirection:(NSInteger)direction {
    
    if (direction == DQDirectionLeft) { //用户头像方向,0:向左 1:向右
        [self leftLayout];
    } else {
        [self rightLayout];
    }
}

- (void)leftLayout {
    
    DQServiceSubNodeModel *model = _viewData.cellData;

    self.avatarImageView.frame = CGRectMake(userMargin, self.height/2-23, 46, 46);
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:appendUrl(imgUrl, model.sendheadimg)] placeholderImage:[self getAvatarImageWithName:model.sendname color:COLOR_BLUE]];
    self.nameLabel.frame = CGRectMake(self.avatarImageView.right+userMargin, userMargin, 80, userMargin);
    
    CGFloat width = self.width - 112;
//    CGSize size = [AppUtils
//                   textSizeFromTextString:self.descLabel.text
//                   width:width
//                   height:100
//                   font:self.descLabel.font];
//    self.descLabel.frame = CGRectMake(self.nameLabel.left, self.height - 21 - size.height, size.width, size.height);
    self.descLabel.frame = CGRectMake(self.nameLabel.left, self.height - 21 - 14, width, 14);
    self.dateLabel.frame = CGRectMake(self.width - 141, self.nameLabel.top, 125, 18);
    self.foldButton.frame = CGRectMake(self.width-userMargin-25, self.dateLabel.bottom, 40, 40);
    [self.foldButton setImage:[UIImage imageNamed:@"business_service_fold_icon"] forState:UIControlStateNormal];
}

- (void)rightLayout {
    
    DQServiceSubNodeModel *model = _viewData.cellData;

//    CGFloat width = self.width - self.descLabel.left - 40;
//    CGSize size = [AppUtils
//                   textSizeFromTextString:self.descLabel.text
//                   width:width
//                   height:100
//                   font:self.descLabel.font];

    self.avatarImageView.frame = CGRectMake(self.width-userMargin-46, self.height/2-23, 46, 46);
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:appendUrl(imgUrl, model.sendheadimg)] placeholderImage:[self getAvatarImageWithName:model.sendname color:COLOR_GREEN]];
    self.nameLabel.frame = CGRectMake(userMargin, userMargin, 80, userMargin);
    self.descLabel.frame = CGRectMake(self.nameLabel.left, self.height - 21 - 14, self.width - 112, 14);
    self.dateLabel.frame = CGRectMake(self.nameLabel.right, self.nameLabel.top, self.width-self.nameLabel.right-userMargin*2-46, userMargin);
    self.foldButton.frame = CGRectMake(self.dateLabel.right-20, self.dateLabel.bottom, 40, 40);
    [self.foldButton setImage:[UIImage imageNamed:@"icon_indictor_green"] forState:UIControlStateNormal];
}

#pragma mark - Public Methods
- (void)foldTableViewAction:(UIButton *)sender {
 
    sender.selected = !sender.selected;
    CGFloat angle = sender.selected ? M_PI:M_PI*2;
    _foldButton.imageView.transform = CGAffineTransformMakeRotation(angle);
   
    // 折叠Block
    self.unfoldBlock(sender.selected);
}

#pragma mark - Private Methods
/** 用户头像占位图片  */
- (UIImage *_Nonnull)getAvatarImageWithName:(NSString *_Nonnull)name color:(NSString*)color {
    
    CDFInitialsAvatar *topAvatar = [[CDFInitialsAvatar alloc] initWithRect:self.avatarImageView.bounds fullName:name];
    topAvatar.initialsColor = [UIColor colorWithHexString:color];
    topAvatar.backgroundColor = [UIColor whiteColor];
    topAvatar.initialsFont = [UIFont dq_semiboldSystemFontOfSize:16];
    return topAvatar.imageRepresentation;
}

- (void)setLabel:(UILabel *)label alignment:(NSTextAlignment)align textColor:(NSString *)hex font:(CGFloat)value {
    
    label.textAlignment = align;
    label.textColor = [UIColor colorWithHexString:hex];
    label.font = [UIFont dq_semiboldSystemFontOfSize:value];
}

#pragma mark - Getter and Setter
- (void)setIsHidden:(BOOL)isHidden {
    _isHidden = isHidden;
    self.foldButton.hidden = isHidden;
}

- (UIImageView *)avatarImageView {
    
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 23;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UILabel *)descLabel {
    
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
//        _descLabel.numberOfLines = 0;
//        _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _descLabel;
}

- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
    }
    return _dateLabel;
}

- (UIButton *)foldButton {
    
    if (!_foldButton) {
        _foldButton = [[UIButton alloc] init];
        [_foldButton addTarget:self action:@selector(foldTableViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_foldButton setImage:[UIImage imageNamed:@"business_service_fold_icon"]
                     forState:UIControlStateNormal];
    }
    return _foldButton;
}

// 设置数据
- (void)setViewData:(DQLogicServiceBaseModel *)viewData {
    _viewData = viewData;
    
    [self layoutSubViewsWithDirection:viewData.direction];
    
    DQServiceSubNodeModel *model = viewData.cellData;
    _nameLabel.text = model.sendname;
    _dateLabel.text = model.sendtime;
    _descLabel.text = model.title;

    self.backgroundColor = viewData.hexBgColor;
    self.descLabel.textColor = viewData.hexTitleColor;
}

@end

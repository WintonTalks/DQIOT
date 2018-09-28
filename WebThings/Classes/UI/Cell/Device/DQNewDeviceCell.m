//
//  DQNewDeviceCell.m
//  WebThings
//
//  Created by winton on 2017/10/18.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQNewDeviceCell.h"

@interface DQNewDeviceCell()
{
    UILabel *_numberLabel;
}
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *addressLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIView *footView;
@end

@implementation DQNewDeviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configView];
    }
    return self;
}

- (void)configView
{
    _iconView = [[UIImageView alloc] initWithImage:ImageNamed(@"CombinedShape")];
    _iconView.frame = CGRectMake(0, 0, 18, 37);
    [self.contentView addSubview:_iconView];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8.5, 18, 20)];
    _numberLabel.font = [UIFont dq_semiboldSystemFontOfSize:14];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    [_iconView addSubview:_numberLabel];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLab.font = [UIFont dq_semiboldSystemFontOfSize:14];
    _nameLab.textColor = [UIColor colorWithHexString:COLOR_BLUE];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLab];
    
    _addressLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _addressLab.font = [UIFont dq_regularSystemFontOfSize:12];
    _addressLab.textColor = [UIColor colorWithHexString:COLOR_TITLE_GRAY];
    _addressLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_addressLab];
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLab.font = [UIFont dq_regularSystemFontOfSize:12];
    _timeLab.textColor = [UIColor colorWithHexString:COLOR_TITLE_GRAY];
    _timeLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_timeLab];
    
    _footView = [[UIView alloc] initWithFrame:CGRectZero];
    _footView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    [self.contentView addSubview:_footView];
}

- (void)configAddDeviceModel:(DeviceModel *)deviceModel
                       count:(NSInteger)count
{
    _numberLabel.text = [NSString stringWithFormat:@"%ld",count];
    NSString *text = [NSString stringWithFormat:@"设备名称：%@",deviceModel.deviceno];
    UIColor *color = [UIColor colorWithHexString:COLOR_BLUE];
    NSMutableAttributedString *attributeString = [AppUtils mString:text addString:deviceModel.deviceno font:[UIFont dq_semiboldSystemFontOfSize:14] changeFont:[UIFont dq_semiboldSystemFontOfSize:12] color:color changeColor:color isAddLine:false lineColor:nil];
    _nameLab.attributedText = attributeString;
    
    _addressLab.text = [NSString stringWithFormat:@"安装地点：%@",deviceModel.installationsite];
    _timeLab.text = deviceModel.handdate;
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _iconView.top = (self.contentView.height-37)/2;
    CGFloat width = [AppUtils textWidthSystemFontString:_nameLab.text height:14 font:_nameLab.font];
    _nameLab.frame = CGRectMake(_iconView.right+26, 16, width, 14);
    
    CGFloat adWidth = [AppUtils textWidthSystemFontString:_addressLab.text height:12 font:_addressLab.font];
    _addressLab.frame = CGRectMake(_nameLab.left, _nameLab.bottom+16, adWidth, 12);
    
    CGFloat timeWidth = [AppUtils textWidthSystemFontString:_timeLab.text height:12 font:_addressLab.font];
    _timeLab.frame = CGRectMake(self.contentView.width-timeWidth-16, 18, timeWidth, 12);
    _footView.frame = CGRectMake(0, self.contentView.height-8, self.contentView.width, 8);
}


@end

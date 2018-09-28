//
//  DQDataCenterListCell.m
//  WebThings
//  设备信息Cell
//  Created by Heidi on 2017/9/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQDataCenterListCell.h"
#import "DeviceTypeModel.h"

@implementation DQDataCenterListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = screenWidth;
        CGFloat height = 90;
        CGFloat x = 16;
        
        _body = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 90)];
        _body.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_body];

        _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 90, screenWidth, 10)];
        _footer.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
        [self.contentView addSubview:_footer];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, width/3.0 - 5, 60)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHexString:COLOR_GREEN];
        _titleLabel.text = @"设备名";
        [_body addSubview:_titleLabel];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, height - 23.5, 49, 19)];
        _stateLabel.font = [UIFont systemFontOfSize:10];
        _stateLabel.layer.cornerRadius = 4.0;
        _stateLabel.layer.masksToBounds = YES;
        _stateLabel.layer.borderWidth = 0.5;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor whiteColor];
        [_body addSubview:_stateLabel];
        x += _titleLabel.frame.size.width + 10;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"设备报告" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHexString:COLOR_BTN_BLUE];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.frame = CGRectMake(x, 30 - 25/2.0, 67, 25);
        [button addTarget:self action:@selector(onDeviceReportClick) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 4.0;
        [_body addSubview:button];
        x += button.frame.size.width + 10;

        _detailLabel = [[UILabel alloc] initWithFrame:
                        CGRectMake(x, 0, width - 32 - x, 60)];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.textColor = [UIColor lightGrayColor];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [_body addSubview:_detailLabel];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(width - 22, 25, 6, 10)];
        icon.image = ImageNamed(@"icon_indictor");
        [_body addSubview:icon];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height - 30, width, 0.5)];
        line.backgroundColor = RGB_Color(239, 239, 239, 1.0);
        [_body addSubview:line];
    }
    
    return self;
}

#pragma mark - Getter & Setter
/// 倒数第一行不显示footer
- (void)setIsLast:(BOOL)isLast {
    _isLast = isLast;
    
    _footer.hidden = isLast;
}

- (void)setDeviceModel:(DeviceTypeModel *)device {
    
    _titleLabel.text = device.deviceno;

    UIColor *color = [UIColor colorWithHexString:device.isWarning ? COLOR_RED : COLOR_GREEN];
    UIColor *bgColor = [UIColor colorWithHexString:device.isWarning ? COLOR_RED_LIGHT : COLOR_GREEN_LIGHT alpha:0.3];
    _stateLabel.text = device.isWarning ?
    [NSString stringWithFormat:@"设备故障：%@", @"设备无法运行"] : @"当前设备无任何异常";
    _stateLabel.layer.borderColor = color.CGColor;
    _stateLabel.backgroundColor = bgColor;
    _stateLabel.textColor = color;
    
    CGSize size = [AppUtils textSizeFromTextString:_stateLabel.text
                                             width:screenWidth - 32
                                            height:20
                                          font:[UIFont systemFontOfSize:10]];
    CGRect rect = _stateLabel.frame;
    rect.size.width = size.width + 10;
    _stateLabel.frame = rect;
    
    _titleLabel.textColor = color;
    NSString *str = [NSString stringWithFormat:@"运行时间：%@H", device.runtime];
    
    _detailLabel.attributedText = [str textDesplaydiffentColor:_detailLabel.textColor
                                            font:[UIFont boldSystemFontOfSize:12]
                                           range:NSMakeRange(str.length - device.runtime.length - 1, device.runtime.length + 1)];
}

#pragma mark - Button clicks
- (void)onDeviceReportClick {
    if (self.deviceReportClicked) {
        self.deviceReportClicked(nil);
    }
}

@end

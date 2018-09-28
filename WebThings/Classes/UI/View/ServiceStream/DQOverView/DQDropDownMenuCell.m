//
//  DQDropDownMenuCell.m
//  WebThings
//
//  Created by Eugene on 2017/9/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQDropDownMenuCell.h"

@interface DQDropDownMenuCell ()

/** 设备状态 为以后可能拓展事件，所以使用button */
@property(nonatomic, strong) UIButton *deviceBtn;

@end
@implementation DQDropDownMenuCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
 
        _deviceBtn = [UIButton new];
        _deviceBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _deviceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_deviceBtn setTitleColor:[UIColor colorWithHexString:@"92C15F"] forState:UIControlStateNormal];
        [_deviceBtn setTitleColor:[UIColor colorWithHexString:@"F60505"] forState:UIControlStateSelected];
        [_deviceBtn setBackgroundImage:[UIImage imageNamed:@"business_device_normal"] forState:UIControlStateNormal];
        [_deviceBtn setBackgroundImage:[UIImage imageNamed:@"business_device_error"] forState:UIControlStateSelected];
        [_deviceBtn addTarget:self action:@selector(deviceTypeAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_deviceBtn];
        
    }
    return self;
}

- (void)setDeviceType:(DeviceTypeModel *)deviceType {
    
    [self.deviceBtn setTitle:[NSObject changeType:deviceType.deviceno] forState:UIControlStateNormal];
    if (deviceType.isWarning == YES) {
        self.deviceBtn.selected = YES;
    } else {
        self.deviceBtn.selected = NO;
        self.deviceBtn.layer.borderColor = [UIColor colorWithRed:0.45 green:0.70 blue:0.16 alpha:1.00].CGColor;
    }
}

- (void)deviceTypeAction {
    
    _typeBlock();
}

@end

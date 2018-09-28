//
//  DQDeviceMaintainWorkerView.m
//  WebThings
//
//  Created by Eugene on 10/11/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQDeviceMaintainWorkerView.h"
#import "DQPhoneManager.h"

@interface DQDeviceMaintainWorkerView ()

@end

@implementation DQDeviceMaintainWorkerView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;

        [self initWorkerView];
    }
    return self;
}

- (void)initWorkerView {
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 15)];
    _nameLabel.text = @"Eugene";
    _nameLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _nameLabel.font = [UIFont dq_semiboldSystemFontOfSize:12];
    _numberLabel.contentMode = UIViewContentModeTopLeft;
    [self addSubview:_nameLabel];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 80, 25)];
    _numberLabel.font = [UIFont dq_semiboldSystemFontOfSize:12];
    [self addSubview:_numberLabel];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.frame = CGRectMake(_numberLabel.right, _numberLabel.top+5, 15, 15);
    [self addSubview:_iconImageView];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestueOnView:)]];
}

- (void)tapGestueOnView:(UITapGestureRecognizer *)tapGesture {
    
    [[DQPhoneManager sharedManager] dq_callUpNumber:_numberLabel.text];
}

@end

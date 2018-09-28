//
//  DQDeviceStateView.m
//  WebThings
//
//  Created by Eugene on 25/09/2017.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQDeviceStateView.h"

@interface DQDeviceStateView ()

/** 提示图片 */
@property (nonatomic, strong) UIImageView *topImageView;
/** 图片和标签的分割线 */
@property (nonatomic, strong) UIView *lineView;
/** 视图底部灰色视图 */
@property (nonatomic, strong) UIView *bottomView;

/** 故障设备 */
@property (nonatomic, strong) UILabel *failureLabel;
/** 正常设备 */
@property (nonatomic, strong) UILabel *normalLabel;
/** 总设备 */
@property (nonatomic, strong) UILabel *totalLabel;

/** 说明故障、正常以及总设备标签 */
@property (nonatomic, strong) UILabel *failDescLabel;
@property (nonatomic, strong) UILabel *norDescLabel;
@property (nonatomic, strong) UILabel *totalDescLabel;

/** 两竖道分割线 */
@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;

@end

@implementation DQDeviceStateView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *topImageView = [[UIImageView alloc] init];
        topImageView.image = [UIImage imageNamed:@"business_dropmenu_alert"];
        topImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topImageView];
        _topImageView = topImageView;
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
        [self addSubview:_lineView];
        
        // 故障
        _failureLabel = [[UILabel alloc] init];
        _failureLabel.text = @"0";
        [self setLabel:_failureLabel textColor:@"F60505" regularFont:NO font:18.0];
        
        _failDescLabel = [[UILabel alloc] init];
        _failDescLabel.text = @"故障设备";
        [self setLabel:_failDescLabel textColor:@"A7A7A7" regularFont:YES font:9.0];
        
        // 正常
        _normalLabel = [[UILabel alloc] init];
        _normalLabel.text = @"0";
        [self setLabel:_normalLabel textColor:@"92C15F" regularFont:NO font:18.0];
        
        _norDescLabel = [[UILabel alloc] init];
        _norDescLabel.text = @"正常设备";
        [self setLabel:_norDescLabel textColor:@"A7A7A7" regularFont:YES font:9.0];
        
        // 总设备
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.text = @"0";
        [self setLabel:_totalLabel textColor:@"040000" regularFont:NO font:18.0];
        
        _totalDescLabel = [[UILabel alloc] init];
        _totalDescLabel.text = @"总设备";
        [self setLabel:_totalDescLabel textColor:@"A7A7A7" regularFont:YES font:9.0];
        
        /** 底部灰色视图*/
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
        [self addSubview:_bottomView];
        
        /** 分割线 */
        _leftLineView = [[UIView alloc] init];
        _leftLineView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
        [self addSubview:_leftLineView];
        
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
        [self addSubview:_rightLineView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _topImageView.frame = CGRectMake(0, 0, self.frame.size.width, 43);

    _lineView.frame = CGRectMake(0, CGRectGetMaxY(_topImageView.frame), self.frame.size.width, 1);
    
    /** 设备标签 */
    _failureLabel.frame = CGRectMake(0, CGRectGetMaxY(_lineView.frame)+5, self.frame.size.width/3-1, 20);

    _normalLabel.frame = CGRectMake(self.frame.size.width/3+1, CGRectGetMinY(_failureLabel.frame), self.frame.size.width/3-1, 20);

    _totalLabel.frame = CGRectMake((self.frame.size.width/3)*2+1,
                                  CGRectGetMinY(_failureLabel.frame)
                                   , self.frame.size.width/3, 20);

    _leftLineView.frame = CGRectMake(self.frame.size.width/3, CGRectGetMinY(_failureLabel.frame)+12, 2, 20);
    _rightLineView.frame = CGRectMake((self.frame.size.width/3)*2, CGRectGetMinY(_failureLabel.frame)+12, 2, 20);
    
    /** 说明标签 */
    _failDescLabel.frame = CGRectMake(0, CGRectGetMaxY(_failureLabel.frame), CGRectGetWidth(_failureLabel.frame), 20);
    
    _norDescLabel.frame = CGRectMake(self.frame.size.width/3, CGRectGetMaxY(_normalLabel.frame), CGRectGetWidth(_normalLabel.frame), 20);

    _totalDescLabel.frame = CGRectMake((self.frame.size.width/3)*2,
                                       CGRectGetMaxY(_totalLabel.frame),
                                       CGRectGetWidth(_totalLabel.frame), 20);
    
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_failDescLabel.frame)+5, self.frame.size.width, 10);
}

- (void)setDeviceModel:(DQDeviceStateModel *)deviceModel {
    _deviceModel = deviceModel;
    
    _failureLabel.text = [NSString stringWithFormat:@"%ld",deviceModel.failureCount];
    _normalLabel.text = [NSString stringWithFormat:@"%ld",deviceModel.normalCount];
    _totalLabel.text = [NSString stringWithFormat:@"%ld",deviceModel.total];
}


- (void)setLabel:(UILabel *)label textColor:(NSString *)hex regularFont:(BOOL)regular font:(CGFloat)value {
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:hex];
    if (regular) {
        label.font = [UIFont dq_regularSystemFontOfSize:value];
    } else {
        label.font = [UIFont dq_semiboldSystemFontOfSize:value];
    }
    [self addSubview:label];
}

@end

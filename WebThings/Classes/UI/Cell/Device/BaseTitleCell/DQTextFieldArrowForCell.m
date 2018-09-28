//
//  DQTextFieldArrowForCell.m
//  WebThings
//
//  Created by winton on 2017/10/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//  右边编辑文字+箭头cell

#import "DQTextFieldArrowForCell.h"

@interface DQTextFieldArrowForCell()
{
    UIImageView *_arrowView;
}
@end

@implementation DQTextFieldArrowForCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _arrowView = [[UIImageView alloc] initWithImage:ImageNamed(@"ic_business_device")];
        _arrowView.frame = CGRectZero;
        [self.contentView addSubview:_arrowView];
        self.rightField.placeholder = @"请选择";
        self.rightField.textAlignment = NSTextAlignmentRight;
        self.rightField.font = [UIFont dq_mediumSystemFontOfSize:16];
        [self.rightField setEnabled:false];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isFullTextField) {
        _arrowView.frame = CGRectMake(0, 0, 0, 0);
        self.rightField.frame = CGRectMake(16, 0, self.contentView.width-32, self.contentView.height);
    } else {
        _arrowView.frame = CGRectMake(self.contentView.width-6-16, (self.contentView.height-10)/2, 6, 10);
        self.rightField.frame = CGRectMake(self.contentView.width-22-220, (self.contentView.height-25)/2, 220, 25);
        self.rightField.left =  _arrowView.left-16-self.rightField.width;
    }
}

- (void)setArrowImageName:(NSString *)arrowImageName {
    _arrowImageName = arrowImageName;
    _arrowView.image = [UIImage imageNamed:arrowImageName];
}
@end

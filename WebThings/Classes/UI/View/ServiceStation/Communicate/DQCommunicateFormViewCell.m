//
//  DQCommunicateFormViewCell.m
//  WebThings
//
//  Created by Eugene on 10/8/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "DQCommunicateFormViewCell.h"

@interface DQCommunicateFormViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation DQCommunicateFormViewCell

#pragma mark - Life Cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 120, kHEIHGT_BILLCELL)];
        _nameLabel.font = [UIFont dq_mediumSystemFontOfSize:14.0];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#BAB9B9"];
        [self.contentView addSubview:_nameLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right, 0, screenWidth-_nameLabel.right-16, kHEIHGT_BILLCELL)];
        _detailLabel.font = [UIFont dq_semiboldSystemFontOfSize:14.0];
        _detailLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailLabel];
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.frame = CGRectMake(_detailLabel.frame.origin.x-25, self.contentView.frame.size.height/2.0-7, 15, 15);
        _iconImageView.hidden = YES;
        [self.contentView addSubview:_iconImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([_dictionary[@"addition"] isEqualToString:@"left"]) {
        
        CGFloat textWidth = [_detailLabel.text textWidthFromTextHeight:15 font:[UIFont dq_semiboldSystemFontOfSize:14.0]];
        _detailLabel.frame = CGRectMake(self.contentView.width-textWidth-16, 0, textWidth, kHEIHGT_BILLCELL);
        _detailLabel.textColor = [UIColor colorWithHexString:COLOR_BLUE];
        
        _iconImageView.hidden = NO;
        _iconImageView.image = [UIImage imageNamed:@"ic_phone_left"];
        _iconImageView.frame = CGRectMake(_detailLabel.left-25, self.contentView.height/2.0-7, 15, 15);
    } else if ([_dictionary[@"addition"] isEqualToString:@"right"]) {
        CGFloat textWidth = [_detailLabel.text textWidthFromTextHeight:15 font:[UIFont dq_semiboldSystemFontOfSize:14.0]];
        _detailLabel.frame = CGRectMake(self.contentView.width-textWidth-16, 0, textWidth, kHEIHGT_BILLCELL);
        _detailLabel.textColor = [UIColor colorWithHexString:COLOR_GREEN];
        
        _iconImageView.hidden = NO;
        _iconImageView.image = [UIImage imageNamed:@"ic_phone_right"];
        _iconImageView.frame = CGRectMake(_detailLabel.left-25, 8, 15, 15);
    } else {
        _iconImageView.hidden = YES;
        _detailLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _detailLabel.frame = CGRectMake(_nameLabel.right, 0, self.contentView.width-_nameLabel.right-16, kHEIHGT_BILLCELL);
    }
}

- (void)setData:(NSDictionary *)dict {
    _dictionary = dict;
    
    _nameLabel.text = dict[@"key"];
    _detailLabel.text = dict[@"value"];
}


@end

//
//  DQServiceInfoCell.m
//  WebThings
//
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceInfoCell.h"

@implementation DQServiceInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 90, 16)];
        _lblTitle.font = [UIFont dq_semiboldSystemFontOfSize:14];
        _lblTitle.textColor = [UIColor colorWithHexString:COLOR_SUBTITLE];
        [self.contentView addSubview:_lblTitle];
        
        _lblDetail = [[UILabel alloc] initWithFrame:CGRectMake(118, 0, kWIDTH_BILLCELL, 16)];
        _lblDetail.font = [UIFont boldSystemFontOfSize:14];
        _lblDetail.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        _lblDetail.numberOfLines = 0;
        _lblDetail.adjustsFontSizeToFitWidth = true;
        _lblDetail.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_lblDetail];
    }
    return self;
}

- (void)setData:(NSDictionary *)dict {
    _lblTitle.text = dict[@"key"];
    
    NSString *value = dict[@"value"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentRight;

    NSAttributedString *string = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName:_lblDetail.font, NSParagraphStyleAttributeName:style}];

    _lblDetail.attributedText = string;
//    _lblDetail.text = value;
    
    CGSize size = [AppUtils textSizeFromTextString:value width:kWIDTH_BILLCELL height:1000 font:_lblDetail.font];

    _lblDetail.frame = CGRectMake(118, 0, kWIDTH_BILLCELL, size.height);
    // 一行则居右对齐，否则居右
//    _lblDetail.textAlignment = size.height > 20.0 ? NSTextAlignmentLeft : NSTextAlignmentRight;
    _lblDetail.textAlignment = NSTextAlignmentRight;
}

@end

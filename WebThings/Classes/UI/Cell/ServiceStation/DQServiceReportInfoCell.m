//
//  DQServiceReportInfoCell.m
//  WebThings
//  报告Cell
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceReportInfoCell.h"

@implementation DQServiceReportInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 270, 19)];
        _lblTitle.font = [UIFont dq_semiboldSystemFontOfSize:14];
        _lblTitle.textColor = [UIColor colorWithHexString:COLOR_BLACK];
        [self.contentView addSubview:_lblTitle];

        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(270, 0, 19, 19)];
        _icon.image = [UIImage imageNamed:@"ic_sure"];
        [self.contentView addSubview:_icon];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _lblTitle.text = title;
}

@end

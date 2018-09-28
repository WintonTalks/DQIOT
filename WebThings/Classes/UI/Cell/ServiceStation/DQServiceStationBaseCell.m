//
//  DQServiceStationBaseCell.m
//  WebThings
//
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQServiceStationBaseCell.h"
#import "UIColor+Hex.h"
#import "DQDefine.h"

@implementation DQServiceStationBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        // 用来看Cell边界
//        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];
//        _line.backgroundColor = [UIColor colorWithHexString:COLOR_LINE];
//        [self.contentView addSubview:_line];
    }
    
    return self;
}

- (void)setData:(DQLogicServiceBaseModel *)data {
    _data = data;
//    _line.frame = CGRectMake(0, data.cellHeight - 1, screenWidth, 1);
    
    if (data.nodeType == DQFlowTypeFix || data.nodeType == DQFlowTypeHeighten || data.nodeType == DQFlowTypeHeighten || data.nodeType == DQFlowTypeBusinessContact) {
        
        [self showVerticalLineView:YES];
    }
}

- (void)showVerticalLineView:(BOOL)isShow {
    _verticalLineView = [[UIView alloc] init];
    _verticalLineView.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];
    _verticalLineView.frame = CGRectMake(30, 0, 3, self.contentView.frame.size.height);
    [self.contentView insertSubview:_verticalLineView atIndex:0];
}

@end

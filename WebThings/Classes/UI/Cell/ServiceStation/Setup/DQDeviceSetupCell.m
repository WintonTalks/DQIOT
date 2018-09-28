//
//  DQDeviceSetupCell.m
//  WebThings
//  安装报告Cell
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQDeviceSetupCell.h"

#import "DQSubSetupModel.h"
#import "DQLogicSetupModel.h"

#import "DQServiceReportView.h"

@implementation DQDeviceSetupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat height = 219;
        
        _reportView = [[DQServiceReportView alloc]
                       initWithFrame:CGRectMake(58, 0, screenWidth - 58 - 18, height)];
        _reportView.titleStr = @"设备安装报告";
        [self.contentView addSubview:_reportView];
    }
    return self;
}

/// 设置数据
- (void)setData:(DQLogicSetupModel *)data {
    
    _reportView.frame = CGRectMake(58, 0, screenWidth - 58 - 18, data.cellHeight - 16);
    [_reportView setData:@[@"现场技术交底", @"安装后检查", @"第三方检测机构三方联合验收"]];
}

@end

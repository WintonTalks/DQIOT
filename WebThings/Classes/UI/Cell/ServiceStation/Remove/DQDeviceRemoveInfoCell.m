//
//  DQDeviceRemoveInfoCell.m
//  WebThings
//  费用清算单
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQDeviceRemoveInfoCell.h"

#import "DQLogicRemoveModel.h"
#import "DQSubRemoveModel.h"
#import "PriceListModel.h"

#import "DQServiceReportView.h"

@implementation DQDeviceRemoveInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _reportView = [[DQServiceReportView alloc]
                       initWithFrame:CGRectMake(58, 0, screenWidth - 58 - 18, 219)];
        _reportView.titleStr = @"费用清算";
        [self.contentView addSubview:_reportView];
    }
    return self;
}

/// 设置数据
- (void)setData:(DQLogicRemoveModel *)data {
    DQSubRemoveModel *model = (DQSubRemoveModel *)data.cellData;
    
    _reportView.frame = CGRectMake(58, 0, screenWidth - 58 - 18, data.cellHeight - 16);
    _reportView.isPassed = data.isFinished;
    [_reportView setData:@[[NSString stringWithFormat:@"进出场费（￥%.0f元）",model.pricelist.intoutprice],
                           [NSString stringWithFormat:@"司机工资（￥%.0f元）",model.pricelist.driverrent],
                           [NSString stringWithFormat:@"租金（￥%.0f元）",model.pricelist.realrent]]];
}

@end

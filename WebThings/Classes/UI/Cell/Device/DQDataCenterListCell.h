//
//  DQDataCenterListCell.h
//  WebThings
//  设备信息Cell
//  Created by Heidi on 2017/9/8.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQDataCenterListCell_h
#define DQDataCenterListCell_h

#import <UIKit/UIKit.h>

@class DeviceTypeModel;

@interface DQDataCenterListCell : UITableViewCell
{
    UILabel *_titleLabel;   // 设备名
    UILabel *_stateLabel;   // 状态
    UILabel *_detailLabel;  // 运行时间
    
    UIView *_body;
    UIView *_footer;
}

@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, copy) DQResultBlock deviceReportClicked;

- (void)setDeviceModel:(DeviceTypeModel *)device;

@end


#endif /* DQDataCenterListCell_h */

//
//  DQDeviceSetupCell.h
//  WebThings
//  安装报告Cell
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQDeviceSetupCell_h
#define DQDeviceSetupCell_h

#import "DQServiceStationBaseCell.h"

@class DQServiceReportView;

@interface DQDeviceSetupCell : DQServiceStationBaseCell
{
    DQServiceReportView *_reportView;
}

@end

#endif /* DQDeviceSetupCell_h */

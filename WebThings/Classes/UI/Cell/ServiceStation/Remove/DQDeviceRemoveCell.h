//
//  DQDeviceRemoveCell.h
//  WebThings
//  停租单
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQDeviceRemoveCell_h
#define DQDeviceRemoveCell_h

#import "DQServiceStationBaseCell.h"

@class DQFormView;
@class DQServiceBillView;

@interface DQDeviceRemoveCell : DQServiceStationBaseCell
{
    UIView *_bodyView;
    DQServiceBillView *_billView;
}

@end

#endif /* DQDeviceRemoveCell_h */

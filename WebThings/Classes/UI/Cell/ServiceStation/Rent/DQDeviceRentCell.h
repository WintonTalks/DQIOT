//
//  DQDeviceRentCell.h
//  WebThings
//
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQDeviceRentCell_h
#define DQDeviceRentCell_h

#import "DQServiceStationBaseCell.h"

@class DQServiceBillView;

@interface DQDeviceRentCell : DQServiceStationBaseCell
{
    UIView *_bodyView;
    DQServiceBillView *_billView;
}

@end

#endif /* DQDeviceRentCell_h */

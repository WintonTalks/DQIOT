//
//  DQRemoveArrearageCell.h
//  WebThings
//  费用未缴清，立即缴费
//  Created by Heidi on 2017/10/24.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQRemoveArrearageCell_h
#define DQRemoveArrearageCell_h

#import "DQServiceStationBaseCell.h"

@class DQFormView;

@interface DQRemoveArrearageCell : DQServiceStationBaseCell
{
    DQFormView *_formView;
    UIButton *_btnPay;
}

@end

#endif /* DQRemoveArrearageCell_h */

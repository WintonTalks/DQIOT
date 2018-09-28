//
//  DQBusContactDoneCell.h
//  WebThings
//  整改完成单
//  Created by Heidi on 2017/10/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQBusContactDoneCell_h
#define DQBusContactDoneCell_h

#import "DQServiceStationBaseCell.h"

#import "DQFormView.h"
@class ServiceImageBrowser;
@class DQServiceBillView;

@interface DQBusContactDoneCell : DQServiceStationBaseCell {
    DQFormView *_formView;
    ServiceImageBrowser *_imgBrowser;
    DQServiceBillView *_billView;
    
    UIView *_bodyView;
}

@end

#endif /* DQBusContactDoneCell_h */

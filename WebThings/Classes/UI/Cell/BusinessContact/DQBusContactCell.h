//
//  DQBusContactCell.h
//  WebThings
//  商函通知单Cell
//  Created by Heidi on 2017/10/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQBusContactCell_h
#define DQBusContactCell_h

#import "DQServiceStationBaseCell.h"
#import "DQDateSegmentView.h"

@class DQFormView;

@interface DQBusContactCell : DQServiceStationBaseCell {
    DQFormView *_formView;
    UIView *_bodyView;
    
    UILabel *_lblTime;
    UILabel *_lblTitle;
    UILabel *_lblContent;
    UIView *_lineBottom;
    
    UIButton *_btnSend;
    
    UIButton *_btnIndictor;
    DQDateSegmentView *_dateView;
}

@end

#endif /* DQBusContactCell_h */

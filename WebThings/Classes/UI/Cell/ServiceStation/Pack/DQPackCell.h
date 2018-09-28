//
//  DQPackCell.h
//  WebThings
//
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQPackCell_h
#define DQPackCell_h

#import "DQServiceStationBaseCell.h"

@class DQFormView;
@class ServiceImageBrowser;

@interface DQPackCell : DQServiceStationBaseCell {
    DQFormView *_formView;
    ServiceImageBrowser *_imgBrowser;
}

@end

#endif /* DQPackCell_h */

//
//  DQSourceBrowerCell.h
//  WebThings
//  资料展示，图片或PDF，Word文档
//  Created by Heidi on 2017/9/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQSourceBrowerCell_h
#define DQSourceBrowerCell_h

#import "DQServiceStationBaseCell.h"

@class DQFormView;
@class ServiceImageBrowser;

@interface DQSourceBrowerCell : DQServiceStationBaseCell {
    DQFormView *_formView;
    ServiceImageBrowser *_imgBrowser;
}

@end

#endif /* DQSourceBrowerCell_h */

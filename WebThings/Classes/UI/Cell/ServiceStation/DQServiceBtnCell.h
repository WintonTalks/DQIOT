//
//  DQServiceBtnCell.h
//  WebThings
//  蓝色按钮行
//  Created by Heidi on 2017/9/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceBtnCell_h
#define DQServiceBtnCell_h

#import <UIKit/UIKit.h>
#import "DQServiceStationBaseCell.h"

@interface DQServiceBtnCell : DQServiceStationBaseCell {
    UIButton *_btnHandle;
    CALayer *_subLayer;
}

@end

#endif /* DQServiceBtnCell_h */

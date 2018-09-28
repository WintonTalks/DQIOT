//
//  DQServiceStationBaseCell.h
//  WebThings
//
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceStationBaseCell_h
#define DQServiceStationBaseCell_h

#import <UIKit/UIKit.h>
#import "DQLogicServiceBaseModel.h"
#import "DQServiceSubNodeModel.h"

typedef void (^DQReloadCellBlock)(BOOL isCellReload); // 刷新cell事件上传block

@interface DQServiceStationBaseCell : UITableViewCell
{
//    UIView *_line;
    UIView *_verticalLineView;
}

@property (nonatomic, copy) DQReloadCellBlock reloadCellBlock;
@property (nonatomic, strong) DQLogicServiceBaseModel *data;

@end

#endif /* DQServiceStationBaseCell_h */

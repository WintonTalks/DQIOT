//
//  DQDCSearchController.h
//  WebThings
//  数据中心搜索
//  Created by Heidi on 2017/9/14.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQDCSearchController_h
#define DQDCSearchController_h

#import "EMI_MaterialSeachBar.h"
@class DQDataCenterView;

#import "EMIBaseViewController.h"

@interface DQDCSearchController : EMIBaseViewController
<EMI_MaterialSeachBarDelegate>
{
    DQDataCenterView *_dcView;
    EMI_MaterialSeachBar *_searchBar;
}

@property (nonatomic, strong) NSArray *dataArray;

@end

#endif /* DQDCSearchController_h */

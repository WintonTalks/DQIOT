//
//  DQScannerDocController.h
//  WebThings
//  扫描文档
//  Created by Heidi on 2017/10/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQScannerDocController_h
#define DQScannerDocController_h

#import "EMIBaseViewController.h"

@class DQLogicServiceBaseModel;

@interface DQScannerDocController : EMIBaseViewController

@property (nonatomic, strong) DQLogicServiceBaseModel *logicModel;

@end

#endif /* DQScannerDocController_h */

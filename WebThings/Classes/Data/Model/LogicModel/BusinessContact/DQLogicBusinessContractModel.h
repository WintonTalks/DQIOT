//
//  DQLogicBusinessContractModel.h
//  WebThings
//  商务往来业务Model
//  Created by Heidi on 2017/10/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQLogicBusinessContractModel_h
#define DQLogicBusinessContractModel_h
#import "DQLogicServiceBaseModel.h"

@interface DQLogicBusinessContractModel : DQLogicServiceBaseModel
<EMIBaseViewControllerDelegate>

// 商务往来ID
@property (nonatomic, copy) NSString *businessID;
@property (nonatomic, strong) UserModel *startUser; //  商函发起人

@property (nonatomic, assign) BOOL canExpend;       // 是否显示箭头

@property (nonatomic, assign) BOOL showConfirm;     // 是否显示确认按钮

+ (DQLogicBusinessContractModel *)dq_buttonLogicWithEnumState:(DQEnumState)state
                                                     flowType:(DQFlowType)flowType;
@end

#endif /* DQLogicBusinessContractModel_h */

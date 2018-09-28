//
//  DQDeviceMaintainFinishFormController.h
//  WebThings
//
//  Created by Eugene on 10/18/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"

@interface DQDeviceMaintainFinishFormController : EMIBaseViewController

/** 维修、维保、加高类型 */
@property (nonatomic, assign) DQEnumState formType;

/** 整改完成单回调
 * block 回传字典，网络请求由发起人操作
 */
@property (nonatomic, copy) DQResultBlock submitRequestBlock;

/** viewController 初始化方法 */
- (instancetype)initWithProjectID:(NSInteger)projectID deviceID:(NSInteger)deviceID orderID:(NSInteger)orderID;

@end

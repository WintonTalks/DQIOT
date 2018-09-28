//
//  DQDeviceMaintainFormViewController.h
//  WebThings
//
//  Created by Eugene on 10/16/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import "EMIBaseViewController.h"

@interface DQDeviceMaintainFormViewController : EMIBaseViewController

@property (nonatomic, assign) DQEnumState formType;

/** viewController 初始化方法 */
- (instancetype)initWithProjectID:(NSInteger)projectID deviceID:(NSInteger)deviceID;

@end

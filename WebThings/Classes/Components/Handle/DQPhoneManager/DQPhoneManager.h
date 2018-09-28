//
//  DQPhoneManager.h
//  WebThings
//
//  Created by Eugene on 10/28/17.
//  Copyright © 2017 陈凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQPhoneManager : NSObject

+ (instancetype)sharedManager;

/** 拨打电话
 * number 电话号
 */
- (void)dq_callUpNumber:(NSString *)number;

@end

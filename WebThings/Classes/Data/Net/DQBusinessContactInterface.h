//
//  DQBusinessContactInterface.h
//  WebThings
//  商务往来相关接口
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQBusinessContactInterface_h
#define DQBusinessContactInterface_h

#import "DQDefine.h"

@interface DQBusinessContactInterface : NSObject

+ (DQBusinessContactInterface *)sharedInstance;

/**
 获取商务往来消息
 @param projectid 项目ID
 @param suc 成功回调
 @param fail 失败回调
 */
- (void)dq_getListWithProjID:(NSNumber *)projectid
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail;

/**
 新增商务往来
 @param projectid 项目ID
 @param date      检查日期
 @param content   内容
 @param suc 成功回调
 @param fail 失败回调
 */
- (void)dq_addBusContProjID:(NSNumber *)projectid
                                  date:(NSString *)date
                               content:(NSString *)content
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail;

/**
 商务往来确认
 @param projectid 项目ID
 @param businessid 商务往来ID
 @param suc 成功回调
 @param fail 失败回调
 */
- (void)dq_busContConfirmWithProjID:(NSNumber *)projectid
                         businessid:(NSString *)businessid
                            success:(DQResultBlock)suc
                           failture:(DQFailureBlock)fail;

/**
 新增整改意见
 @param projectid 项目ID
 @param date      检查日期
 @param content   内容
 @param businessid 商务往来ID
 @param suc 成功回调
 @param fail 失败回调
 */
- (void)dq_addBusContAdviceProjID:(NSNumber *)projectid
                             date:(NSString *)date
                          content:(NSString *)content
                       businessid:(NSString *)businessid
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail;

/**
 整改意见确认
 @param projectid 项目ID
 @param orderid   整改意见单ID
 @param suc 成功回调
 @param fail 失败回调
 */
- (void)dq_busContAdviceConfirmWithProjID:(NSNumber *)projectid
                                  orderid:(NSString *)orderid
                                  success:(DQResultBlock)suc
                                 failture:(DQFailureBlock)fail;

/**
 整改完成单确认
 @param projectid 项目ID
 @param orderid   整改意见单ID
 @param confirm   0-驳回  1-确认
 @param suc 成功回调
 @param fail 失败回调
 */
- (void)dq_busContFinishConfirmWithProjID:(NSNumber *)projectid
                                  orderid:(NSString *)orderid
                                  confirm:(BOOL)confirm
                                  success:(DQResultBlock)suc
                                 failture:(DQFailureBlock)fail;

/**
 新增整改完成单
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_addCompletionNoteFinishOrder:(NSDictionary *)pamara
                                   success:(DQResultBlock)suc
                                  failture:(DQFailureBlock)fail;

@end

#endif /* DQBusinessContactInterface_h */

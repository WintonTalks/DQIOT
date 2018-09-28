//
//  DQBusinessInterface.h
//  WebThings
//  业务中心
//  Created by Heidi on 2017/9/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//
#import "DQDefine.h"
@class AddProjectModel;
@interface DQBusinessInterface : NSObject

+ (DQBusinessInterface *)sharedInstance;

#pragma mark - 获取、新增、修改项目

/**
 * 获取项目列表
 * @param monthStr 年月字符串,传0则读取所有
 */
- (void)dq_getProjectListWithMonth:(NSString *)monthStr
                           success:(DQResultBlock)suc
                          failture:(DQFailureBlock)fail;

/**
 新增项目
 
 @param project dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddProject:(AddProjectModel *)project
                 success:(DQResultBlock)suc
                failture:(DQFailureBlock)fail;

#pragma mark - 工作台
/**
 * 获取工作台的消息
 * @param suc 成功
 * @param fail 失败
 */
- (void)dq_getWorkbenchMessageCountSuccess:(DQResultBlock)suc
                                  failture:(DQFailureBlock)fail;

/**
 * 获取工作台消息通知列表
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getWorkbenchNoticeMessageWithParam:(NSDictionary *)param
                                      success:(DQResultBlock)suc
                                   failture:(DQFailureBlock)fail;



/**
 * 获取数据中心列表／业务中心概览
 * @param monthStr 年月字符串,传0则读取所有
 */
- (void)dq_getDataListWithMonth:(NSString *)monthStr
                        success:(DQResultBlock)suc
                       failture:(DQFailureBlock)fail;

@end

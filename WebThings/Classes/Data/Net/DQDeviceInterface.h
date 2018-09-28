//
//  DQDeviceInterface.h
//  WebThings
//  设备
//  Created by Heidi on 2017/9/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQDeviceInterface_h
#define DQDeviceInterface_h
#import "DeviceProjectModel.h"
#import "DeviceModel.h"

@interface DQDeviceInterface : NSObject

+ (DQDeviceInterface *)sharedInstance;


/**
 添加设备
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceList:(NSArray *)dataArr
                  projectID:(NSInteger)projectID
                    success:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail;

/**
 修改设备

 @param model 设备model
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getModifyDevice:(DeviceModel *)model
                   success:(DQResultBlock)suc
                  failture:(DQFailureBlock)fail;


/** 获取设备列表 **/
- (void)dq_getConfigDeviceList:(NSInteger)projectid
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail;

/** 删除设备 **/
- (void)dq_getDeleteProjectDevice:(NSInteger)projectid
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail;


/**
  设备确认

 @param projectID 设备id
 @param deviceList 数组
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getDeviceFirm:(NSNumber *)projectID
              deviceList:(NSMutableArray *)deviceList
                 success:(DQResultBlock)suc
                failture:(DQFailureBlock)fail;


/**
  获取设备警告
  @param deviceID 设备ID
  @param suc 成功回调
  @param fail 失败回调
 */
- (void)dq_getWarningWithDeviceID:(NSString *)deviceID
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail;

/**
获取日报接口
@param suc 成功回调
@param fail 失败回调
*/
- (void)dq_getDailyWIWithModel:(NSDictionary *)dict
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail;

/**
 标记日报已读
 @param model 用户信息
 @param suc 成功回调
 @param fail 失败回调
 */
- (void)dq_getReadDailyWithModel:(UserModel *)model
                        reportid:(NSInteger)reportid
                         success:(DQResultBlock)suc
                        failture:(DQFailureBlock)fail;

/**
 * 获取品牌型号
 * @param orgID 公司id
 */
- (void)dq_getBrandListWithOrgID:(NSInteger)orgID
                         success:(DQResultBlock)suc
                        failture:(DQFailureBlock)fail;


/**
 司机获取日报项
 @param suc suc
 @param fail fail
 */
- (void)dq_getDailyCheckType:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail;








@end

#endif /* DQDeviceInterface_h */

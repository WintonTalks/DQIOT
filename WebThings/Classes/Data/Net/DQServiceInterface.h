//
//  DQServiceInterface.h
//  WebThings
//  业务站
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceInterface_h
#define DQServiceInterface_h

#import "DQDefine.h"

@interface DQServiceInterface : NSObject

+ (DQServiceInterface *)sharedInstance;

/**
 获取业务站状态
 @param projectid 项目ID
 @param deviceid  设备ID
 @param proDevID  项目设备ID
 @param suc 成功回调
 @param fail 失败回调
 */
- (void)dq_getServiceStationWithProjID:(NSNumber *)projectid
                         deviceID:(NSNumber *)deviceid
                  projectdeviceid:(NSNumber *)proDevID
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail;

/**
 获取业务站服务数据
 @param projectid 项目ID
 @param deviceid  设备ID
 @param proDevID  项目设备ID
 @param typeName  服务流程名
 @param suc 成功回调
 @param fail 失败回调
 */
- (void)dq_getServiceFlowDataWithProjID:(NSNumber *)projectid
                              deviceID:(NSNumber *)deviceid
                       projectdeviceid:(NSNumber *)proDevID
                              flowType:(NSString *)typeName
                               success:(DQResultBlock)suc
                              failture:(DQFailureBlock)fail;

/**
 确认／驳回
 @param projectID 项目ID
 @param deviceID  设备ID
 @param projectdeviceid  项目设备ID
 @param yesorno   通过／驳回
 @param billid    单据id
 @param eventtype 事件类型：无关联  前期沟通项目详情 启租单 附件 司机清单 设备维保 加高
 */
- (void)dq_confirmOrRefuseWithProject:(NSNumber *)projectID
                             deviceID:(NSNumber *)deviceID
                            eventtype:(DQEventType)eventtype
                              yesorno:(BOOL)yesorno
                               billid:(NSNumber *)billid
                      projectdeviceid:(NSNumber *)projectdeviceid
                              success:(DQResultBlock)suc
                             failture:(DQFailureBlock)fail;

#pragma mark - 👇服务流程
/**
 获取设备型号
 
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getBrandDeviceProject:(NSInteger)type
                         success:(DQResultBlock)suc
                        failture:(DQFailureBlock)fail;

/**
 获取承租方 列表
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getNeedOrgList:(NSDictionary *)pamara
                  success:(DQResultBlock)suc
                 failture:(DQFailureBlock)fail;

/**
 修改司机
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getModifyDeriveAPI:(NSDictionary *)pamara
                      success:(DQResultBlock)suc
                     failture:(DQFailureBlock)fail;

#pragma mark - 👇启租单
/**
 启租单 (新增、维修、拆除)
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getRentFormOrder:(NSDictionary *)pamara
               rentFormType:(DQEnumState)formType
                    success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail;

/**
 新增启租单
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddStarRentOrder:(NSDictionary *)pamara
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail;


/**
 修改启租单
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getUpdateStarRentOrder:(NSDictionary *)pamara
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail;

/**
 停租单
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getStopRentOrder:(NSDictionary *)pamara
                    success:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail;

#pragma mark - 👇新增设备维修、维保、加高提交单

/**
 租赁方发起维保提醒⏰
 
 @param params dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_sendMaintainMessage:(NSDictionary *)params
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail;

/**
 新增设备维修、维保、加高等表单
 
 @param params dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_addMaintenceOrderWithType:(DQEnumState)type
                                     params:(NSDictionary *)params
                                   success:(DQResultBlock)suc
                                  failture:(DQFailureBlock)fail;

/**
 新增设备维修
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceRepairOrder:(NSDictionary *)pamara
                           success:(DQResultBlock)suc
                          failture:(DQFailureBlock)fail;

/**
 新增设备加高
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceHightenOrder:(NSDictionary *)pamara
                            success:(DQResultBlock)suc
                           failture:(DQFailureBlock)fail;
/**
 新增设备维保
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceMaintainOrder:(NSDictionary *)pamara
                             success:(DQResultBlock)suc
                            failture:(DQFailureBlock)fail;

#pragma mark - 👇新增设备维修、维保、加高、整改等完成单
/**
 新增设备维修、维保、加高等完成单
 
 @param params dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_addMaintenceFinishOrderWithType:(DQEnumState)type
                                    params:(NSDictionary *)params
                                   success:(DQResultBlock)suc
                                  failture:(DQFailureBlock)fail;

/**
 新增设备维修完成单
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceRepairFinishOrder:(NSDictionary *)pamara
                           success:(DQResultBlock)suc
                          failture:(DQFailureBlock)fail;

/**
 新增设备加高完成单
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceHightenFinishOrder:(NSDictionary *)pamara
                            success:(DQResultBlock)suc
                           failture:(DQFailureBlock)fail;
/**
 新增设备维保完成单
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceMaintainFinishOrder:(NSDictionary *)pamara
                             success:(DQResultBlock)suc
                            failture:(DQFailureBlock)fail;

/**
 获取故障列表
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getFaultdata:(NSDictionary *)pamara
                success:(DQResultBlock)suc
               failture:(DQFailureBlock)fail;

#pragma mark - 👇确认时间发起维保、维修、加高（租赁方 选择工作人员，确认发起表单）
/**
 确认时间发起维保、维修、加高
 
 @param params pamara description
 @param type 维保、维修、加高类型
 */
- (void)dq_getconfirmStartMaintainWithType:(DQEnumState)type
                                    params:(NSDictionary *)params
                                   success:(DQResultBlock)suc
                                  failture:(DQFailureBlock)fail;

/**
 确认时间发起维修
 
 @param pamara dict
 @param suc dd
 @param fail dd
 */
- (void)dq_getConfigStartRepair:(NSDictionary *)pamara
                        success:(DQResultBlock)suc
                       failture:(DQFailureBlock)fail;


/**
 //确认时间发起加高
 
 @param suc sub
 @param fail fai
 */
- (void)dq_getConfigAddHeight:(NSNumber *)projectid
                     deviceid:(NSNumber *)deviceid
                       highid:(NSNumber *)highid
                       people:(NSMutableArray *)people
                      success:(DQResultBlock)suc
                     failture:(DQFailureBlock)fail;



/**
 确认时间发起维保
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getConfigStartMaintain:(NSDictionary *)pamara
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail;


/**
 申请现场技术交底
 */
- (void)dq_getConfigDisclosure:(NSNumber *)projectid
                      deviceid:(NSNumber *)deviceid
               projectdeviceid:(NSNumber *)projectdeviceid
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail;

/**
 上传安装凭证
 
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getUploadDocument:(NSNumber *)projectid
                    deviceid:(NSNumber *)deviceid
                        imgs:(NSMutableArray *)imgs
             projectdeviceid:(NSNumber *)projectdeviceid
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail;


/**
 上传第三方验收凭证
 
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getUploadOtherCheckDocumnet:(NSNumber *)projectid
                              deviceid:(NSNumber *)deviceid
                                  imgs:(NSMutableArray *)imgs
                       projectdeviceid:(NSNumber *)projectdeviceid
                               success:(DQResultBlock)suc
                              failture:(DQFailureBlock)fail;


/**
 加高完成
 
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddHeightFinsh:(NSNumber *)projectid
                    deviceid:(NSNumber *)deviceid
                      highid:(NSNumber *)highid
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail;

/**
 上传报装材料
 
 @param projectid 项目ID
 @param deviceid 设备id
 @param upLoadImgs 图片数组
 @param projectDeviceID 项目设备id
 * @param suc 成功
 * @param fail 失败
 */
- (void)dq_getUploadNoticeInstall:(NSNumber *)projectid
                         deviceid:(NSNumber *)deviceid
                       upLoadImgs:(NSMutableArray *)upLoadImgs
                        projectID:(NSNumber *)projectDeviceID
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail;


/**
 设备锁机
 
 @param projectid 项目id
 @param deviceid 设备id
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getConfigLocked:(NSNumber *)projectid
                  deviceid:(NSNumber *)deviceid
                   success:(DQResultBlock)suc
                  failture:(DQFailureBlock)fail;


/**
 选择工作人员

 @param suc 成功
 @param fail 失败
 */
- (void)dq_getRepairUserList:(NSInteger)projectID
                         suc:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail;

@end

#endif /* DQServiceInterface_h */

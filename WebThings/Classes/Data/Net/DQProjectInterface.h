//
//  DQProjectInterface.h
//  WebThings
//
//  Created by winton on 2017/10/16.
//  Copyright © 2017年 machinsight. All rights reserved.
//  项目管理-API

#import "DQDefine.h"
#import "ServiceevaluateModel.h"

@interface DQProjectInterface : NSObject
+ (DQProjectInterface *)sharedInstance;

/**
 人员列表
 */
- (void)dq_getUserList:(NSInteger)projectid
                   suc:(DQResultBlock)suc
              failture:(DQFailureBlock)fail;

///新增人员
- (void)dq_getAddNewUser:(NSInteger)projectid
                  params:(NSDictionary *)params
                 success:(DQResultBlock)suc
                failture:(DQFailureBlock)fail;

///删除人员
- (void)dq_getDeleteNewUser:(NSInteger)projectid
                   workerid:(NSInteger)workerid
                    success:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail;

//修改人员
- (void)dq_getUpdateUser:(NSInteger)projectid
                  params:(NSDictionary *)params
                 success:(DQResultBlock)suc
                failture:(DQFailureBlock)fail;

//工种类型（新增，原先貌似没有5）
- (void)dq_getWorkType:(DQResultBlock)suc
              failture:(DQFailureBlock)fail;

//人员权限设置
- (void)dq_getPersonPermissions:(NSInteger)projectid
                       workerid:(NSInteger)workerid
                 authpermission:(NSInteger)authpermission
                        success:(DQResultBlock)suc
                       failture:(DQFailureBlock)fail;

/**
 人员资质上传

 @param projectid projectid
 @param workerid work
 @param photoList photoList
 @param suc suc
 @param fail fail
 */
- (void)dq_getPersonQualification:(NSInteger)projectid
                         workerid:(NSInteger)workerid
                      credentials:(NSArray <NSString *> *)photoList
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail;

//资质记录
- (void)dq_getPersonQualificationList:(NSInteger)projectid
                              success:(DQResultBlock)suc
                             failture:(DQFailureBlock)fail;

//人员资质删除
- (void)dq_getDeletePersonQualification:(NSInteger)projectid
                               workerid:(NSInteger)workerid
                                success:(DQResultBlock)suc
                               failture:(DQFailureBlock)fail;

//新增人员培训记录
- (void)dq_getAddTranrecord:(NSDictionary *)dict
                    success:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail;

//人员培训类型列表
- (void)dq_getTrainTypeList:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail;


//人员培训记录
- (void)dq_getUserTranrecord:(NSInteger)projectid
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail;

//人员培训记录删除
- (void)dq_getDeleteTranrecordById:(NSInteger)projectid
                          workerid:(NSInteger)workerid
                           trainid:(NSInteger)trainid
                           success:(DQResultBlock)suc
                          failture:(DQFailureBlock)fail;

//人员考勤查询
- (void)dq_getCheckUserAttendance:(NSInteger)projectid
                         workerid:(NSInteger)workerid
                             date:(NSString *)date
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail;

//考勤记录
- (void)dq_getAttendanceRecord:(NSInteger)projectid
                          date:(NSString *)date
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail;

//评价
- (void)dq_getEvaluateAPI:(NSDictionary *)dict
                  success:(DQResultBlock)suc
                 failture:(DQFailureBlock)fail;

/** 新增人员评价 */
- (void)dq_addEvaluateWithData:(ServiceevaluateModel *)data
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail;

//评价列表
- (void)dq_getEvaluateListAPI:(NSInteger)projectid
                      success:(DQResultBlock)suc
                     failture:(DQFailureBlock)fail;



@end



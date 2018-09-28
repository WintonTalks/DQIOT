//
//  DQDeviceInterface.m
//  WebThings
//  设备
//  Created by Heidi on 2017/9/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQDeviceInterface.h"
#import "DQBaseAPIInterface.h"

#import "DataCenterModel.h"
#import "DailyModel.h"

@implementation DQDeviceInterface

#pragma mark - Singleton
+ (DQDeviceInterface *)sharedInstance {
    static DQDeviceInterface *singleton = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

#pragma mark - API

/**
 添加设备
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceList:(NSArray *)dataArr
                  projectID:(NSInteger)projectID
                    success:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    DeviceProjectModel *addm = [[DeviceProjectModel alloc] init];
    addm.userid = loginUser.userid;
    addm.usertype = loginUser.usertype;
    addm.type = loginUser.type;
    addm.data = dataArr;
    addm.projectid = projectID;
    NSDictionary *params = [addm mj_keyValues];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddDeviceList
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
                 suc(@(1));
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         DQLog(@"%@", error);
     }];
}

/**
 修改设备
 
 @param model 设备model
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getModifyDevice:(DeviceModel *)model
                   success:(DQResultBlock)suc
                  failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *params = @{@"userid" : @(loginUser.userid),
                             @"projectid" : @(model.projectid),
                             @"projectdeviceid" : @(model.projectdeviceid),
                             @"type" : loginUser.type,
                             @"brand" : model.brand,
                             @"modelid" : @(model.modelid),
                             @"price" : @(model.price),
                             @"beforehanddate" : model.beforehanddate,
                             @"high" : @(model.high),
                             @"handdate" : model.handdate,
                             @"address" : model.address,
                             @"starttime" : model.starttime,
                             @"deviceno" : model.deviceno,
                             @"deviceid" : @(model.deviceid)
                             };
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_ModifyDevice
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             fail([NSError errorWithDomain:returnValue.msg code:0 userInfo:nil]);
         }
     } failture:^(NSError *error) {
         fail(error);
         DQLog(@"%@", error);
     }];
}


/** 获取设备列表 **/
- (void)dq_getConfigDeviceList:(NSInteger)projectid
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail
{
    NSDictionary *params = @{@"projectid":@(projectid)};
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_DeviceList
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray <DeviceModel *> *listArr = [DeviceModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             suc(listArr);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         DQLog(@"%@", error);
         fail(error);
     }];
}

/** 删除设备 **/
- (void)dq_getDeleteProjectDevice:(NSInteger)projectid
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *params = @{@"userid" : @(loginUser.userid),
                          @"type" : [NSObject changeType:loginUser.type],
                          @"projectdeviceid" : @(projectid),
                          @"usertype" : [NSObject changeType:loginUser.usertype]};
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_DeleteDevice
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         DQLog(@"%@", error);
         fail(error);
     }];
}


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
                failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    [params setObject:projectID forKey:@"projectid"];
    [params setObject:deviceList forKey:@"projectdeviceid"];

    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_DeviceFirm
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         DQLog(@"%@", error);
     }];
}

/**
 获取设备警告
 @param deviceID 设备ID
 @param suc 成功回调
 @param fail 失败回调
 */
- (void)dq_getWarningWithDeviceID:(NSString *)deviceID
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    if (deviceID.length > 0) {
        [params setObject:[NSObject changeType:deviceID] forKey:@"deviceid"];
    }
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_WarningDevice
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             if ([returnValue.data isKindOfClass:[NSDictionary class]]) {
                 DataCenterModel *model = [DataCenterModel mj_objectWithKeyValues:returnValue.data];
                 suc(model);
             }
         }
         
     } failture:^(NSError *error) {
         DQLog(@"%@", error);
     }];
}

/**
 获取日报接口
 @param suc 成功回调
 @param fail 失败回调
 */
- (void)dq_getDailyWIWithModel:(NSDictionary *)dict
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail
{    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_GetDaily
     parameters:dict
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray *modelList = [DailyModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             suc(modelList);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         DQLog(@"%@", error);
     }];
}

/**
 标记日报已读
 @param model 用户信息
 @param suc 成功回调
 @param fail 失败回调
 */
- (void)dq_getReadDailyWithModel:(UserModel *)model
                        reportid:(NSInteger)reportid
                         success:(DQResultBlock)suc
                        failture:(DQFailureBlock)fail
{
    NSDictionary *params = @{@"userid":@(model.userid), @"type":[NSObject changeType:model.type],@"reportid":@(reportid), @"usertype" : [NSObject changeType:model.usertype]};
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_IsReadDaily
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             
             DQLog(@"%ld",returnValue.success);
         }
     } failture:^(NSError *error) {
         DQLog(@"%@", error);
     }];
}

/**
 * 获取品牌型号
 * @param orgID 公司id
 */
- (void)dq_getBrandListWithOrgID:(NSInteger)orgID
                         success:(DQResultBlock)suc
                        failture:(DQFailureBlock)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    if (orgID > 0) {
        [params setObject:[NSString stringWithFormat:@"%ld", orgID] forKey:@"orgid"];
    }
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_WarningDevice
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             if ([returnValue.data isKindOfClass:[NSDictionary class]]) {
                 DataCenterModel *model = [DataCenterModel mj_objectWithKeyValues:returnValue.data];
                 suc(model);
             }
         }
         
     } failture:^(NSError *error) {
         DQLog(@"%@", error);
     }];
}


/**
 司机获取日报项
 
 @param suc <#suc description#>
 @param fail <#fail description#>
 */
- (void)dq_getDailyCheckType:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    UserModel *loginUser = [AppUtils readUser];
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];    
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_DailyCheckType
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSArray <CheckModel *> *ma = [CheckModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             suc(ma);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         DQLog(@"%@", error);
         fail(error);
     }];
}








@end

//
//  DQProjectInterface.m
//  WebThings
//
//  Created by winton on 2017/10/16.
//  Copyright © 2017年 machinsight. All rights reserved.
//  项目管理-API

#import "DQProjectInterface.h"
#import "DQBaseAPIInterface.h"
#import "DQWorkTypeModel.h"
#import "DriverModel.h"
#import "DQTrainTypeModel.h"
#import "DQTranrecordListModel.h"
#import "DQUserQualificationModel.h"
#import "DQEvaluateListModel.h"
#import "DQAttendanceModel.h"
#import "DQAttendanceListModel.h"

@implementation DQProjectInterface

#pragma mark - Singleton
+ (DQProjectInterface *)sharedInstance {
    static DQProjectInterface *singleton = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

#pragma mark - API

/**
 人员列表
 
 @param suc   suc
 @param fail  fail
 */
- (void)dq_getUserList:(NSInteger)projectid
                   suc:(DQResultBlock)suc
              failture:(DQFailureBlock)fail
{
   UserModel *loginUser = [AppUtils readUser];
   NSDictionary *params = @{@"userid" : @(loginUser.userid),
                           @"type" : [NSObject changeType:loginUser.type],
                           @"usertype" : [NSObject changeType:loginUser.usertype],
                           @"projectid" : @(projectid)
                         };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_GetUsetList
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray *userList = [DriverModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             suc(userList);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

///新增人员
- (void)dq_getAddNewUser:(NSInteger)projectid
                  params:(NSDictionary *)params
                 success:(DQResultBlock)suc
                failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *dict = @{@"userid" : @(loginUser.userid),
                             @"type" : [NSObject changeType:loginUser.type],
                             @"usertype" : [NSObject changeType:loginUser.usertype],
                             @"projectid" : @(projectid),
                             @"data" : params
                             };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddUser
     parameters:dict
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

///删除人员
- (void)dq_getDeleteNewUser:(NSInteger)projectid
                   workerid:(NSInteger)workerid
                    success:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *dict = @{@"userid" : @(loginUser.userid),
                           @"type" : [NSObject changeType:loginUser.type],
                           @"usertype" : [NSObject changeType:loginUser.usertype],
                           @"projectid" : @(projectid),
                           @"workerid" : @(workerid)
                           };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_DeleteUser
     parameters:dict
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//修改人员
- (void)dq_getUpdateUser:(NSInteger)projectid
                  params:(NSDictionary *)params
                 success:(DQResultBlock)suc
                failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *dict = @{@"userid" : @(loginUser.userid),
                           @"type" : [NSObject changeType:loginUser.type],
                           @"usertype" : [NSObject changeType:loginUser.usertype],
                           @"projectid" : @(projectid),
                           @"data" : params
                           };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_ModifyUser
     parameters:dict
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//工种类型（新增，原先貌似没有5）
- (void)dq_getWorkType:(DQResultBlock)suc
              failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *dict = @{@"userid" : @(loginUser.userid),
                           @"type" : [NSObject changeType:loginUser.type],
                           @"usertype" : [NSObject changeType:loginUser.usertype],
                           };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_GetWorkType
     parameters:dict
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray *workListArr = [DQWorkTypeModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             suc(workListArr);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//人员权限设置
- (void)dq_getPersonPermissions:(NSInteger)projectid
                       workerid:(NSInteger)workerid
                 authpermission:(NSInteger)authpermission
                        success:(DQResultBlock)suc
                       failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *dict = @{@"userid" : @(loginUser.userid),
                           @"type" : [NSObject changeType:loginUser.type],
                           @"usertype" : [NSObject changeType:loginUser.usertype],
                           @"projectid" : @(projectid),
                           @"workerid" : @(workerid),
                           @"authpermission" : @(authpermission)
                           };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_PersonPermissions
     parameters:dict
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

/**
 人员资质上传
 
 @param projectid projectid
 @param workerid work
 @param photoList ”证件照片地址,’,’逗号隔开”
 @param suc suc
 @param fail fail
 */
- (void)dq_getPersonQualification:(NSInteger)projectid
                         workerid:(NSInteger)workerid
                      credentials:(NSArray <NSString *>*)photoList
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail
{
    NSString *imageUrls = [photoList componentsJoinedByString:@","];
    //imageUrls = [imageUrls removeLastCharacter:@","];

    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *dict = @{@"userid" : @(loginUser.userid),
                           @"type" : [NSObject changeType:loginUser.type],
                           @"usertype" : [NSObject changeType:loginUser.usertype],
                           @"projectid" : @(projectid),
                           @"workerid" : @(workerid),
                           @"credentials" : imageUrls
                           };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_PersonQualification
     parameters:dict
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//资质记录
- (void)dq_getPersonQualificationList:(NSInteger)projectid
                              success:(DQResultBlock)suc
                             failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *dict = @{@"userid" : @(loginUser.userid),
                           @"type" : [NSObject changeType:loginUser.type],
                           @"usertype" : [NSObject changeType:loginUser.usertype],
                           @"projectid" : @(projectid)
                           };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_GetQualificationList
     parameters:dict
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray *listArr = [DQUserQualificationModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             suc(listArr);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//人员资质删除
- (void)dq_getDeletePersonQualification:(NSInteger)projectid
                               workerid:(NSInteger)workerid
                                success:(DQResultBlock)suc
                               failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *dict = @{@"userid" : @(loginUser.userid),
                           @"type" : [NSObject changeType:loginUser.type],
                           @"usertype" : [NSObject changeType:loginUser.usertype],
                           @"projectid" : @(projectid),
                           @"workerid" : @(workerid)
                           };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_DeleteQualification
     parameters:dict
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             
             
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//新增人员培训记录
- (void)dq_getAddTranrecord:(NSDictionary *)dict
                    success:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *pamars = @{@"userid" : @(loginUser.userid),
                           @"type" : [NSObject changeType:loginUser.type],
                           @"usertype" : [NSObject changeType:loginUser.usertype],
                           @"data" : dict,
                           };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddTranrecord
     parameters:pamars
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//人员培训类型列表
- (void)dq_getTrainTypeList:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *pamars = @{@"userid" : @(loginUser.userid),
                             @"type" : [NSObject changeType:loginUser.type],
                             @"usertype" : [NSObject changeType:loginUser.usertype],
                             };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_GetTrainType
     parameters:pamars
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray *dataList = [DQTrainTypeModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             suc(dataList);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//人员培训记录
- (void)dq_getUserTranrecord:(NSInteger)projectid
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *pamars = @{@"userid" : @(loginUser.userid),
                             @"type" : [NSObject changeType:loginUser.type],
                             @"usertype" : [NSObject changeType:loginUser.usertype],
                             @"projectid" : @(projectid)
                             };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_GetUserTranrecord
     parameters:pamars
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray *listArr = [DQTranrecordListModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             suc(listArr);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//人员培训记录删除
- (void)dq_getDeleteTranrecordById:(NSInteger)projectid
                          workerid:(NSInteger)workerid
                           trainid:(NSInteger)trainid
                           success:(DQResultBlock)suc
                          failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *pamars = @{@"userid" : @(loginUser.userid),
                             @"type" : [NSObject changeType:loginUser.type],
                             @"usertype" : [NSObject changeType:loginUser.usertype],
                             @"projectid" : @(projectid),
                             @"workerid" : @(workerid),
                             @"trainid" : @(trainid)
                             };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_DeleteTranrecord
     parameters:pamars
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//人员考勤查询
- (void)dq_getCheckUserAttendance:(NSInteger)projectid
                         workerid:(NSInteger)workerid
                             date:(NSString *)date
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *pamars = @{@"userid" : @(loginUser.userid),
                             @"type" : [NSObject changeType:loginUser.type],
                             @"usertype" : [NSObject changeType:loginUser.usertype],
                             @"projectid" : @(projectid),
                             @"workerid" : @(workerid),
                             @"date" : date
                             };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_GetCheckUserList
     parameters:pamars
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray *attendList = [DQAttendanceModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             suc(attendList);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//考勤记录
- (void)dq_getAttendanceRecord:(NSInteger)projectid
                          date:(NSString *)date
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *pamars = @{@"userid" : @(loginUser.userid),
                             @"type" : [NSObject changeType:loginUser.type],
                             @"usertype" : [NSObject changeType:loginUser.usertype],
                             @"projectid" : @(projectid),
                             @"date" : date
                             };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_GetAttendanceRecord
     parameters:pamars
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray *attendList = [DQAttendanceListModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             suc(attendList);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//评价
- (void)dq_getEvaluateAPI:(NSDictionary *)dict
                  success:(DQResultBlock)suc
                 failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *pamars = @{@"userid" : @(loginUser.userid),
                             @"type" : [NSObject changeType:loginUser.type],
                             @"usertype" : [NSObject changeType:loginUser.usertype],
                             @"data" : dict,
                             };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddEvaluate
     parameters:pamars
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

/** 新增人员评价 */
- (void)dq_addEvaluateWithData:(ServiceevaluateModel *)data
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *pamars = @{@"userid" : @(loginUser.userid),
                             @"type" : [NSObject changeType:loginUser.type],
                             @"usertype" : [NSObject changeType:loginUser.usertype],
                             @"data" : [data dq_apiParams],
                             };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddEvaluate
     parameters:pamars
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             fail([NSError errorWithDomain:returnValue.msg code:0 userInfo:nil]);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//评价列表
- (void)dq_getEvaluateListAPI:(NSInteger)projectid
                      success:(DQResultBlock)suc
                     failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *pamars = @{@"userid" : @(loginUser.userid),
                             @"type" : [NSObject changeType:loginUser.type],
                             @"usertype" : [NSObject changeType:loginUser.usertype],
                             @"projectid" : @(projectid),
                             @"evaluatetype" : @"2"
                             };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_GetEvaluate
     parameters:pamars
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray *list = [DQEvaluateListModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             suc(list);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}




@end

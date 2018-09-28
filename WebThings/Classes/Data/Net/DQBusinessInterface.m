//
//  DQBusinessInterface.m
//  WebThings
//  业务中心
//  Created by Heidi on 2017/9/5.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQBusinessInterface.h"
#import "DQBaseAPIInterface.h"
#import "AddProjectModel.h"

#import "DWMsgModel.h"

@implementation DQBusinessInterface

#pragma mark - Sing
+ (DQBusinessInterface *)sharedInstance {
    static DQBusinessInterface *singleton = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

#pragma mark - API
// 获取项目列表
- (void)dq_getProjectListWithMonth:(NSString *)monthStr
                           success:(DQResultBlock)suc
                          failture:(DQFailureBlock)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    if (monthStr.length > 0) {
        [params setObject:[NSObject changeType:monthStr] forKey:@"cdate"];
    }
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_ProjectList
     parameters:params
     progress:^(CGFloat percent) {
        
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             if ([returnValue.data isKindOfClass:[NSArray class]]) {
                 NSArray *array = [AddProjectModel mj_objectArrayWithKeyValuesArray:returnValue.data];
                 suc(array);
             }
         }
         
     } failture:^(NSError *error) {
         fail(error);
     }];
}


/**
 新增项目
 
 @param project model
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddProject:(AddProjectModel *)project
                 success:(DQResultBlock)suc
                failture:(DQFailureBlock)fail
{
    NSMutableArray *deviceList = [NSMutableArray new];
    for (DeviceTypeModel *typeModel in project.detail) {
        NSDictionary *dict = @{@"modelid" : @(typeModel.modelid),
                               @"model" : typeModel.model,
                               @"count" : @(typeModel.count),
                               @"brand" : typeModel.brand};
        [deviceList safeAddObject:dict];
    }
    NSDictionary *params = @{@"contractor" : project.contractor,
                             @"detail" : deviceList,
                             @"devicenum" : @(project.devicenum),
                             @"driverrent" : @(project.driverrent),
                             @"indate" : project.indate,
                             @"installcount" : @(project.installcount),
                             @"intoutprice" : @(project.intoutprice),
                             @"isfinish" : @(project.isfinish),
                             @"needorgid" : @(project.needorgid),
                             @"no" : project.no,
                             @"outdate" : project.outdate,
                             @"pmid" : @(project.pmid),
                             @"projectaddress" : project.projectaddress,
                             @"projectid" : @(project.projectid),
                             @"projectname" : project.projectname,
                             @"provideorgid" : @(project.provideorgid),
                             @"realdriverrent" : @(project.realdriverrent),
                             @"realrent" : @(project.realrent),
                             @"rent" : @(project.rent),
                             @"supervisor" : project.supervisor,
                             @"totalprice" : @(project.totalprice),
                             @"type" : project.type,
                             @"userid" : @(project.userid),
                             @"usertype" : project.usertype};

    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddProject
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSInteger projectid = [[returnValue.data objectForKey:@"projectid"] integerValue];
             suc(@(projectid));
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

//- (void)dq_getModifyProject:(AddProjectModel *)project
//                    success:(DQResultBlock)suc
//                   failture:(DQFailureBlock)fail
//{
//  //  NSDictionary *params = [project mj_keyValues];
////    NSMutableDictionary *detail = [project.detail mj_keyValues];
//    NSDictionary *params = @{@"contractor" : project.contractor,
//                             @"detail" : project.detail,
//                             @"devicenum" : @(project.devicenum),
//                             @"driverrent" : @(project.driverrent),
//                             @"indate" : project.indate,
//                             @"installcount" : @(project.installcount),
//                             @"intoutprice" : @(project.intoutprice),
//                             @"isfinish" : @(project.isfinish),
//                             @"needorgid" : @(project.needorgid),
//                             @"no" : project.no,
//                             @"outdate" : project.outdate,
//                             @"pmid" : @(project.pmid),
//                             @"projectaddress" : project.projectaddress,
//                             @"projectid" : @(project.projectid),
//                             @"projectname" : project.projectname,
//                             @"provideorgid" : @(project.provideorgid),
//                             @"realdriverrent" : @(project.realdriverrent),
//                             @"realrent" : @(project.realrent),
//                             @"rent" : @(project.rent),
//                             @"supervisor" : project.supervisor,
//                             @"totalprice" : @(project.totalprice),
//                             @"type" : project.type,
//                             @"userid" : @(project.userid),
//                             @"usertype" : project.usertype};
//    [[DQBaseAPIInterface sharedInstance]
//     dq_postRequestWithUrl:API_ModifyProject
//     parameters:params
//     progress:^(CGFloat percent) {
//
//     } success:^(DQResultModel *returnValue) {
//         if ([returnValue isRequestSuccess]) {
//             suc(@(1));
//         } else {
//             suc(nil);
//         }
//     } failture:^(NSError *error) {
//         fail(error);
//     }];
//}

/** 获取工作台的消息 */
- (void)dq_getWorkbenchMessageCountSuccess:(DQResultBlock)suc failture:(DQFailureBlock)fail {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    UserModel *loginUser = [AppUtils readUser];
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_ObtainNumber
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             if ([returnValue.data isKindOfClass:[NSArray class]]) {
                 suc(returnValue);
             }
         }
         
     } failture:^(NSError *error) {
         fail(error);
     }];
}

- (void)dq_getWorkbenchNoticeMessageWithParam:(NSDictionary *)param
                                      success:(DQResultBlock)suc
                                   failture:(DQFailureBlock)fail {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params addEntriesFromDictionary:[NSObject changeType:param]];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_GetMsg
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             if ([returnValue.data isKindOfClass:[NSArray class]]) {
                 NSArray *array = [DWMsgModel mj_objectArrayWithKeyValuesArray:returnValue.data];
                 suc(array);
             }
         }
         
     } failture:^(NSError *error) {
         fail(error);
     }];
}

/**
 * 获取数据中心列表／业务中心概览
 * @param monthStr 年月字符串,传0则读取所有
 */
- (void)dq_getDataListWithMonth:(NSString *)monthStr
                        success:(DQResultBlock)suc
                       failture:(DQFailureBlock)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    if (monthStr.length > 0) {
        [params setObject:[NSObject changeType:monthStr] forKey:@"cdate"];
    }
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];

    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_DataCenter
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             if ([returnValue.data isKindOfClass:[NSArray class]]) {
                 NSArray *array = [AddProjectModel mj_objectArrayWithKeyValuesArray:returnValue.data];

                 suc(array);
             }
         }
         
     } failture:^(NSError *error) {
         fail(error);
     }];
}

 
@end

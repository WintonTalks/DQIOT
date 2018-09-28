//
//  DQBusinessContactInterface.m
//  WebThings
//  商务往来相关接口
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQBusinessContactInterface.h"
#import "DQBaseAPIInterface.h"
#import "AppUtils.h"

#import "DQSubBusinessContractModel.h"
#import "DQBusinessContractModel.h"
#import "DQLogicBusinessContractModel.h"
#import "DQBusContDetailModel.h"

@implementation DQBusinessContactInterface

#pragma mark - Singleton
+ (DQBusinessContactInterface *)sharedInstance {
    static DQBusinessContactInterface *singleton = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

#pragma mark -
- (NSDictionary *)paramsWithParam:(NSDictionary *)dict {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    UserModel *loginUser = [AppUtils readUser];
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    
    [params addEntriesFromDictionary:dict];
    
    return params;
}

#pragma mark - API
/// 获取商务往来消息
- (void)dq_getListWithProjID:(NSNumber *)projectid
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail {
    NSDictionary *params = [self paramsWithParam:
                            @{@"projectid" : [NSString stringWithFormat:@"%@", projectid]}];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_BusinessContactList
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         
         if ([returnValue isRequestSuccess]) {
             
             UserModel *loginUser = [AppUtils readUser];
             
             NSMutableArray *logicArray = [NSMutableArray arrayWithCapacity:0];
             NSArray *apiResultArray = [DQBusinessContractModel mj_objectArrayWithKeyValuesArray:returnValue.data];

             for (int i = 0; i < [apiResultArray count]; i ++) {  // 一个商函来往

                 BOOL isGoing = NO;
                 NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:0];
                 DQBusinessContractModel *business = apiResultArray[i];
                 UserModel *startUser = [[UserModel alloc] init];
                 startUser.userid = [business.userid integerValue];
                 startUser.name = business.name;
//                 startUser.type = business.type;    // TODO:承租方／租赁方
                 
                 for (int j = 0; j < [business.detail count]; j ++) {
                     
                     DQBusContDetailModel *detail = business.detail[j];
                     DQLogicBusinessContractModel *logicModel = [[DQLogicBusinessContractModel alloc] init];
                     logicModel.businessID = business.businessID;
                     logicModel.nodeName = @"商务往来";
                     logicModel.nodeType = DQFlowTypeBusinessContact;
                     logicModel.projectid = [projectid integerValue];
                     logicModel.startUser = startUser;  // 发起人
                     
                     DQSubBusinessContractModel *busDetail = [[DQSubBusinessContractModel alloc] init];
                     busDetail.title = detail.enumstatedesc;
                     busDetail.enumstateid = detail.enumstateid;
                     busDetail.content = detail.content;
                     busDetail.sendheadimg = detail.headimg;
                     busDetail.sendname = detail.name;
                     busDetail.senduserid = detail.userid;
                     busDetail.sendtime = detail.ctime;
                     busDetail.checkDate = detail.date;
                     
                     busDetail.expend = detail.data.expend;
                     busDetail.reuslt = detail.data.result;
                     busDetail.desc = detail.data.des;
                     busDetail.telephone = detail.data.dn;
                     busDetail.startDate = detail.data.start;
                     busDetail.endDate = detail.data.end;
                     busDetail.works = detail.data.workers;
                     busDetail.imgLists = [detail.data.imgs componentsSeparatedByString:@","];
                     
                     busDetail.linkid = [detail.data.busID integerValue];  // 整改完成单ID
                     
                     logicModel.cellData = busDetail;
                     logicModel.isLast = j == [business.detail count] - 1;
                     [modelArray addObject:logicModel];

                     // 商务往来已确认，增加“商务往来中”，发起方增加整改意见
                     if (detail.enumstateid == DQEnumStateBusContactConfirmed) {
                         if (!isGoing) {    // 保证商务往来状态的唯一性
                             DQSubBusinessContractModel *subGo = [[DQSubBusinessContractModel alloc] init];
                             subGo.enumstateid = DQEnumStateBusContGoing;
                             subGo.isButtonCell = YES;
                             
                             DQLogicBusinessContractModel *goLogic = [[DQLogicBusinessContractModel alloc] init];
                             goLogic.businessID = business.businessID;
                             goLogic.nodeName = @"商务往来";
                             goLogic.nodeType = DQFlowTypeBusinessContact;
                             goLogic.projectid = [projectid integerValue];
                             goLogic.cellData = subGo;
                             [modelArray addObject:goLogic];
                         }
                         
                         if (logicModel.isLast && loginUser.userid == [business.userid integerValue]) {   // 添加整改意见
                             DQSubBusinessContractModel *modelBtn = [[DQSubBusinessContractModel alloc] init];
                             modelBtn.enumstateid = DQEnumStateBusConAdviceAdd;
                             modelBtn.isButtonCell = YES;
                             DQLogicBusinessContractModel *logicModelBtn = [[DQLogicBusinessContractModel alloc] init];
                             logicModelBtn.businessID = business.businessID;
                             logicModelBtn.cellData = modelBtn;
                             logicModelBtn.projectid = [projectid integerValue];
                             logicModelBtn.nodeName = @"商务往来";
                             logicModelBtn.nodeType = DQFlowTypeBusinessContact;
                             [modelArray addObject:logicModelBtn];
                         }
                     }
                     // 整改意见已确认或整改完成单已驳回，增加“填写整改完成单”，发起方的另一方增加整改意见
                     else if ((detail.enumstateid == DQEnumStateBusContactAdviceComfirmed ||
                               detail.enumstateid == DQEnumStateBusContactFinishRefuse) &&
                              loginUser.userid != [business.userid integerValue]
                              && logicModel.isLast) {
                         DQSubBusinessContractModel *modelBtn = [[DQSubBusinessContractModel alloc] init];
                         modelBtn.enumstateid = DQEnumStateBusConFinishAdd;
                         modelBtn.isButtonCell = YES;
                         
                         DQLogicBusinessContractModel *logicModelBtn = [[DQLogicBusinessContractModel alloc] init];
                         logicModelBtn.businessID = business.businessID;
                         logicModelBtn.cellData = modelBtn;
                         logicModelBtn.projectid = [projectid integerValue];
                         logicModelBtn.nodeName = @"商务往来";
                         logicModelBtn.nodeType = DQFlowTypeBusinessContact;
                         [modelArray addObject:logicModelBtn];
                     }
                 }
                 [logicArray addObject:modelArray];
             }
             suc(logicArray);
         }
         
     } failture:^(NSError *error) {
         DQLog(@"dq_getListWithProjID请求错误：%@", error);
     }];
}

/// 新增商务往来
- (void)dq_addBusContProjID:(NSNumber *)projectid
                       date:(NSString *)date
                    content:(NSString *)content
                    success:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail {
    
    NSDictionary *params = [self paramsWithParam:
  @{@"projectid" : [NSString stringWithFormat:@"%@", projectid],
    @"content" : [NSObject changeType:[content dq_filterEmoji]],
    @"date" : [NSObject changeType:date]}];
//    NSString *json = [params mj_JSONString];

    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_BusinessContactAdd
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@"1");
         } else {
             fail([NSError errorWithDomain:returnValue.msg code:-1 userInfo:nil]);
         }
         
     } failture:^(NSError *error) {
         fail([NSError errorWithDomain:STRING_REQUESTFAIL code:-1 userInfo:nil]);
         DQLog(@"dq_getServiceStationWithProjID请求错误：%@", error);
     }];
}

 /// 商务往来确认
- (void)dq_busContConfirmWithProjID:(NSNumber *)projectid
                         businessid:(NSString *)businessid
                            success:(DQResultBlock)suc
                           failture:(DQFailureBlock)fail {
    
    NSDictionary *params = [self paramsWithParam:
                            @{@"projectid" : [NSString stringWithFormat:@"%@", projectid],
                              @"businessid" : [NSString stringWithFormat:@"%@", businessid]}];

    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_BusiContConfirm
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@"1");
         } else {
             fail([NSError errorWithDomain:returnValue.msg code:-1 userInfo:nil]);
         }
         
     } failture:^(NSError *error) {
         DQLog(@"dq_getServiceFlowDataWithProjID请求错误：%@", error);
     }];
}

/// 新增整改意见
- (void)dq_addBusContAdviceProjID:(NSNumber *)projectid
                       date:(NSString *)date
                    content:(NSString *)content
                 businessid:(NSString *)businessid
                    success:(DQResultBlock)suc
                   failture:(DQFailureBlock)fail {
    
    NSDictionary *params = [self paramsWithParam:
                            @{@"projectid" : [NSString stringWithFormat:@"%@", projectid],
                              @"businessid" : [NSString stringWithFormat:@"%@", businessid],
                              @"content" : [content dq_filterEmoji],
                              @"date" : date}];
//    NSString *json = [params mj_JSONString];

    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_BusiContAdviceAdd
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@"1");
         } else {
             fail([NSError errorWithDomain:returnValue.msg code:-1 userInfo:nil]);
         }
         
     } failture:^(NSError *error) {
         DQLog(@"dq_getServiceFlowDataWithProjID请求错误：%@", error);
     }];
}

// 整改意见确认
- (void)dq_busContAdviceConfirmWithProjID:(NSNumber *)projectid
                                  orderid:(NSString *)orderid
                                  success:(DQResultBlock)suc
                                 failture:(DQFailureBlock)fail {
    NSDictionary *params = [self paramsWithParam:
                            @{@"projectid" : [NSString stringWithFormat:@"%@", projectid],
                              @"orderid" : [NSString stringWithFormat:@"%@", orderid]}];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_BusiContAdviceConfirm
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@"1");
         } else {
             fail([NSError errorWithDomain:returnValue.msg code:-1 userInfo:nil]);
         }
         
     } failture:^(NSError *error) {
         DQLog(@"dq_getServiceFlowDataWithProjID请求错误：%@", error);
     }];
}

// 整改完成单确认
- (void)dq_busContFinishConfirmWithProjID:(NSNumber *)projectid
                                  orderid:(NSString *)orderid
                                  confirm:(BOOL)confirm
                                  success:(DQResultBlock)suc
                                 failture:(DQFailureBlock)fail {
    NSDictionary *params = [self paramsWithParam:
                            @{@"projectid" : [NSString stringWithFormat:@"%@", projectid],
                              @"orderid" : [NSString stringWithFormat:@"%@", orderid],
                              @"comfirm" : confirm ? @"通过" : @"驳回"
                              }];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_BusiContFinishConfirm
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@"1");
         } else {
             fail([NSError errorWithDomain:returnValue.msg code:-1 userInfo:nil]);
         }
         
     } failture:^(NSError *error) {
         DQLog(@"dq_busContFinishConfirmWithProjID请求错误：%@", error);
     }];
}

/**
 新增整改完成单
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_addCompletionNoteFinishOrder:(NSDictionary *)pamara
                                   success:(DQResultBlock)suc
                                  failture:(DQFailureBlock)fail
{
//    NSString *json = [pamara mj_JSONString];
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_BusiContFinishAdd
     parameters:pamara
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@(1));
         } else {
             fail([NSError errorWithDomain:STRING_REQUESTFAIL code:0 userInfo:nil]);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

@end

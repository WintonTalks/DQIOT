//
//  DQServiceInterface.m
//  WebThings
//
//  Created by Heidi on 2017/9/25.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "DQServiceInterface.h"

#import "DQBaseAPIInterface.h"
#import "NSObject+NSNullExpande.h"
#import "AppUtils.h"

#import "DQServiceNodeModel.h"
#import "UserModel.h"

#import "DQSubCommunicateModel.h"
#import "DQSubPackModel.h"
#import "DQSubSetupModel.h"
#import "DQSubRentModel.h"
#import "DQSubRemoveModel.h"
#import "DQSubEvaluateModel.h"
#import "DQSubMaintainModel.h"
#import "DQSubFixModel.h"

#import "DQLogicServiceBaseModel.h"
#import "DQLogicMaintainModel.h"

#import "DQAddProjectModel.h"
#import "FaultDataModel.h"

@implementation DQServiceInterface

#pragma mark - 👇Singleton
+ (DQServiceInterface *)sharedInstance {
    static DQServiceInterface *singleton = nil;
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

- (NSString *)eventWithType:(DQEventType)type {
    NSArray *array = @[@"无关联", @"前期沟通_进场沟通单",
                       @"设备报装_报装资料", @"设备安装_现场技术交底",
                       @"设备安装_安装凭证", @"设备安装_第三方验收凭证",
                       @"设备启租_启租单", @"司机确认",
                       @"设备维保", @"设备维修",
                       @"设备加高", @"拆除设备"];
    NSString *event = @"";
    if ([array count] > type) {
        event = array[type];
    }
    return event;
}

#pragma mark - 👇API
/// 获取业务站状态
- (void)dq_getServiceStationWithProjID:(NSNumber *)projectid
                         deviceID:(NSNumber *)deviceid
                  projectdeviceid:(NSNumber *)proDevID
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([deviceid integerValue] > 0) {
        [params setObject:[NSString stringWithFormat:@"%@", deviceid] forKey:@"deviceid"];
    }
    if ([projectid integerValue] > 0) {
        [params setObject:[NSString stringWithFormat:@"%@", projectid] forKey:@"projectid"];
    }
    if ([proDevID integerValue] > 0) {
        [params setObject:[NSString stringWithFormat:@"%@", proDevID] forKey:@"projectdeviceid"];
    }
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_ServiceStation
     parameters:[self paramsWithParam:params]
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             if ([returnValue.data isKindOfClass:[NSArray class]]) {
                 NSArray *array = [DQServiceNodeModel mj_objectArrayWithKeyValuesArray:returnValue.data];
                 if ([array isKindOfClass:[NSArray class]]) {
                     suc(array);
                 }
             }
         }
         
     } failture:^(NSError *error) {
         DQLog(@"dq_getServiceStationWithProjID请求错误：%@", error);
     }];
}

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
                               failture:(DQFailureBlock)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    if ([deviceid integerValue] > 0) {
        [params setObject:[NSString stringWithFormat:@"%@", deviceid] forKey:@"deviceid"];
    }
    if ([projectid integerValue] > 0) {
        [params setObject:[NSString stringWithFormat:@"%@", projectid] forKey:@"projectid"];
    }
    if ([proDevID integerValue] > 0) {
        [params setObject:[NSString stringWithFormat:@"%@", proDevID] forKey:@"projectdeviceid"];
    }
    if (typeName.length > 0) {
        [params setObject:[NSObject changeType:typeName] forKey:@"flowtype"];
    }
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_ServiceFlow
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             if ([returnValue.list isKindOfClass:[NSArray class]]) {
                 NSArray *handleArray = [self handleDataWithArray:returnValue.list typeName:typeName];
                 suc(handleArray);
             }
         }
         
     } failture:^(NSError *error) {
         fail(error);
         DQLog(@"dq_getServiceFlowDataWithProjID请求错误：%@", error);
     }];
}

#pragma mark - 👇封装返回数据
- (NSArray *)handleDataWithArray:(NSArray *)resultArray typeName:(NSString *)typeName {
    // 根据typeName返回相应的Model
    NSString *name = [self getModelNameWithTypeName:typeName];
    DQServiceSubNodeModel *dataModel = (DQServiceSubNodeModel *)NSClassFromString(name);
    NSMutableArray<DQServiceSubNodeModel *> *array = [NSMutableArray arrayWithArray:
                                                      [[dataModel class] mj_objectArrayWithKeyValuesArray:resultArray]];
    
    UserModel *user = [AppUtils readUser];
    DQFlowType index = [AppUtils nodeIndexWithTypeName:typeName];
    DQServiceSubNodeModel *last = nil;
    if ([array count] > 0) {
        last = [NSObject changeType:[array lastObject]];
    } else {
        last = [[DQServiceSubNodeModel alloc] init];
    }
    last.isLast = YES;  // 不可少，用来传到logicModel判断是否显示驳回／确认的条件之一

    BOOL needAddBtn = NO;
    BOOL needReportCell = NO;
    NSInteger enumState = 0;
    BOOL isFirst = NO;      // 是否将按钮加在最前面，否则加在最后面
    NSInteger subIndex = 0; // 新增Cell的位置
    BOOL isFinished = NO;   // 用来判断费用清算是否完结
    
    if (index == DQFlowTypeFix || index == DQFlowTypeMaintain
        || index == DQFlowTypeHeighten) {
        NSMutableArray *logicArray = [NSMutableArray arrayWithCapacity:0];

        // 第一次过滤，增加人员往来cell, 增加整改单Button
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [array count]; i ++ ) {
            DQSubMaintainModel *model = (DQSubMaintainModel *)array[i];
            [tempArray addObject:model];

            BOOL isLast = YES;
            if ([array count] > i + 1) {
                DQSubMaintainModel *next = (DQSubMaintainModel *)array[i + 1];
                if (next.linkid == model.linkid) {  // 每个单子的最后一条
                    isLast = NO;
                }
            }

            // 维修／维保／加高单通过或者完成单驳回之后，添加"新增完成单“按钮
            if (model.enumstateid == DQEnumStateFixPass ||
                model.enumstateid == DQEnumStateFixDoneRefuse ||
                model.enumstateid == DQEnumStateMaintainPass ||
                model.enumstateid == DQEnumStateMaintainDoneRefuse ||
                model.enumstateid == DQEnumStateHeightenPass ||
                model.enumstateid == DQEnumStateHeightenDoneRefuse) {
                
                // 维修／维保／加高单通过或驳回之后增加一条”人员往来“的Cell，并从上一个数据里取出列表数据
//                if (model.enumstateid == DQEnumStateFixPass ||
//                    model.enumstateid == DQEnumStateMaintainPass ||
//                    model.enumstateid == DQEnumStateHeightenPass) {
                DQSubMaintainModel *personModel = [model copy];
                personModel.enumstateid = DQEnumStateUsingUserList;
                [tempArray addObject:personModel];
//                }
                
                // 添加设备维修／加高／维护完成单按钮
                if ([AppUtils readUser].isZuLin && isLast) {
                    if (index == DQFlowTypeMaintain) {
                        enumState = DQEnumStateMaintainDoneAdd;
                    } else {
                        enumState = index == DQFlowTypeFix ? DQEnumStateFixDoneAdd : DQEnumStateHeightenDoneAdd;
                    }
                    DQServiceSubNodeModel *tempM = [[NSClassFromString(name).class alloc] init];
                    tempM.enumstateid = enumState;
                    tempM.isButtonCell = YES;
                    tempM.linkid = model.linkid;
                    [tempArray addObject:tempM];
                }
                
                // 增加评价view
            } else if (model.enumstateid == DQEnumStateMaintainDonePass ||
                       model.enumstateid == DQEnumStateFixDonePass ||
                       model.enumstateid == DQEnumStateHeightenDonePass) {
                if (!user.isZuLin || (user.isZuLin && model.serviceevaluate.ID > 0)) {
                    DQSubMaintainModel *evaluateModel = [model copy];
                    evaluateModel.enumstateid = DQEnumState3WEvaluate;
                    [tempArray addObject:evaluateModel];
                }
            }
        }

        [array removeAllObjects];
        [array addObjectsFromArray:tempArray];
        
        // 第二次过滤：按linkID将数据分组
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i = 0; i < [array count]; i ++) {
            DQServiceSubNodeModel *sub = (DQServiceSubNodeModel *)array[i];
            NSMutableArray *subArray = [NSMutableArray arrayWithCapacity:0];
            
            NSString *key = [NSString stringWithFormat:@"%ld", sub.linkid];
            if (dict[key]) {
                [subArray addObjectsFromArray:dict[key]];
            }
            [subArray addObject:sub];
            dict[key] = subArray;
        }
        
        // 第三次过滤，拼接LogicModel
        for (NSArray *subArray in [dict allValues]) {
            
            NSMutableArray *oneList = [NSMutableArray arrayWithCapacity:0];
            for (int j = 0; j < [subArray count]; j ++) {
                
                DQSubMaintainModel *sub = (DQSubMaintainModel *)subArray[j];
                sub.isLast = j == [subArray count] - 1;
                
                DQLogicMaintainModel *logicModel = [[DQLogicMaintainModel alloc] init];
                logicModel.cellData = sub;
                logicModel.nodeName = typeName;
                logicModel.nodeType = [AppUtils nodeIndexWithTypeName:typeName];
                logicModel.isLast = sub.isLast;
                logicModel.billID = [NSString stringWithFormat:@"%ld", sub.linkid];
                [oneList addObject:logicModel];
            }
            [logicArray addObject:oneList];
        }

        return logicArray;
    }
    
    switch (index) {
        case DQFlowTypeCommunicate:
        {
            if (user.isZuLin && !user.isCEO && last.enumstateid == 13) {
                needAddBtn = YES;
                enumState = DQEnumStateDeviceModify;    // 编辑设备信息
            }
        }
            break;
        case DQFlowTypePack:
            //设备报装
        {
            if (array.count > 0) {
                // start:只显示有包装资料后面一条驳回信息
                NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < [array count]; i ++ ) {
                    DQSubPackModel *model = (DQSubPackModel *)array[i];
                    
                    if (model.enumstateid != DQEnumStatePackRefuse) {
                        if ([model.msgattachmentList count] > 0) {
                            [tempArray addObject:model];
                        }
                        
                        if ([array count] > i + 1) {
                            DQServiceSubNodeModel *modelNext = array[i + 1];
                            [tempArray addObject:modelNext];
                        }
                    }
                }
                [array removeAllObjects];
                [array addObjectsFromArray:tempArray];
                // end: 只显示有包装资料后面一条驳回信息
                
                // 租赁者上传报装资料
                if (last.enumstateid == DQEnumStatePackRefuse && user.isZuLin) {
                    enumState = DQEnumStatePackAdd;
                    needAddBtn = YES;
                }
            } else {
                if (user.isZuLin && !user.isCEO) {
                    //最后一条为驳回状态且为租赁者，最后一条贴一条按钮cell
                    needAddBtn = YES;
                    enumState = DQEnumStatePackAdd;
                }
            }
        }
            break;
        case DQFlowTypeSetup:
        {
            //设备安装
            if (array.count > 0) {
                if (user.isZuLin && !user.isCEO) {
                    // 最后一条为技术交底驳回状态且为租赁者，最后一条贴一条 设备现场技术交底按钮cell
                    if (last.enumstateid == DQEnumStateSetupTechRefuse) {
                        needAddBtn = YES;
                        enumState = DQEnumStateApplyForSubmit;
                    }
                    // 最后一条为技术交底通过状态且为租赁者，最后一条贴一条 上传安装凭证按钮cell
                    else if (last.enumstateid == 18 || last.enumstateid == 22) {
                        needAddBtn = YES;
                        enumState = DQEnumStateSetupEvidence;
                    }
                    // 最后一条为安装凭证通过状态且为租赁者，最后一条贴一条 上传第三方凭证按钮cell
                    else if (last.enumstateid == 21 || last.enumstateid == 25) {
                        needAddBtn = YES;
                        enumState = DQEnumStateCheckEvidence;
                    }
                }
                // 最后一条为第三方凭证确认状态，最后一条贴一条 安装报告cell
                if (last.enumstateid == 24) {
                    needReportCell = YES;
                    enumState = DQEnumStateDeviceReport;
                }
            } else {
                if (user.isZuLin && !user.isCEO) {
                    needAddBtn = YES;
                    enumState = DQEnumStateApplyForSubmit;    // 设备现场技术交底按钮
                }
            }
        }
            break;
        case DQFlowTypeRent:
            //设备启租
        {
            if (array.count > 0) {
                if (user.isZuLin && !user.isCEO) {
                    if (last.enumstateid == DQEnumStateRentRefuse) {
                        needAddBtn = YES;
                        enumState = DQEnumStateRentModify;    // 修改启租单
                    }
//                    else if (last.enumstateid == 27) {
//                        needAddBtn = YES;
//                        enumState = DQEnumStateDeviceLock;    // 设备锁机
//                    }
                }
            } else {
                if (user.isZuLin && !user.isCEO) {
                    needAddBtn = YES;
                    enumState = DQEnumStateRentAdd;    // 新增启租单
                }
            }
        }
            break;
        case DQFlowTypeRemove:
        {
            //设备停租
            if (array.count > 0) {
                if (last.enumstateid == DQEnumStateRemovePass ||
                    last.enumstateid == DQEnumStateRemoveSubmitted) {
                    // 在通过前插一条费用清算，未通过则放在最后
                    if (last.enumstateid == DQEnumStateRemovePass) {
                        subIndex = 1;
                    }
                    needReportCell = YES;
                    enumState = DQEnumStateCostReport;
                    // 费用结算才显示“认证通过的icon”
                    isFinished = last.enumstateid == DQEnumStateRemovePass;
                }
            }else{
                if (!user.isZuLin) {    // 承租方发起启租单提交
                    needAddBtn = YES;
                    enumState = DQEnumStateRemoveAdd;
                }
            }
        }
            break;
        case DQFlowTypeEvaluate:
        {
            // 承租方发起服务评价
            if ([array count] < 1) {
                if (!user.isZuLin) {
                    needAddBtn = YES;
                    enumState = DQEnumStateEvaluateAdd;
                }
            }
        }
            break;
        default:
            break;
    }
    
    if (needAddBtn || needReportCell) { // 添加Button或数据报告的Cell
        
        DQServiceSubNodeModel *tempM = [[NSClassFromString(name).class alloc] init];
        // 添加“修改启租单”Button时，取之前的单子
        if ([array count] > 1 && enumState == DQEnumStateRentModify) {
            NSInteger index = [array count] - 2;    // 驳回之后才有修改启租单，所以取倒数第二个
            DQSubRentModel *orderModel = [NSObject changeType:array[index]];
            tempM = [orderModel copy];
        }
        // 添加“编辑设备信息”Button时，取之前的单子
        if ([array count] > 1 && enumState == DQEnumStateDeviceModify) {
            NSInteger index = [array count] - 2;    // 驳回之后才有编辑设备信息，所以倒数出第二个
            DQSubCommunicateModel *orderModel = [NSObject changeType:array[index]];
            tempM = [orderModel copy];
        }
        // 添加“费用清算”Button时，取之前的单子
        if ([array count] > 0 &&
            (enumState == DQEnumStateCostReport)) {
            NSInteger index = [array count] - 1;
            DQSubRemoveModel *orderModel = [NSObject changeType:array[index]];
            tempM = [orderModel copy];
        }
        tempM.enumstateid = enumState;
        tempM.isButtonCell = needAddBtn;
        tempM.isReportCell = needReportCell;
        if (subIndex > 0) {
            [array insertObject:tempM atIndex:[array count] - subIndex];   // 费用清算单的位置
        } else if (isFirst) {
            [array insertObject:tempM atIndex:0];   // 按钮放在最前面一行
        } else {
            [array addObject:tempM];
        }
    }

    // 将数据model封装在业务model中
    NSMutableArray *logicArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [array count]; i ++) {
        DQServiceSubNodeModel *sub = array[i];

        NSString *nameLogic = [self getLogicModelNameWithTypeName:typeName];
        DQLogicServiceBaseModel *logicModel = [[NSClassFromString(nameLogic).class alloc] init];
        logicModel.cellData = sub;
        logicModel.nodeName = typeName;
        logicModel.isFinished = isFinished;
        logicModel.nodeType = [AppUtils nodeIndexWithTypeName:typeName];
        logicModel.isLast = sub.isLast;
        logicModel.billID = [NSString stringWithFormat:@"%ld", sub.linkid];
        [logicArray addObject:logicModel];
    }
    return logicArray;
}

#pragma mark - 👇根据typeName返回响应的数据Model
- (NSString *)getModelNameWithTypeName:(NSString *)typeName {
    
    NSArray *models = @[@"DQSubCommunicateModel", @"DQSubPackModel",
                        @"DQSubSetupModel", @"DQSubRentModel",
//                      @"ServiceCenterBaseModel",
                        @"DQSubMaintainModel",
                        @"DQSubMaintainModel",@"DQSubMaintainModel",
                        @"DQSubRemoveModel", @"DQSubEvaluateModel"];
    DQFlowType index = [AppUtils nodeIndexWithTypeName:typeName];
    return models[index];
}

#pragma mark - 👇根据typeName返回响应的逻辑处理Model
- (NSString *)getLogicModelNameWithTypeName:(NSString *)typeName {
    
    NSArray *models = @[@"DQLogicCommunicateModel", @"DQLogicPackModel",
                        @"DQLogicSetupModel", @"DQLogicRentModel",
//                      @"DQLogicServiceBaseModel",
                        @"DQLogicMaintainModel",
                        @"DQLogicMaintainModel",@"DQLogicMaintainModel",
                        @"DQLogicRemoveModel", @"DQLogicEvaluateModel"];
    DQFlowType index = [AppUtils nodeIndexWithTypeName:typeName];
    return models[index];
}

/// 确认／驳回
- (void)dq_confirmOrRefuseWithProject:(NSNumber *)projectID
                             deviceID:(NSNumber *)deviceID
                            eventtype:(DQEventType)eventtype
                              yesorno:(BOOL)yesorno
                               billid:(NSNumber *)billid
                      projectdeviceid:(NSNumber *)projectdeviceid
                              success:(DQResultBlock)suc
                             failture:(DQFailureBlock)fail {
    NSDictionary *params = [self paramsWithParam:
                            @{@"projectid" : [NSString stringWithFormat:@"%@", projectID],
                              @"deviceid" : [NSString stringWithFormat:@"%@", deviceID],
                              @"eventtype" : [NSString stringWithFormat:@"%@", [self eventWithType:eventtype]],
                              @"yesorno" : [NSString stringWithFormat:@"%@", yesorno ? @"通过" : @"驳回"],
                              @"billid" : [NSString stringWithFormat:@"%@", billid],
                              @"projectdeviceid" : [NSString stringWithFormat:@"%@", projectdeviceid]
                              }];

    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AgreeRefuse
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             suc(@"1");
         } else {
             fail([NSError errorWithDomain:returnValue.msg code:0 userInfo:nil]);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

#pragma mark - 👇业务分节流程
/**
 获取设备型号
 
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getBrandDeviceProject:(NSInteger)type
                         success:(DQResultBlock)suc
                        failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *parama = @{@"userid":@(loginUser.userid),
                             @"type":loginUser.type,
                             @"usertype":loginUser.usertype,
                             @"orgid":@(loginUser.orgid)};
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_BrandModel
     parameters:parama
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray *list = (NSMutableArray *)returnValue.data;
             NSMutableArray *array = [NSMutableArray new];
             for (NSDictionary *dict in list) {
                 NSMutableArray *deviceArr = [DQDeviceModel mj_objectArrayWithKeyValuesArray:dict[@"device"]];
                 NSMutableArray *modelList = [DQSecondDeviceModel mj_objectArrayWithKeyValuesArray:dict[@"model"]];
                 DQAddProjectModel *model = [DQAddProjectModel new];
                 model.brand = [NSObject changeType:dict[@"brand"]];
                 model.deviceArray = deviceArr;
                 model.secondArray = modelList;
                 [array safeAddObject:model];
             }
             suc(array);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

/**
 获取承租方 列表
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getNeedOrgList:(NSDictionary *)pamara
                  success:(DQResultBlock)suc
                 failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_GetNeedOrgList
     parameters:pamara
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray *dataArray = returnValue.data;
             NSMutableArray *addList = [NSMutableArray array];
             for (id item in dataArray) {
                 CK_ID_NameModel *m = [[CK_ID_NameModel alloc] init];
                 m.cid = [[item objectForKey:@"orgid"] intValue];
                 m.cname = [item objectForKey:@"orgname"];
                 m.pm = [UserModel mj_objectArrayWithKeyValuesArray:[item objectForKey:@"pm"]];
                 [addList safeAddObject:m];
             }
             suc(addList);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

/**
 修改司机
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getModifyDeriveAPI:(NSDictionary *)pamara
                      success:(DQResultBlock)suc
                     failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_ModifyWithDerive
     parameters:pamara
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

#pragma mark - 👇启租单
- (void)dq_getRentFormOrder:(NSDictionary *)pamara rentFormType:(DQEnumState)formType success:(DQResultBlock)suc failture:(DQFailureBlock)fail {
    
    NSString *url = nil;
    if (formType == DQEnumStateRentAdd) {
        url = API_AddStartRentOrder;
     } else if (formType == DQEnumStateRentModify) {
        url = API_UpdateStartRentOrder;
    } else if (formType == DQEnumStateRemoveAdd) {
        url = API_StopRentOrder;
    }
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:url
     parameters:pamara
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
 新增启租单
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddStarRentOrder:(NSDictionary *)pamara
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddStartRentOrder
     parameters:pamara
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
 修改启租单
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getUpdateStarRentOrder:(NSDictionary *)pamara
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_UpdateStartRentOrder
     parameters:pamara
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
 停租单
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getStopRentOrder:(NSDictionary *)pamara
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_StopRentOrder
     parameters:pamara
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

#pragma mark - 👇新增设备维修、维保、加高等提交表单
/**
 租赁方发起维保提醒⏰
 
 @param params dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_sendMaintainMessage:(NSDictionary *)params
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail {
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_SendMaintainMsg
     parameters:params
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
 新增设备维修、维保、加高等提交表单
 
 @param params dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_addMaintenceOrderWithType:(DQEnumState)type
                                     params:(NSDictionary *)params
                                   success:(DQResultBlock)suc
                                  failture:(DQFailureBlock)fail
{
    NSString *url = nil;
    if (type == DQEnumStateFixAdd) {
        url = API_AddDeviceRepairOrder;
    } else if (type == DQEnumStateHeightAdd) {
        url = API_AddDevicehighOrder;
    } else if (type == DQEnumStateMaintainAdd) {
        url = API_AddDeviceMaintainOrder;
    }
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:url
     parameters:params
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
 新增设备维修
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceRepairOrder:(NSDictionary *)pamara
                           success:(DQResultBlock)suc
                          failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddDeviceRepairOrder
     parameters:pamara
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
 新增设备加高
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceHightenOrder:(NSDictionary *)pamara
                            success:(DQResultBlock)suc
                           failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddDevicehighOrder
     parameters:pamara
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
 新增设备维保
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceMaintainOrder:(NSDictionary *)pamara
                             success:(DQResultBlock)suc
                            failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddDeviceMaintainOrder
     parameters:pamara
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

#pragma mark - 👇新增设备维修、维保、加高等完成单
/**
 新增设备维修、维保、加高等表单
 DQEnumStateMaintainDoneAdd = 173,         // 新增维保完成单
 DQEnumStateFixDoneAdd = 174,              // 新增维修完成单
 DQEnumStateHeightenDoneAdd = 175,         // 新增加高完成单
 @param params dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_addMaintenceFinishOrderWithType:(DQEnumState)type
                                    params:(NSDictionary *)params
                                   success:(DQResultBlock)suc
                                  failture:(DQFailureBlock)fail
{
    NSString *url = nil;
    if (type == DQEnumStateFixDoneAdd) {
        url = API_AddRepairFinish;
    } else if (type == DQEnumStateHeightenDoneAdd) {
        url = API_AddHeightFinish;
    } else if (type == DQEnumStateMaintainDoneAdd) {
        url = API_AddMaintainFinish;
    } else if (type == DQEnumStateBusConFinishAdd) {
        url = API_BusiContFinishAdd;
    }
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:url
     parameters:params
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
 新增设备维修
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceRepairFinishOrder:(NSDictionary *)pamara
                           success:(DQResultBlock)suc
                          failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddRepairFinish
     parameters:pamara
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
 新增设备加高
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddDeviceHightenFinishOrder:(NSDictionary *)pamara
                            success:(DQResultBlock)suc
                           failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddHeightFinish
     parameters:pamara
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
 新增设备维保
 
 @param pamara dict
 @param suc 成功
 @param fail 失败 API_BusiContFinishAdd
 */
- (void)dq_getAddDeviceMaintainFinishOrder:(NSDictionary *)pamara
                             success:(DQResultBlock)suc
                            failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddMaintainFinish
     parameters:pamara
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
 获取故障列表
 
 @param pamara dict
 @param suc 成功
 @param fail 失败
 
 */
- (void)dq_getFaultdata:(NSDictionary *)pamara
                success:(DQResultBlock)suc
               failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_FaultDataList
     parameters:pamara
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSArray <FaultDataModel *> *ma = [FaultDataModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             NSMutableArray <WarningModel *> *wma = [NSMutableArray array];
             for (FaultDataModel *item in ma) {
                 [wma addObjectsFromArray:item.detail];
             }
             NSMutableArray *arr = [NSMutableArray arrayWithObject:wma];
             suc(arr);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

#pragma mark - 👇确认时间发起维保、维修、加高（租赁方 选择工作人员，确认发起表单）
/**
 确认时间发起维保、维修、加高
 
 @param params pamara description
 @param type 维保、维修、加高类型
 */
- (void)dq_getconfirmStartMaintainWithType:(DQEnumState)type
                                    params:(NSDictionary *)params
                                   success:(DQResultBlock)suc
                                  failture:(DQFailureBlock)fail
{
    NSString *url = nil;

    if (type == DQEnumStateFixSubmitted) {
        url = API_StartRepair;
    } else if (type == DQEnumStateHeightenSubmitted) {
        url = API_DeviceAddHeight;
    } else if (type == DQEnumStateMaintainSubmitted) {
        url = API_StartMaintain;
    } else {
        DQLog(@"-- 没有取到对应的API --");
    }
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:url
     parameters:params
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
 确认时间发起维修
 
 @param pamara dict
 @param suc dd
 @param fail dd
 */
- (void)dq_getConfigStartRepair:(NSDictionary *)pamara
                        success:(DQResultBlock)suc
                       failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_StartRepair
     parameters:pamara
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
 //确认时间发起加高
 
 @param suc sub
 @param fail fai
 */
- (void)dq_getConfigAddHeight:(NSNumber *)projectid
                     deviceid:(NSNumber *)deviceid
                       highid:(NSNumber *)highid
                       people:(NSMutableArray *)people
                      success:(DQResultBlock)suc
                     failture:(DQFailureBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    [params setObject:projectid forKey:@"projectid"];
    [params setObject:deviceid forKey:@"deviceid"];
    [params setObject:highid forKey:@"highid"];
    [params setObject:people forKey:@"people"];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_DeviceAddHeight
     parameters:params
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
 确认时间发起维保
 
 @param pamara <#pamara description#>
 @param suc <#suc description#>
 @param fail <#fail description#>
 */
- (void)dq_getConfigStartMaintain:(NSDictionary *)pamara
                          success:(DQResultBlock)suc
                         failture:(DQFailureBlock)fail
{
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_StartMaintain
     parameters:pamara
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
 申请现场技术交底
 
 @param suc <#suc description#>
 @param fail <#fail description#>
 */
- (void)dq_getConfigDisclosure:(NSNumber *)projectid
                      deviceid:(NSNumber *)deviceid
               projectdeviceid:(NSNumber *)projectdeviceid
                       success:(DQResultBlock)suc
                      failture:(DQFailureBlock)fail;
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    [params setObject:projectid forKey:@"projectid"];
    [params setObject:deviceid forKey:@"deviceid"];
    [params setObject:projectdeviceid forKey:@"projectdeviceid"];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_Disclosure
     parameters:params
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
 上传安装凭证
 
 @param suc <#suc description#>
 @param fail <#fail description#>
 */
- (void)dq_getUploadDocument:(NSNumber *)projectid
                    deviceid:(NSNumber *)deviceid
                        imgs:(NSMutableArray *)imgs
             projectdeviceid:(NSNumber *)projectdeviceid
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    [params setObject:projectid forKey:@"projectid"];
    [params setObject:deviceid forKey:@"deviceid"];
    [params setObject:projectdeviceid forKey:@"projectdeviceid"];
    [params setObject:imgs forKey:@"imgs"];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_UploadInstallDocument
     parameters:params
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
 上传第三方验收凭证
 */
- (void)dq_getUploadOtherCheckDocumnet:(NSNumber *)projectid
                              deviceid:(NSNumber *)deviceid
                                  imgs:(NSMutableArray *)imgs
                       projectdeviceid:(NSNumber *)projectdeviceid
                               success:(DQResultBlock)suc
                              failture:(DQFailureBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    [params setObject:projectid forKey:@"projectid"];
    [params setObject:deviceid forKey:@"deviceid"];
    [params setObject:projectdeviceid forKey:@"projectdeviceid"];
    [params setObject:imgs forKey:@"imgs"];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_UploadOtherDocumnet
     parameters:params
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
 加高完成
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getAddHeightFinsh:(NSNumber *)projectid
                    deviceid:(NSNumber *)deviceid
                      highid:(NSNumber *)highid
                     success:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    [params setObject:projectid forKey:@"projectid"];
    [params setObject:deviceid forKey:@"deviceid"];
    [params setObject:highid forKey:@"highid"];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_AddHighFinsh
     parameters:params
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
                         failture:(DQFailureBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    
    [params setObject:projectid forKey:@"projectid"];
    [params setObject:deviceid forKey:@"deviceid"];
    [params setObject:upLoadImgs forKey:@"imgs"];
    [params setObject:projectDeviceID forKey:@"projectdeviceid"];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_UploadNoticeInstallData
     parameters:params
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
 设备锁机
 
 @param projectid 项目id
 @param deviceid 设备id
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getConfigLocked:(NSNumber *)projectid
                  deviceid:(NSNumber *)deviceid
                   success:(DQResultBlock)suc
                  failture:(DQFailureBlock)fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    UserModel *loginUser = [AppUtils readUser];
    [params setObject:[NSString stringWithFormat:@"%ld", loginUser.userid] forKey:@"userid"];
    [params setObject:[NSObject changeType:loginUser.type] forKey:@"type"];
    [params setObject:[NSObject changeType:loginUser.usertype] forKey:@"usertype"];
    [params setObject:projectid forKey:@"projectid"];
    [params setObject:deviceid forKey:@"deviceid"];
    
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_Locked
     parameters:params
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
 选择工作人员
 
 @param suc 成功
 @param fail 失败
 */
- (void)dq_getRepairUserList:(NSInteger)projectID
                         suc:(DQResultBlock)suc
                    failture:(DQFailureBlock)fail
{
    UserModel *loginUser = [AppUtils readUser];
    NSDictionary *params = @{@"userid" : @(loginUser.userid),
                             @"type" : loginUser.type,
                             @"projectid" : @(projectID),
                             @"usertype" : loginUser.usertype
                             };
    [[DQBaseAPIInterface sharedInstance]
     dq_postRequestWithUrl:API_getRepairUserList
     parameters:params
     progress:^(CGFloat percent) {
         
     } success:^(DQResultModel *returnValue) {
         if ([returnValue isRequestSuccess]) {
             NSMutableArray *userArray = [UserModel mj_objectArrayWithKeyValuesArray:returnValue.data];
             suc(userArray);
         } else {
             suc(nil);
         }
     } failture:^(NSError *error) {
         fail(error);
     }];
}

@end

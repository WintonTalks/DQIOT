//
//  DQEnum.h
//  WebThings
//
//  Created by Heidi on 2017/9/7.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQEnum_h
#define DQEnum_h

// 网络请求Method
typedef NS_ENUM(NSInteger, DQRequestMethod){
    MethodGET = 0,
    MethodPOST,
    MethodPUT,
    MethodDELETE
};

// 业务站服务流
typedef NS_ENUM(NSInteger, DQFlowType){
    DQFlowTypeCommunicate = 0,  // 前期沟通
    DQFlowTypePack = 1,             // 设备报装
    DQFlowTypeSetup = 2,            // 设备安装
    DQFlowTypeRent = 3,             // 设备启租
    DQFlowTypeMaintain = 4,         // 设备维保
    DQFlowTypeFix = 5,              // 设备维修
    DQFlowTypeHeighten = 6,         // 设备加高
    DQFlowTypeRemove = 7,           // 设备拆除
    DQFlowTypeEvaluate = 8,         // 服务评价
    DQFlowTypeBusinessContact = 9   // 商务往来
};

/// 服务站模块Cell样式类型
typedef NS_ENUM(NSInteger, DQCellType){
    DQCellTypeBlueButton = 0,   // 蓝色提交按钮样式
    DQServiceCellTypeRefuteBack,// 通过|驳回
    DQServiceCellTypePictures  // 图片浏览

};

typedef NS_ENUM(NSInteger, DQDirection) {
    DQDirectionLeft, // 靠左
    DQDirectionRight // 靠右
};

// 事件类型
typedef NS_ENUM(NSInteger, DQEventType) {
    DQEventTypeNone = 0,        // 无关联
    DQEventTypeCommunicate, // 前期沟通_进场沟通单
    DQEventTypePack,        // 设备报装_报装资料
    DQEventTypeSetupTech,   // 设备安装_现场技术交底
    DQEventTypeSetup,       // 设备安装_安装凭证
    DQEventTypeSetupCheck,  // 设备安装_第三方验收凭证
    DQEventTypeRent,        // 设备启租_启租单
    DQEventTypeDriver,      // 司机确认
    DQEventTypeMaintain,    // 设备维保
    DQEventTypeFix,         // 设备维修
    DQEventTypeHeighten,    // 设备加高
    DQEventTypeRemove       // 设备拆除
};

/*
 153:设备报装按钮
 154:申请现场技术交底按钮
 155:设备安装凭证按钮
 156:第三方验收凭证按钮
 157:设备安装报告
 158:新增设备启租按钮
 159:修改启租单按钮
 160:新增设备维保单按钮
 161:新增设备维修单
 162:新增服务要求表
 163:新增停租单
 164:新增服务评价
 165:费用清算
 166:用户自己找司机
 167:修改司机
 168:设备锁机
 169:修改项目
 */
typedef NS_ENUM(NSInteger, DQEnumState) {
    
    // =========== 👇接口返回的状态 ===========
    // ------- 进场沟通 -------
    DQEnumStateCommunicateSubmitted = 11,     // 进场沟通单已提交，等待确认或驳回
    DQEnumStateCommunicatePass = 12,          // 进场沟通单已确认
    DQEnumStateCommunicateRefuse = 13,        // 进场沟通单已驳回

    // ------- 设备报装 -------
    DQEnumStatePackSubmitted = 14,           // 设备报装资料提交
    DQEnumStatePackPass = 15,                // 设备报装资料已确认
    DQEnumStatePackRefuse = 16,              // 设备报装资料已驳回
    
    // ------- 设备安装 -------
    DQEnumStateSetupTechSubmitted = 17,     // 现场技术交底提交
    DQEnumStateSetupTechPass = 18,          // 现场技术交底已确认
    DQEnumStateSetupTechRefuse = 19,        // 现场技术交底已驳回
    DQEnumStateSetupSubmitted = 20,         // 现场安装提交
    DQEnumStateSetupPass = 21,              // 现场安装已确认
    DQEnumStateSetupRefuse = 22,            // 现场安装已驳回
    DQEnumStateSetupEvidenceSubmitted = 23, // 第三方凭证提交
    DQEnumStateSetupEvidencePass = 24,      // 第三方凭证已确认
    DQEnumStateSetupEvidenceRefuse = 25,    // 第三方凭证已驳回
    
    // ------- 启租 -------
    DQEnumStateRentSubmitted = 26,          // 启租单提交
    DQEnumStateRentPass = 27,               // 启租单已确认
    DQEnumStateRentRefuse = 28,             // 启租单已驳回
    
    // ------- 停租/设备拆除 -------
    DQEnumStateRemoveSubmitted = 29,        // 停租单提交
    DQEnumStateRemovePass = 30,             // 停租单已确认
    DQEnumStateRemoveRefuse = 31,           // 费用未缴清
    
    // ------- 维保 -------
    DQEnumStateMaintainSubmitted = 35,      // 维保单提交
    DQEnumStateMaintainPass = 36,           // 维保单已确认
    DQEnumStateMaintainDoneSubmitted = 37,  // 维保完成单提交
    DQEnumStateMaintainDonePass = 38,       // 维保完成单确认
    DQEnumStateMaintainDoneRefuse = 50,     // 维保完成单驳回
    
    // ------- 维修 -------
    DQEnumStateFixSubmitted = 39,           // 维修单提交
    DQEnumStateFixPass = 40,                // 维修单已确认
    DQEnumStateFixDoneSubmitted = 41,       // 维修完成单提交
    DQEnumStateFixDonePass = 42,            // 维修完成单确认
    DQEnumStateFixDoneRefuse = 51,          // 维修完成单驳回
    
    // ------- 加高 -------
    DQEnumStateHeightenSubmitted = 43,      // 加高单提交
    DQEnumStateHeightenPass = 44,           // 加高单已确认
    DQEnumStateHeightenDoneSubmitted = 45,  // 加高完成单提交
    DQEnumStateHeightenDonePass = 46,       // 加高完成单确认
    DQEnumStateHeightenDoneRefuse = 52,     // 加高完成单驳回
    
    // ------- 商务往来 -------
    DQEnumStateBusContactSubmited = 53,         // 商函已提交，等待确认
    DQEnumStateBusContactConfirmed = 54,        // 商函通知已确认
    DQEnumStateBusContactAdviceSubmited = 55,   // 整改意见已提交，等待确认
    DQEnumStateBusContactAdviceComfirmed = 56,  // 整改意见已确认
    DQEnumStateBusContactFinishSubmited = 57,   // 整改完成单已提交，等待驳回或确认
    DQEnumStateBusContactFinishPass = 58,       // 整改完成单已通过
    DQEnumStateBusContactFinishRefuse = 59,     // 整改完成单已驳回
    
    DQEnumStateSendMaintainMessage = 61,        // 租赁方 发起维保提醒“维保流程”成功
    
    // =========== 👇IOS App端自定义“新增／修改按钮”或报告 ===========
    DQEnumStatePackAdd = 153,                   // 设备报装按钮
    DQEnumStateApplyForSubmit = 154,            // 申请现场技术交底按钮
    DQEnumStateSetupEvidence = 155,             // 设备安装凭证按钮
    DQEnumStateCheckEvidence = 156,             // 第三方验收凭证按钮
    DQEnumStateDeviceReport = 157,              // 设备安装报告
    DQEnumStateRentAdd = 158,                   // 新增设备启租按钮
    DQEnumStateRentModify = 159,                // 修改启租单按钮
    DQEnumStateMaintainAdd = 160,               // 新增设备维保单按钮
    DQEnumStateFixAdd = 161,                    // 新增设备维修单
    DQEnumStateHeightAdd = 162,                 // 新增服务要求表
    DQEnumStateRemoveAdd = 163,                 // 新增停租单
    DQEnumStateEvaluateAdd = 164,               // 新增服务评价
    DQEnumStateCostReport = 165,                // 费用清算
    DQEnumStateDeviceLock = 168,                // 设备锁机
    DQEnumStateDeviceModify = 169,              // 修改设备信息
    DQEnumStateBusContactAdd = 170,             // 添加商务往来
    DQEnumStateBusConAdviceAdd = 171,           // 添加整改意见
    DQEnumStateBusConFinishAdd = 172,           // 添加整改完成单
    
    DQEnumStateMaintainDoneAdd = 173,           // 新增维保完成单
    DQEnumStateFixDoneAdd = 174,                // 新增维修完成单
    DQEnumStateHeightenDoneAdd = 175,           // 新增加高完成单

    DQEnumStateBusContGoing = 176,              // 商务往来进行中状态
    DQEnumStateUsingUserList = 177,             // 维修／维保／加高人员列表
    DQEnumState3WEvaluate = 178                 // 维修／维保／加高评价
};

typedef NS_ENUM(NSInteger, DQEvaluateType) {
    DQEvaluateTypeProject = 0,          // 项目整体评价
    DQEvaluateTypeDevice = 1,           // 设备评价
    DQEvaluateTypeWorker = 2,           // 某个或某几个工人评价
    DQEvaluateTypeHeighten = 3,         // 加高评价
    DQEvaluateTypeFix = 4,              // 维修评价
    DQEvaluateTypeMaintain = 5,         // 维护评价
    DQEvaluateTypePersonInProject = 6,  // 人员在项目整体中的评价
    DQEvaluateTypePersonInService = 7   // 业务站中人员的评价
};

#endif /* DQEnum_h */

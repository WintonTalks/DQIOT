//
//  DQLogicMaintainModel.m
//  WebThings
//  服务流维修逻辑处理类
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQLogicMaintainModel.h"
#import "DQSubMaintainModel.h"
#import "DQFinishOrderModel.h"// 完成单model

#import "AddDeviceWHListViewController.h"
#import "DQDeviceMaintainFormViewController.h"
#import "DQDeviceMaintainFinishFormController.h"


@interface DQLogicMaintainModel () <EMIBaseViewControllerDelegate>

@end

@implementation DQLogicMaintainModel

#pragma mark - Getter
- (NSString *)cellIdentifier {
    
    NSInteger stateID = self.cellData.enumstateid;
    DQLog(@"stateID:%ld",stateID);
    // 设备维保、维修、加高申请单 提交
    if (stateID == DQFlowTypeHeighten ||
        stateID == DQFlowTypeRemove ||
        stateID == DQFlowTypeEvaluate ||
        
        stateID == DQEnumStateMaintainSubmitted ||
        stateID == DQEnumStateFixSubmitted ||
        stateID == DQEnumStateHeightenSubmitted) {
        return @"DQDeviceMaintainApplyFormViewCell";
    }// 维保完成提交单
    else if (stateID == DQEnumStateMaintainDoneSubmitted ||
             stateID == DQEnumStateFixDoneSubmitted ||
             stateID == DQEnumStateHeightenDoneSubmitted) {
        return @"DQDeviceMaintainFinishFormViewCell";
    }// 租赁方 维保提醒
    else if (stateID == DQEnumStateSendMaintainMessage) {
        return @"DQDevicemaintainAlertFormViewCell";
    }// 维保人员列表,表单进行中
    else if (stateID == DQEnumStateUsingUserList) {
        return @"DQDeviceMaintainContinueFormViewCell";
    }// 人员评价
    else if (stateID == DQEnumState3WEvaluate) {
        return @"DQDeviceMaintainEvaluateFormViewCell";
    }// 确认或者驳回的样式
    else if (stateID == DQEnumStateMaintainPass ||
             stateID == DQEnumStateMaintainDonePass ||
             stateID == DQEnumStateMaintainDoneRefuse ||
             
             stateID == DQEnumStateFixPass ||
             stateID == DQEnumStateFixDonePass ||
             stateID == DQEnumStateFixDoneRefuse ||
             
             stateID == DQEnumStateHeightenPass ||
             stateID == DQEnumStateHeightenDonePass ||
             stateID == DQEnumStateHeightenDoneRefuse) {
        return @"DQRefuteBackCell";
    }
    
    return [super cellIdentifier];
}

// 当前业务展示界面的高度
- (CGFloat)cellHeight {
    
    UserModel *user = [AppUtils readUser];
    NSInteger stateID = self.cellData.enumstateid;
    CGFloat height = 76;
    
    // 维保提醒
    if (stateID == DQEnumStateSendMaintainMessage) {
        // 提交之后的状态，增加和驳回按钮
        if (self.showRefuteBackButton) {
            height += (54 + 16);
        } else {
            height += 16;   //底部多留16
        }
        return height;
    }
    // 设备维保、维修、加高告知单 提交
    if (stateID == DQEnumStateMaintainSubmitted ||
        stateID == DQEnumStateFixSubmitted ||
        stateID == DQEnumStateHeightenSubmitted) {
//        height += 32;// 项目信息标签
        
//        // count 数据从model中获取
//        CGFloat modelWorkerCount = self.devieceOrderModel.workers.count > 0 ? self.devieceOrderModel.workers.count : self.workerAry.count;
//        NSInteger workerCount = self.isFoldWorkerList ? 1 : modelWorkerCount;
//        /** 可修改工作人员时的表单列表 */
//        CGFloat addibleWorkerHeight = (modelWorkerCount > 2) ? (workerCount+2)*44 :(modelWorkerCount+1)*44;
//        /** 不可修改工作人员时的表单列表 */
//        CGFloat workerHeight = (modelWorkerCount > 2) ? (workerCount+1)*44+20 :modelWorkerCount*44+20;
//        CGFloat workerFormHeight = self.isLast && self.showRefuteBackButton ? addibleWorkerHeight : workerHeight;

//        if (user.isZuLin) {// 租赁方 维保等申请表单需要显示工人列表
//            height += (self.applyFormHeight + workerFormHeight);//kHEIHGT_BILLCELL * (7+1) 或 [self heightForBill]
//        } else { //承租方不需要显示
            height += self.applyFormHeight;
//        }
        
        // 提交之后的状态，增加和驳回按钮
        if (self.showRefuteBackButton) {
            height += (54 + 16);
        } else {
            height += 16;   // 若没有图片，则底部多留16
        }
        
        return height + 30;// 30 为时间分割view的高度
    }
    // 维保、维修、加高人员列表,表单进行中
    if (stateID == DQEnumStateUsingUserList) {
        NSInteger listHeight = 0;
        DeviceMaintainorderModel *model = self.devieceOrderModel;
        listHeight += 46; // 进行中 信息标签
        listHeight += (1 + model.workers.count)*50;
        listHeight += 32; // 进行中 表单 上下要预留一定的空间（上：16 下：16）
        return listHeight + 16 ;
    }
    // 维保完成提交单
    if (stateID == DQEnumStateMaintainDoneSubmitted ||
        stateID == DQEnumStateFixDoneSubmitted ||
        stateID == DQEnumStateHeightenDoneSubmitted) {
        DeviceMaintainorderModel *model = self.devieceOrderModel;
        // 完成单
        DQFinishOrderModel *finishOrder = [DQFinishOrderModel mj_objectWithKeyValues:model.finshorder];
        NSArray *imgAry = [finishOrder.imgs componentsSeparatedByString:@","];
        NSInteger imageCount = imgAry.count > 6 ? 6 :imgAry.count;
        // count 数据从model中获取
        return [self heightForImageCount:imageCount] + [self heightForBill] + 16;//
    }
    // 人员评价
    if (stateID == DQEnumState3WEvaluate) {
        if (self.canEdit) {
            height += 44;   // 显示发送按钮
        } else {
            height += 16; // 分割线下的空白
        }
        height += 227; // 评价内容view
        return height + 16;
    }
    // 确认或者驳回的样式
    if (stateID == DQEnumStateMaintainPass ||
        stateID == DQEnumStateMaintainDonePass ||
        stateID == DQEnumStateMaintainDoneRefuse ||
        stateID == DQEnumStateFixPass ||
        stateID == DQEnumStateFixDonePass ||
        stateID == DQEnumStateFixDoneRefuse ||
        stateID == DQEnumStateHeightenPass ||
        stateID == DQEnumStateHeightenDonePass ||
        stateID == DQEnumStateHeightenDoneRefuse) {
        height += 16;
        return height;
    }
 
    return 44.0f;
}

/**
 * 承租方，方可评价
 */
- (BOOL)canEdit {
    
    NSArray *evaluates = self.devieceOrderModel.evaluates;
     return self.cellData.enumstateid == DQEnumState3WEvaluate && !self.cellData.isZulin && evaluates == nil;
}

/** 设备订单 维修、维保、加高单数据（三者合一） */
- (DeviceMaintainorderModel *)devieceOrderModel {
    
    DQSubMaintainModel *maintainModel = (DQSubMaintainModel *)self.cellData;
    DeviceMaintainorderModel *deviceModel;
    if (self.nodeType == DQFlowTypeFix) {
        deviceModel = maintainModel.devicerepairorder;
    } else if (self.nodeType == DQFlowTypeHeighten) {
        deviceModel = maintainModel.deivieaddheight;
    } else if (self.nodeType == DQFlowTypeMaintain) {
        deviceModel = maintainModel.deviceMaintainorder;
    }
    return deviceModel;
}

/** 重写父类中 新建表单 按钮标题 */
- (NSString *)titleForButton {
    NSInteger enumStateID = self.cellData.enumstateid;
    switch (enumStateID) {
        case DQEnumStateMaintainAdd:{
            UserModel *user = [AppUtils readUser];
            if (user.isZuLin) {
                return @"发起维保流程";
            }
            return @"新增设备维保单";
        }
            break;
        case DQEnumStateFixAdd: {
            return @"新增设备维修单";
        }
            break;
        case DQEnumStateHeightAdd: {
            return @"新增设备加高单";
        }
            break;
        case DQEnumStateMaintainDoneAdd: {// 设备维保完成单提交
            return @"新增设备维保完成单";
        }
            break;
        case DQEnumStateFixDoneAdd: { // 设备维修完成单提交
            return @"新增设备维修完成单";
        }
            break;
        case DQEnumStateHeightenDoneAdd: { // 设备加高完成单提交
            return @"新增设备加高完成单";
        }
            break;
    }
    return @"";
}

/** 重写父类中 新建表单 按钮icon */
- (NSString *)iconNameForButton {
    
    UserModel *user = [AppUtils readUser];
    if (user.isZuLin) {
        if (self.cellData.enumstateid == DQEnumStateMaintainAdd) {
            return @"ic_maintain_rent_btn";
        }
    }
    return @"ic_create";
}


- (NSArray *)arrayForBill {
    
    NSInteger enumStateID = self.cellData.enumstateid;
    switch (enumStateID) {
        case 35:{
            return self.maintainAry;
            break;
        }
        case 39: {
            return self.applyServiceAry;
            break;
        }
        case 43: {
            return self.applyHeightenAry;
            break;
        }
        case 37: {// 设备维保完成单提交
            return self.maintainAry;
            break;
        }
        case 41: {// 设备维修完成单提交
            return self.serviceAry;
            break;
        }
        case 45: {// 设备加高完成单提交
            return self.heightenAry;
            break;
        }
    }
    return nil;
}

#pragma mark - Actions
/// 新增维保、维修、加高单
- (void)btnClicked {
    
    if ([self isFinishFormView]) { // 跳转至设备维保完成单
        [self finishMaintainFormView];
    } else { // 跳转至设备维保单
        
        if (self.cellData.enumstateid == DQEnumStateMaintainAdd) {
            UserModel *user = [AppUtils readUser];
            if (user.isZuLin) {// 维保提醒单
                [MBProgressHUD showHUDAddedTo:self.navCtl.view animated:YES];
                UserModel *user = [AppUtils readUser];
                NSDictionary *params = @{@"userid":@(user.userid),
                                         @"type":user.type,
                                         @"projectid":@(self.projectid),
                                         @"projectdeviceid":@(self.device.projectdeviceid)};
                [[DQServiceInterface sharedInstance] dq_sendMaintainMessage:params success:^(id result) {
                    [MBProgressHUD hideHUDForView:self.navCtl.view animated:YES];
                        // 然后刷新列表 更新页面
                    [self reloadTableData];
                    DQLog(@" 维保提醒成功 ");
                } failture:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.navCtl.view animated:YES];
                    DQLog(@" 维保提醒失败 ");
                }];
            } else {// 维保提交单
                [self maintainFormView];
            }
        } else { // 维修、加高提交单
            [self maintainFormView];
        }
    }
}

#pragma basedelegate
- (void)didPopFromNextVC {
    
    // 表单提交后、pop到租赁表单VC 然后刷新列表 更新页面
    [self reloadTableData];
}

    /// 确认／驳回 confirm:1.确认 0.驳回
- (void)btnConfirmOrRefuteBack:(BOOL)confirm {
    
     // 承租方页面 维保提醒单 确认并发起维护、驳回
    if (self.cellData.enumstateid == DQEnumStateSendMaintainMessage) {
        // 维保提交单
        [self maintainFormView];
    } else {
        
    }
    
    // 选择工作人员 维修、维保、加高单提交
    if (self.cellData.enumstateid == DQEnumStateFixSubmitted) {
        DQLog(@"--提交维修申请单--");
        [self confirmStartRepairAction];
    }
    else if (self.cellData.enumstateid == DQEnumStateMaintainSubmitted) {
        DQLog(@"--提交维保申请单--");
        [self confirmStartRepairAction];
    }
    else if (self.cellData.enumstateid == DQEnumStateHeightenSubmitted) {
        DQLog(@"--提交加高申请单--");
        [self confirmStartRepairAction];
    }
    
        // 维修维保加高完成单提交
    if (self.cellData.enumstateid == DQEnumStateFixDoneSubmitted) {
        
        [self confirmAlreadyFinishMaintainForm:confirm eventType:DQEventTypeFix];
    }
    else if (self.cellData.enumstateid == DQEnumStateMaintainDoneSubmitted) {
        
        [self confirmAlreadyFinishMaintainForm:confirm eventType:DQEventTypeMaintain];
    }
    else if (self.cellData.enumstateid == DQEnumStateHeightenDoneSubmitted) {
        
        [self confirmAlreadyFinishMaintainForm:confirm eventType:DQEventTypeHeighten];
    }
    
}

/**  维修、加高、维保提交单 */
- (void)maintainFormView {
    
    DQDeviceMaintainFormViewController *formView = [[DQDeviceMaintainFormViewController alloc] initWithProjectID:self.projectid deviceID:self.device.deviceid];
    formView.formType = self.cellData.enumstateid;
    formView.basedelegate = self;
    [self.navCtl pushViewController:formView animated:YES];
}

/** 维修、加高、维保完成单 */
- (void)finishMaintainFormView {
    
    DQDeviceMaintainFinishFormController *finishFormView = [[DQDeviceMaintainFinishFormController alloc] initWithProjectID:self.projectid deviceID:self.device.deviceid orderID:0];
    finishFormView.formType = self.cellData.enumstateid;
    [self.navCtl pushViewController:finishFormView animated:YES];
}

/** 租赁方选择工作人员后、确认时间发起维保、维修、加高网络请求 */
- (void)confirmStartRepairAction {
    
    if (self.workerAry.count == 0 || self.workerAry == nil) {
        [self showAlertBarWithTitle:@"请选择工作人员"];
        return;
    }
    UserModel *user = [AppUtils readUser];
    NSMutableArray *peopleList = [UserModel mj_keyValuesArrayWithObjectArray:self.workerAry];
    NSMutableDictionary *dict = [@{@"userid" : @(user.userid),
                                   @"type" : user.type,
                                   @"usertype" : user.usertype,
                                   @"projectid" : @(self.projectid),
                                   @"deviceid" : @(self.device.deviceid),
                                   @"orderid" : @(self.cellData.linkid),
                                   @"manager" : user.mj_keyValues,
                                   @"people" : peopleList} mutableCopy];
    if (self.cellData.enumstateid == DQEnumStateHeightenSubmitted) {
        [dict removeObjectForKey:@"orderid"];
        [dict addEntriesFromDictionary:@{@"billid":@(self.cellData.linkid)}];
    }
    
    [[DQServiceInterface sharedInstance] dq_getconfirmStartMaintainWithType:self.cellData.enumstateid params:dict success:^(id result) {
         if (result) {
            [self showAlertBarWithTitle:@"操作成功"];
            [self reloadTableData];
        } else {
        }
    } failture:^(NSError *error) {
        [self showAlertBarWithTitle:@"网络异常"];
    }];
    
}

/**
 * 确认或驳回 维修、维保、加高完成单网络请求
 */
- (void)confirmAlreadyFinishMaintainForm:(BOOL)isSure eventType:(DQEventType)eventType {
    
    [MBProgressHUD showHUDAddedTo:self.navCtl.view animated:YES];
    [[DQServiceInterface sharedInstance] dq_confirmOrRefuseWithProject:@(self.projectid)
                                                              deviceID:@(self.device.deviceid)
                                                             eventtype:eventType
                                                               yesorno:isSure
                                                                billid:@([self.billID integerValue])
                                                       projectdeviceid:@(self.device.projectdeviceid) success:^(id result) {
                                                           DQLog(@" 完成单已确认 ");
                                                           [MBProgressHUD hideAllHUDsForView:self.navCtl.view animated:YES];
                                                           [self reloadTableData];
                                                       } failture:^(NSError *error) {
                                                           DQLog(@" 驳回完成单 ");
                                                           [self showMessage:[NSString stringWithFormat:@"%@失败", isSure ? @"确认" : @"驳回"]];
                                                       }];
}


#pragma mark - Private
/** 判断是 提交单事件 还是 完成单事件 */
- (BOOL)isFinishFormView {
    
    if (self.cellData.enumstateid == DQEnumStateMaintainDoneAdd
        || self.cellData.enumstateid == DQEnumStateHeightenDoneAdd
        || self.cellData.enumstateid == DQEnumStateFixDoneAdd) {
        return YES;
    } else {
        return NO;
    }
}

/** 底部弹出提示框 */
- (void)showAlertBarWithTitle:(NSString *)title {
    MDSnackbar *bar = [[MDSnackbar alloc] initWithText:title actionTitle:@"" duration:3.0];
    [bar show];
}

#pragma mark - 告知单数据

- (NSArray *)applyHeightenAry {
    
    DQSubMaintainModel *maintainModel = (DQSubMaintainModel *)self.cellData;
    DeviceMaintainorderModel *model = maintainModel.deivieaddheight;
    
    NSString *manager = [NSString stringWithFormat:@"%@ %@",model.address,model.chargeperson];
    NSArray *array = @[@{@"key" : @"设备编号", @"value" : [NSObject changeType:model.deviceno]},
                       @{@"key" : @"安装地点", @"value" : [NSObject changeType:model.address]},
                       @{@"key" : @"加高对接人", @"value" : [NSObject changeType:manager]},
                       @{@"key" : @"开始加高日期", @"value" : [NSObject changeType:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.sdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]]},
                       @{@"key" : @"结束加高日期", @"value" : [NSObject changeType:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.edate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]]},
                       @{@"key" : @"加高高度", @"value" : [NSObject changeType:[NSString stringWithFormat:@"%ld米",model.high]]}];
    return array;
}

- (NSArray *)applyServiceAry {
    
    DQSubMaintainModel *maintainModel = (DQSubMaintainModel *)self.cellData;
    DeviceMaintainorderModel *model = maintainModel.devicerepairorder;
    
    NSString *manager = [NSString stringWithFormat:@"%@ %@",model.address,model.chargeperson];
    NSArray *array = @[@{@"key" : @"设备编号", @"value" : [NSObject changeType:model.deviceno]},
                       @{@"key" : @"安装地点", @"value" : [NSObject changeType:model.address]},
                       @{@"key" : @"维修对接人", @"value" : [NSObject changeType:manager]},
                       @{@"key" : @"开始维修日期", @"value" : [NSObject changeType:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.sdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]]},
                       @{@"key" : @"结束维修日期", @"value" : [NSObject changeType:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.edate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]]},
                       @{@"key" : @"维修内容", @"value" : [NSObject changeType:[NSString stringWithFormat:@"%@",model.text]]}];
    return array;
}

- (NSArray *)applyMaintainAry {
    
    DQSubMaintainModel *maintainModel = (DQSubMaintainModel *)self.cellData;
    DeviceMaintainorderModel *model = maintainModel.deviceMaintainorder;
    
    NSString *manager = [NSString stringWithFormat:@"%@ %@",model.address,model.chargeperson];
    NSArray *array = @[@{@"key" : @"设备编号", @"value" : [NSObject changeType:model.deviceno]},
                       @{@"key" : @"安装地点", @"value" : [NSObject changeType:model.address]},
                       @{@"key" : @"维保对接人", @"value" : [NSObject changeType:manager]},
                       @{@"key" : @"开始维保日期", @"value" : [NSObject changeType:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.sdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]]},
                       @{@"key" : @"结束维保日期", @"value" : [NSObject changeType:[DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd HH:mm" WithOriginStr:model.edate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"]]},
                       @{@"key" : @"维保内容", @"value" : [NSObject changeType:[NSString stringWithFormat:@"%@",model.text]]}
                       ];
    return array;
}

#pragma mark - 完成单数据
- (NSArray *)maintainAry {
    
    DQSubMaintainModel *maintainModel = (DQSubMaintainModel *)self.cellData;
    DeviceMaintainorderModel *model = maintainModel.deviceMaintainorder;
    // 完成单
    DQFinishOrderModel *finishOrder = [DQFinishOrderModel mj_objectWithKeyValues:model.finshorder];
    
    NSString *manager = [NSString stringWithFormat:@"%@ %@",model.chargeperson,model.linkdn];
    NSMutableArray *resultAry = [@[@{@"key" : @"维保对接人", @"value" : [NSObject changeType:manager]}] mutableCopy];
    for (int index = 0; index < model.workers.count; index++) {
        UserModel *user = [model.workers objectAtIndex:index];
        //UserModel *user = [UserModel mj_objectWithKeyValues:userDict];
        NSString *worker = [NSString stringWithFormat:@"%@ %@",user.name,user.dn];
        if (index == 0) {
            [resultAry addObject:@{@"key" : @"维保人员", @"value" : [NSObject changeType:worker]}];
        } else {
            [resultAry addObject:@{@"key" : @"", @"value" : [NSObject changeType:worker]}];
        }
    }
    NSArray *array = @[@{@"key" : @"开始维保日期", @"value" : [NSObject changeType:model.sdate]},
                       @{@"key" : @"完成维保日期", @"value" :[NSObject changeType:model.edate]},
                       @{@"key" : @"维保结果", @"value" : [NSObject changeType:finishOrder.result]},
                       @{@"key" : @"配件消耗", @"value" : [NSObject changeType:finishOrder.expend]},
                       @{@"key" : @"维保说明", @"value" : [NSObject changeType:finishOrder.des]}
                       ];
    
    [resultAry addObjectsFromArray:array];
    
    return resultAry;
}

- (NSArray *)serviceAry {
    
    DQSubMaintainModel *maintainModel = (DQSubMaintainModel *)self.cellData;
    DeviceMaintainorderModel *model = maintainModel.devicerepairorder;
    // 完成单
    DQFinishOrderModel *finishOrder = [DQFinishOrderModel mj_objectWithKeyValues:model.finshorder];
    
    NSString *manager = [NSString stringWithFormat:@"%@ %@",model.chargeperson,model.linkdn];
    NSMutableArray *resultAry = [@[@{@"key" : @"维修对接人", @"value" : [NSObject changeType:manager]}] mutableCopy];
 
    for (int index = 0; index < model.workers.count; index++) {
        UserModel *user = [model.workers objectAtIndex:index];
        //UserModel *user = [UserModel mj_objectWithKeyValues:userDict];
        NSString *worker = [NSString stringWithFormat:@"%@ %@",user.name,user.dn];
        if (index == 0) {
            [resultAry addObject:@{@"key" : @"维修人员", @"value" : [NSObject changeType:worker]}];
        } else {
            [resultAry addObject:@{@"key" : @"", @"value" : [NSObject changeType:worker]}];
        }
    }
    
    NSArray *array = @[@{@"key" : @"开始维修日期", @"value" : [NSObject changeType:model.sdate]},
                       @{@"key" : @"完成维修日期", @"value" :[NSObject changeType:model.edate]},
                       @{@"key" : @"维修结果", @"value" : [NSObject changeType:finishOrder.result]},
                       @{@"key" : @"配件消耗", @"value" : [NSObject changeType:finishOrder.expend]},
                       @{@"key" : @"维修说明", @"value" : [NSObject changeType:finishOrder.des]}
                       ];
    [resultAry addObjectsFromArray:array];
    
    return resultAry;
}

- (NSArray *)heightenAry {
    
    DQSubMaintainModel *maintainModel = (DQSubMaintainModel *)self.cellData;
    DeviceMaintainorderModel *model = maintainModel.deivieaddheight;
    // 完成单
    DQFinishOrderModel *finishOrder = [DQFinishOrderModel mj_objectWithKeyValues:model.finshorder];
    
    NSString *manager = [NSString stringWithFormat:@"%@ %@",model.chargeperson,model.linkdn];
    NSMutableArray *resultAry = [@[@{@"key" : @"维保对接人", @"value" : [NSObject changeType:manager]}] mutableCopy];
    for (int index = 0; index < model.workers.count; index++) {
        UserModel *user = [model.workers objectAtIndex:index];
        //UserModel *user = [UserModel mj_objectWithKeyValues:userDict];
        NSString *worker = [NSString stringWithFormat:@"%@ %@",user.name,user.dn];
        if (index == 0) {
            [resultAry addObject:@{@"key" : @"维保人员", @"value" : [NSObject changeType:worker]}];
        } else {
            [resultAry addObject:@{@"key" : @"", @"value" : [NSObject changeType:worker]}];
        }
    }
    NSArray *array = @[@{@"key" : @"开始加高日期", @"value" : [NSObject changeType:model.sdate]},
                       @{@"key" : @"完成加高日期", @"value" :[NSObject changeType:model.edate]},
                       @{@"key" : @"加高结果", @"value" : [NSObject changeType:finishOrder.result]},
                       @{@"key" : @"配件消耗", @"value" : [NSObject changeType:finishOrder.expend]},
                       @{@"key" : @"加高说明", @"value" : [NSObject changeType:finishOrder.des]}
                       ];
    [resultAry addObjectsFromArray:array];
    
    return resultAry;
}

@end

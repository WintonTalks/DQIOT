//
//  DQBusinessContractModel.m
//  WebThings
//  商务往来业务Model
//  Created by Heidi on 2017/10/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQLogicBusinessContractModel.h"
#import "DQBusinessContractModel.h"
#import "DQSubBusinessContractModel.h"

#import "DQNewBusContactController.h"
#import "DQDeviceMaintainFinishFormController.h"

#import "DQBusinessContactInterface.h"

@implementation DQLogicBusinessContractModel

#pragma mark - Getter
+ (DQLogicBusinessContractModel *)dq_buttonLogicWithEnumState:(DQEnumState)state
                                                flowType:(DQFlowType)flowType {
    
    DQLogicBusinessContractModel *logic = [[DQLogicBusinessContractModel alloc] init];
    
    DQSubBusinessContractModel *tempM = [[DQSubBusinessContractModel alloc] init];
    tempM.enumstateid = state;
    tempM.isButtonCell = YES;
    
    logic.cellData = tempM;
    
    return logic;
}

- (NSString *)cellIdentifier {
    NSInteger stateID = self.cellData.enumstateid;
    if (stateID == DQEnumStateBusContactConfirmed ||
        stateID == DQEnumStateBusContactFinishPass ||
        stateID == DQEnumStateBusContactFinishRefuse ||
        stateID == DQEnumStateBusContactAdviceComfirmed) {    // 沟通单确认和驳回
        return @"DQRefuteBackCell";
    }
    else if (stateID == DQEnumStateBusContactSubmited ||       // 商函／整改意见提交后待确认
             stateID == DQEnumStateBusContactAdviceSubmited) {
        return @"DQBusContactCell";
    }
    else if (stateID == DQEnumStateBusContactFinishSubmited) {// 整改完成单提交后待确认
        return @"DQBusContactDoneCell";
    }
    else if (stateID == DQEnumStateBusContGoing)    // “商务往来中”
    {
        return @"DQBusContGoingCell";
    }
    return [super cellIdentifier];
}

// 当前业务展示界面的高度
- (CGFloat)cellHeight {
    CGFloat pix = 16;
    NSInteger stateID = self.cellData.enumstateid;
    if (stateID == DQEnumStateBusContactConfirmed ||
        stateID == DQEnumStateBusContactFinishPass ||
        stateID == DQEnumStateBusContactFinishRefuse ||
        stateID == DQEnumStateBusContactAdviceComfirmed) {        // 沟通单确认和驳回状态
        return 76 + pix;
    }
    else if (stateID == DQEnumStateBusContactSubmited ||       // 商函／整改意见提交后待确认
             stateID == DQEnumStateBusContactAdviceSubmited) {
        NSString *str = self.cellData.content;
        CGSize size = [AppUtils
                       textSizeFromTextString:str
                       width:screenWidth - 58 - 48
                       height:1000
                       font:[UIFont dq_semiboldSystemFontOfSize:12]];
        
        CGFloat height = 76 + 32 + size.height + 16;
        if (stateID == DQEnumStateBusContactSubmited) { // 时间小标签
            height += 60;
        }
        if (self.showConfirm) {            // 确认按钮
            height += 44 + 10;  // 字体和线间距10
        } else {
            height += pix;
        }
        return height;
    }
    else if (stateID == DQEnumStateBusContactFinishSubmited) { // 整改完成单提交后待确认
        DQSubBusinessContractModel *model = (DQSubBusinessContractModel *)self.cellData;
        CGFloat height = [self heightForBill] + [self heightForImageCount:[model.imgLists count]];
        return height;
    }
    else if (stateID == DQEnumStateBusContGoing)    // “商务往来中”
    {
        return 102 + pix;
    }
    
    return 44.0f;
}

/** 表单数据 */
- (NSArray *)arrayForBill {
    
    DQSubBusinessContractModel *model = (DQSubBusinessContractModel *)self.cellData;
    NSString *manager = [NSString stringWithFormat:@"%@ %@",model.sendname,model.telephone];
    NSMutableArray *resultAry = [@[@{@"key" : @"整改负责人", @"value" : [NSObject changeType:manager]}] mutableCopy];
    for (int index = 0; index < model.works.count; index++) {
        UserModel *user = [model.works objectAtIndex:index];
        NSString *worker = [NSString stringWithFormat:@"%@ %@",user.name,user.dn];
        if (index == 0) {
            [resultAry addObject:@{@"key" : @"整改人员", @"value" : [NSObject changeType:worker]}];
         } else {
            [resultAry addObject:@{@"key" : @"", @"value" : [NSObject changeType:worker]}];
        }
    }
    NSArray *array = @[@{@"key" : @"开始整改日期", @"value" : [NSObject changeType:model.startDate]},
                       @{@"key" : @"完成整改日期", @"value" :[NSObject changeType:model.endDate]},
                       @{@"key" : @"整改结果", @"value" : [NSObject changeType:model.reuslt]},
                       @{@"key" : @"配件消耗", @"value" : [NSObject changeType:model.expend]},
                       @{@"key" : @"整改说明", @"value" : [NSObject changeType:model.desc]}];
   
    [resultAry addObjectsFromArray:array];
    return resultAry;
}

- (BOOL)isClearBillColor {
    return YES;
}

/** 按钮标题 */
- (NSString *)titleForButton {
    NSString *title = @"";
    switch (self.cellData.enumstateid) {
        case DQEnumStateBusContactAdd:  // 商务往来
        {
            title = @"商务往来";
        }
            break;
        case DQEnumStateBusConAdviceAdd:// 整改意见
        {
            title = @"整改意见";
        }
            break;
        case DQEnumStateBusConFinishAdd:// 填写整改完成单
        {
            title = @"填写整改完成单";
        }
            break;
        default:
            break;
    }
    return title;
}

/** 按钮icon */
- (NSString *)iconNameForButton {
    return @"ic_create";
}

// 商函通知／整改意见的“确认”是否显示
- (BOOL)showConfirm {
    return (self.cellData.enumstateid == DQEnumStateBusContactSubmited ||
            self.cellData.enumstateid == DQEnumStateBusContactAdviceSubmited)
    && self.isLast
    && [AppUtils readUser].userid != [self.cellData.senduserid integerValue];
}

// 整改完成单的确认／驳回
- (BOOL)showRefuteBackButton {
    // 是否显示完成整改单确认和驳回, 确认驳回由商函通知`发起的一方 TODO: userid改成type
    return self.isLast && [AppUtils readUser].userid == self.startUser.userid
    && self.cellData.enumstateid == DQEnumStateBusContactFinishSubmited;
}

#pragma mark -
/// 商务往来／整改意见／填写整改完成单
- (void)btnClicked {
    NSInteger stateID = self.cellData.enumstateid;
    switch (stateID) {
        case DQEnumStateBusContactAdd:        // 商务往来
        case DQEnumStateBusConAdviceAdd:        // 整改意见
        {
            DQNewBusContactController *ctl = [[DQNewBusContactController alloc] init];
            ctl.enumState = self.cellData.enumstateid;
            ctl.projectID = self.projectid;
            ctl.businessID = self.businessID;
            ctl.basedelegate = self;
            ctl.titleStr = stateID == DQEnumStateBusContactAdd ? @"商务往来" : @"整改意见";
            [self.navCtl pushViewController:ctl animated:YES];
        }
            break;
        case DQEnumStateBusConFinishAdd:    // 填写整改完成单
        {
            DQDeviceMaintainFinishFormController *ctl = [[DQDeviceMaintainFinishFormController alloc] initWithProjectID:self.projectid deviceID:self.device.deviceid orderID:[self.businessID integerValue]];
            ctl.formType = DQEnumStateBusConFinishAdd;
            ctl.basedelegate = self;
            ctl.submitRequestBlock = ^(id result) {
                [[DQBusinessContactInterface sharedInstance]
                 dq_addCompletionNoteFinishOrder:result success:^(id code) {
                     if ([code boolValue]) {
                         [self reloadTableData];
                     }
                 } failture:^(NSError *error) {
                     
                 }];
            };
            [self.navCtl pushViewController:ctl animated:YES];
        }
            break;
        case DQEnumStateBusContactSubmited: // 商函通知提交
        {
            [MBProgressHUD showHUDAddedTo:self.navCtl.view animated:YES];
            
            [[DQBusinessContactInterface sharedInstance]
             dq_busContConfirmWithProjID:@(self.projectid)
             businessid:self.businessID
             success:^(id result) {
                 [self hideHud];
                 
                 if ([result boolValue]) {
                     [self reloadTableData];
                 } else {
                     [self showMessage:@"提交失败"];
                 }
             } failture:^(NSError *error) {
                 [self hideHud];
                 [self showMessage:STRING_REQUESTFAIL];
             }];
        }
            break;
        case DQEnumStateBusContactAdviceSubmited:   // 整改意见已提交
        {
            [MBProgressHUD showHUDAddedTo:self.navCtl.view animated:YES];
            
            [[DQBusinessContactInterface sharedInstance]
             dq_busContAdviceConfirmWithProjID:@(self.projectid)
             orderid:self.businessID
             success:^(id result) {
                 [self hideHud];

                 if ([result boolValue]) {
                     [self reloadTableData];
                 } else {
                     [self showMessage:@"提交失败"];
                 }
             } failture:^(NSError *error) {
                 [self hideHud];
                 [self showMessage:STRING_REQUESTFAIL];
             }];
        }
            break;
        default:
            break;
    }
}

/// 整改完成单确认／驳回 confirm:1.确认 0.驳回
- (void)btnConfirmOrRefuteBack:(BOOL)confirm {
    [MBProgressHUD showHUDAddedTo:self.navCtl.view animated:YES];

    [[DQBusinessContactInterface sharedInstance]
     dq_busContFinishConfirmWithProjID:@(self.projectid)
     orderid:[NSString stringWithFormat:@"%ld", self.cellData.linkid]
     confirm:confirm
     success:^(id result) {
         [self hideHud];

         if ([result boolValue]) {
             [self reloadTableData];
         } else {
             [self showMessage:[NSString stringWithFormat:@"%@失败", confirm ? @"确认" : @"驳回"]];
         }
     } failture:^(NSError *error) {
         [self hideHud];
         [self showMessage:STRING_REQUESTFAIL];
     }];
}

#pragma mark -
- (void)didPopFromNextVC {
    [self reloadTableData];
}

@end

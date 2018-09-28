//
//  DQLogicRentModel.m
//  WebThings
//  管理服务流子节点的父类
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQLogicRentModel.h"
#import "DQSubRentModel.h"

#import "AddQiZuListViewController.h"
#import "DQHireFormViewController.h" // 启租

#import "EMIBaseViewController.h"

@interface DQLogicRentModel () <EMIBaseViewControllerDelegate>

@end

@implementation DQLogicRentModel

#pragma mark - Getter
- (NSString *)cellIdentifier {
    NSInteger stateID = self.cellData.enumstateid;
    
    if (stateID == 27 || stateID == 28) {
        return @"DQRefuteBackCell";
    } else if (stateID == 26) {         // 安装凭证单（含确认／驳回）
        return @"DQDeviceRentCell";
    }
    
    return [super cellIdentifier];
}

// 当前业务展示界面的高度
- (CGFloat)cellHeight {
    NSInteger stateID = self.cellData.enumstateid;
    if (stateID == 27 || stateID == 28) { // 设备启租单 确认或驳回结果
        return 76 + 16;
    } else if (stateID == 26) {          // 安装凭证单（含确认／驳回）
        CGFloat height = 76 + 16 + [self heightForBill] + 16;
        if (self.showRefuteBackButton) {
            height += 54;
        }
        return height;
    }
    return 44.0f;
}

- (NSArray *)arrayForBill {
    DQSubRentModel *model = (DQSubRentModel *)self.cellData;
    ProjectStartRentHistoryModel *rentHistory = model.projectstartrenthistory;
    NSArray *array = @[@{@"key" : @"设备编号", @"value" : [NSObject changeType:rentHistory.deviceno]},
                       @{@"key" : @"安装地点", @"value" : [NSObject changeType:model.deviceaddress]},
                       @{@"key" : @"项目负责人", @"value" : [NSObject changeType:rentHistory.chargeperson]},
                       @{@"key" : @"联系电话", @"value" : [NSObject changeType:rentHistory.linkman]},
                       @{@"key" : @"启租日期", @"value" : [NSObject changeType:rentHistory.startdate]},
                       @{@"key" : @"产权备案号", @"value" : [NSObject changeType:rentHistory.deviceno]},
                       @{@"key" : @"检测单位", @"value" : [NSObject changeType:rentHistory.recordno]},
                       @{@"key" : @"检测报告编号", @"value" : [NSObject changeType:rentHistory.checkcompany]}];
    return array;
}

/** 按钮标题 */
- (NSString *)titleForButton {
//    if (self.cellData.enumstateid == DQEnumStateDeviceLock) {
//        return @"设备锁机";
//    }
    return self.cellData.enumstateid == DQEnumStateRentAdd ? @"新增启租单" : @"修改启租单";
}

/** 按钮icon */
- (NSString *)iconNameForButton {
//    if (self.cellData.enumstateid == DQEnumStateDeviceLock) {
//        return @"flow_of_service_ic_lock";
//    }
    return @"ic_create";
}

#pragma mark -
/// 新增启租单
- (void)btnClicked {
    
    DQSubRentModel *model = (DQSubRentModel *)self.cellData;
    DQHireFormViewController *hireFormView = [[DQHireFormViewController alloc] init];
    hireFormView.dm = self.device;
    hireFormView.projectid = self.projectid;
    hireFormView.basedelegate = self;
    hireFormView.portalModel = model;
    
    if (self.cellData.enumstateid == DQEnumStateRentAdd) {  // 新增启租单
        hireFormView.rentFormStyle = DQEnumStateRentAdd;
        [self.navCtl pushViewController:hireFormView animated:YES];
    }
    else if (self.cellData.enumstateid == DQEnumStateRentModify) { // 修改启租单
        hireFormView.rentFormStyle = DQEnumStateRentModify;
        [self.navCtl pushViewController:hireFormView animated:YES];
    }
}

- (void)didPopFromNextVC {
    
}

@end

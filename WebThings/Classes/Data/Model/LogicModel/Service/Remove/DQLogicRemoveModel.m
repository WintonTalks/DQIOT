//
//  DQLogicRemoveModel.m
//  WebThings
//  管理服务流子节点的父类
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQLogicRemoveModel.h"
#import "DQSubRemoveModel.h"
#import "DeviceMaintainorderModel.h"

#import "DQHireFormViewController.h"

@interface DQLogicRemoveModel () <EMIBaseViewControllerDelegate>

@end

@implementation DQLogicRemoveModel

#pragma mark - Getter
- (NSString *)cellIdentifier {
    NSInteger stateID = self.cellData.enumstateid;
    if (stateID == DQEnumStateRemoveSubmitted) {    // 停租单
        return @"DQDeviceRemoveCell";
    }
    else if (stateID == DQEnumStateCostReport) {    // 费用清算报告
        return @"DQDeviceRemoveInfoCell";
    }
    else if (stateID == DQEnumStateRemovePass) {  // 费用已缴清
        return @"DQRefuteBackCell";
    }
    else if (stateID == DQEnumStateRemoveRefuse) {   // 费用未缴清
        return @"DQRemoveArrearageCell";
    }
    return [super cellIdentifier];
}

// 当前业务展示界面的高度
- (CGFloat)cellHeight {
    NSInteger stateID = self.cellData.enumstateid;

    if (stateID == DQEnumStateRemoveSubmitted) {    // 停租单
        CGFloat height = [self heightForBill] + 76 + 32;
        if (self.showRefuteBackButton) {    // 显示驳回（费用未缴清）和确认（费用已缴清）按钮
            height += 54;
        }
        return height;
    } else if (stateID == DQEnumStateCostReport) {    // 费用清算报告
        return kHEIHGT_REPORTCELL * 3 + 52 + 25 + 16;
    }
    // 确认|驳回结果
    else if (stateID == DQEnumStateRemovePass) {  // 费用已缴清
        return 76 + 16;
    }
    else if (stateID == DQEnumStateRemoveRefuse) {   // 费用未缴清
        if ([AppUtils readUser].isZuLin && self.isLast) { // 是租赁方且为最后一条，则确认添加费用已缴清按钮
            return 76 + 36 + 16;
        }
        return 76 + 16;
    }
    
    return 44.0f;
}

- (NSArray *)arrayForBill {
    DQSubRemoveModel *model = (DQSubRemoveModel *)self.cellData;
    DeviceMaintainorderModel *removeHistory = model.dismantledevice;
    NSArray *array = @[@{@"key" : @"设备编号", @"value" : [NSObject changeType:removeHistory.deviceno]},
                       @{@"key" : @"项目负责人", @"value" : [NSObject changeType:removeHistory.chargeperson]},
                       @{@"key" : @"拆除地点", @"value" : [NSObject changeType:model.deviceaddress]},
                       @{@"key" : @"拆机日期", @"value" : [NSObject changeType:removeHistory.cdate]}];
    return array;
}

/** 按钮标题 */
- (NSString *)titleForButton {
    return @"新增停租单";
}

/** 按钮icon */
- (NSString *)iconNameForButton {
    return @"ic_create";
}

#pragma mark -
/// 新增停租单
- (void)btnClicked {
    DQHireFormViewController *hireFormView = [[DQHireFormViewController alloc] init];
    hireFormView.dm = self.device;
    hireFormView.projectid = self.projectid;
    hireFormView.basedelegate = self;
    hireFormView.rentFormStyle = DQEnumStateRemoveAdd;
    [self.navCtl pushViewController:hireFormView animated:YES];
}

- (void)didPopFromNextVC {
    [self reloadTableData];
}

@end
